//
//  OpenCVTool.cpp
//  OpenCVDemo
//
//  Created by 陈诚 on 15/6/23.
//  Copyright (c) 2015年 陈诚 . All rights reserved.
//

#include "OpenCVTool.h"


UIImage* OpenCVTool::imageScaleToSize(UIImage*img, CGSize size)
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
    
    
    /* IplImage *iplImage = ImageTool::createIplImageFromUIImage(img);
     
     IplImage * scaledIplImage = cvCreateImage(cvSize(size.width, size.height), iplImage->depth, iplImage->nChannels);
     cvResize(iplImage, scaledIplImage, CV_INTER_NN);
     
     UIImage *scaledImage = ImageTool::createUIImageFromIplImage(iplImage, img.imageOrientation);
     
     cvReleaseImage(&iplImage);
     cvReleaseImage(&scaledIplImage);
     
     return scaledImage;*/
}

IplImage  *OpenCVTool::cvQueryFrameRepeatMode(CvCapture **capture, const char *filePath)
{
    IplImage  *iplImage = cvQueryFrame(*capture);
    
    if (iplImage == NULL)
    {
        cvReleaseCapture(capture);
        
        *capture = cvCreateFileCapture(filePath);
        
        iplImage = cvQueryFrame(*capture);
    }
    
    return iplImage;
}

UIImage* OpenCVTool::imageReducedSize(UIImage*img, CGSize size)
{
    IplImage  *srcIplImage = OpenCVTool::createBGRIplImageFromUIImage(img);
    IplImage  *destIplImage = cvCreateImage(cvSize(size.width, size.height), srcIplImage->depth, srcIplImage->nChannels);
    
    for (int i=0; i<destIplImage->height; i++)
    {
        unsigned char *dest = (unsigned char *)(destIplImage->imageData + i * destIplImage->widthStep);
        unsigned char *src = (unsigned char *)(srcIplImage->imageData + i * srcIplImage->widthStep);
        
        for (int j=0; j<destIplImage->width; j++)
        {
            dest[j * 3 + 0] = src[j * 3 + 0];
            dest[j * 3 + 1] = src[j * 3 + 1];
            dest[j * 3 + 2] = src[j * 3 + 2];
        }
    }
    
    UIImage *destImage = OpenCVTool::createRGBUIImageFromIplImage(destIplImage);
    
    cvReleaseImage(&srcIplImage);
    cvReleaseImage(&destIplImage);
    
    return destImage;
}

void OpenCVTool::mergeImageLayer(const IplImage *inputImage1, const IplImage *inputImage2, IplImage *outPutImage, unsigned char alphaColor[3])
{
    for (int i=0; i<outPutImage->height; i++)
    {
        unsigned char *dest = (unsigned char *)(outPutImage->imageData + i * outPutImage->widthStep);
        unsigned char *src1 = (unsigned char *)(inputImage1->imageData + i * inputImage1->widthStep);
        unsigned char *src2 = (unsigned char *)(inputImage2->imageData + i * inputImage2->widthStep);
        
        for (int j=0; j<outPutImage->width; j++)
        {
           /* if (src1[j * 3 + 0]==alphaColor[0]
                && src1[j * 3 + 1]==alphaColor[1]
                && src1[j * 3 + 2]==alphaColor[2])
            {
                dest[j * 3 + 0] = src2[j * 3 + 0];
                dest[j * 3 + 1] = src2[j * 3 + 1];
                dest[j * 3 + 2] = src2[j * 3 + 2];
            }
            else
            {
                dest[j * 3 + 0] = src1[j * 3 + 0];
                dest[j * 3 + 1] = src1[j * 3 + 1];
                dest[j * 3 + 2] = src1[j * 3 + 2];
            }*/
            
            
            if (abs(src1[j * 3 + 0] - alphaColor[0]) < 3
                && abs(src1[j * 3 + 1] - alphaColor[1]) < 3
                && abs(src1[j * 3 + 2] - alphaColor[2]) < 3)
            {
                dest[j * 3 + 0] = src2[j * 3 + 0];
                dest[j * 3 + 1] = src2[j * 3 + 1];
                dest[j * 3 + 2] = src2[j * 3 + 2];
            }
            else
            {
                dest[j * 3 + 0] = src1[j * 3 + 0];
                dest[j * 3 + 1] = src1[j * 3 + 1];
                dest[j * 3 + 2] = src1[j * 3 + 2];
            }
            
        }
    }
}

void OpenCVTool::mergeBGRAImageLayer(const IplImage *inputImage1, const IplImage *inputImage2, IplImage *outPutImage)
{
    for (int i=0; i<outPutImage->height; i++)
    {
        unsigned char *dest = (unsigned char *)(outPutImage->imageData + i * outPutImage->widthStep);
        
        unsigned char *src1 = (unsigned char *)(inputImage1->imageData + i * inputImage1->widthStep);
        unsigned char *src2 = (unsigned char *)(inputImage2->imageData + i * inputImage2->widthStep);
        
        for (int j=0; j<outPutImage->width; j++)
        {
            dest[j * 4 + 0] = src1[j * 4 + 0] * src1[j * 4 + 3]/255.0 + src2[j * 4 + 0] * (255.0-src1[j * 4 + 3])/255.0;
            dest[j * 4 + 1] = src1[j * 4 + 1] * src1[j * 4 + 3]/255.0 + src2[j * 4 + 1] * (255.0-src1[j * 4 + 3])/255.0;
            dest[j * 4 + 2] = src1[j * 4 + 2] * src1[j * 4 + 3]/255.0 + src2[j * 4 + 2] * (255.0-src1[j * 4 + 3])/255.0;
            
            if (src1[j * 4 + 3] == 255 || src2[j * 4 + 3] == 255)
            {
                dest[j * 4 + 3] = 255;
            }
            else
            {
                dest[j * 4 + 3] = (src1[j * 4 + 3] + src2[j * 4 + 3])/2.0;
            }
        }
    }
}


//逆时针旋转图像degree角度（原尺寸）
void OpenCVTool::rotateImage(const IplImage *inputImage, IplImage *outPutImage, double degree, CvScalar fillval)
{
    //旋转中心为图像中心
    CvPoint2D32f center;
    center.x= float(inputImage->width/2.0+0.5);
    center.y= float(inputImage->height/2.0+0.5);
    
    //计算二维旋转的仿射变换矩阵
    float m[6];
    CvMat M = cvMat(2, 3, CV_32F, m);
    
    cv2DRotationMatrix(center, degree,1, &M);
    
    //变换图像，并用fillval填充其余值
    cvWarpAffine(inputImage, outPutImage, &M, CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS, fillval);
}

IplImage* OpenCVTool::rotateImageAndResize(IplImage* img,int degree)
{
    double angle = degree  * CV_PI / 180.; // 弧度
    double a = sin(angle), b = cos(angle);
    int width = img->width;
    int height = img->height;
    int width_rotate= int(height * fabs(a) + width * fabs(b));
    int height_rotate=int(width * fabs(a) + height * fabs(b));
    //旋转数组map
    // [ m0  m1  m2 ] ===>  [ A11  A12   b1 ]
    // [ m3  m4  m5 ] ===>  [ A21  A22   b2 ]
    float map[6];
    CvMat map_matrix = cvMat(2, 3, CV_32F, map);
    // 旋转中心
    CvPoint2D32f center = cvPoint2D32f(width / 2, height / 2);
    cv2DRotationMatrix(center, degree, 1.0, &map_matrix);
    map[2] += (width_rotate - width) / 2;
    map[5] += (height_rotate - height) / 2;
    IplImage* img_rotate = cvCreateImage(cvSize(width_rotate, height_rotate), 8, 3);
    //对图像做仿射变换
    //CV_WARP_FILL_OUTLIERS - 填充所有输出图像的象素。
    //如果部分象素落在输入图像的边界外，那么它们的值设定为 fillval.
    //CV_WARP_INVERSE_MAP - 指定 map_matrix 是输出图像到输入图像的反变换，
    cvWarpAffine( img,img_rotate, &map_matrix, CV_INTER_LINEAR | CV_WARP_FILL_OUTLIERS, cvScalarAll(0));
    return img_rotate;
}

void OpenCVTool::translationImage(const IplImage *inputImage, IplImage *outPutImage, int tx, int ty, CvScalar fillval)
{
    //计算二维旋转的仿射变换矩阵
    float m[6] = {1, 0, tx,
        0, 1, ty};
    CvMat M = cvMat(2, 3, CV_32F, m);
    
    
    //变换图像，并用黑色填充其余值
    cvWarpAffine(inputImage, outPutImage, &M,CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS, fillval);
}

void OpenCVTool::scaleImage(const IplImage *inputImage, IplImage *outPutImage, float sx, float sy, CvScalar fillval)
{
    if (sx == 0 || sy == 0)
    {
        return;
    }
    
    //计算二维旋转的仿射变换矩阵
    CvPoint2D32f pointSrc[] = {cvPoint2D32f(0,0), cvPoint2D32f(inputImage->width-1,0), cvPoint2D32f(inputImage->width-1,inputImage->height-1)};
    CvPoint2D32f pointDst[] = {cvPoint2D32f((inputImage->width-sx*inputImage->width)/2.0,(inputImage->height-sy*inputImage->height)/2.0),
        cvPoint2D32f((inputImage->width-sx*inputImage->width)/2.0 +  sx*inputImage->width, (inputImage->height-sy*inputImage->height)/2.0),
        cvPoint2D32f((inputImage->width-sx*inputImage->width)/2.0 +  sx*inputImage->width,  (inputImage->height-sy*inputImage->height)/2.0 + sy*inputImage->height)};
    
    //计算二维旋转的仿射变换矩阵
    float m[6];
    CvMat M = cvMat(2, 3, CV_32F, m);
    
    cvGetAffineTransform(pointSrc, pointDst, &M);
    
    //变换图像，并用颜色fillval填充其余值
    cvWarpAffine(inputImage, outPutImage, &M, CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS, fillval);
}

void OpenCVTool::scaleAspectFitToSize(const IplImage *inputImage, IplImage *outPutImage, CvScalar fillval)
{
    float  k1 = (float)(inputImage->width) / (float)(inputImage->height);
    
    IplImage *tmpImage = cvCreateImage(cvSize(outPutImage->width, outPutImage->height), inputImage->depth, inputImage->nChannels);
    
    cvResize(inputImage, tmpImage);
    
    float k2 = (float)(outPutImage->width)/(float)(outPutImage->height);
    
    
    if (k1 < k2)//比较高
    {
        OpenCVTool::scaleImage(tmpImage, outPutImage, (k1 * (float)outPutImage->height)/(float)(outPutImage->width), 1, fillval);
    }
    else
    {
        OpenCVTool::scaleImage(tmpImage, outPutImage, 1, (float)((float)outPutImage->width/k1)/(float)outPutImage->height, fillval);
    }
    
    cvReleaseImage(&tmpImage);
}

void OpenCVTool::scaleAspectFillToSize(const IplImage *inputImage, IplImage *outPutImage)
{
    float  k1 = (float)(inputImage->width) / (float)(inputImage->height);

    float k2 = (float)(outPutImage->width)/(float)(outPutImage->height);
    
    if (k1 < k2)//比较高
    {
        IplImage *tmpImage = cvCreateImage(cvSize(outPutImage->width, outPutImage->width/k1), inputImage->depth, inputImage->nChannels);
        
        cvResize(inputImage, tmpImage);
        
        cvSetImageROI(tmpImage , cvRect(0, (outPutImage->width/k1 - outPutImage->height)/2.0, outPutImage->width, outPutImage->height));
        
        cvCopy(tmpImage, outPutImage);
        
        cvReleaseImage(&tmpImage);
    }
    else
    {
        IplImage *tmpImage = cvCreateImage(cvSize(outPutImage->height * k1, outPutImage->height), inputImage->depth, inputImage->nChannels);
        
        cvResize(inputImage, tmpImage);
        
        cvSetImageROI(tmpImage , cvRect((outPutImage->height * k1 - outPutImage->width)/2.0, 0, outPutImage->width, outPutImage->height));
        
        cvCopy(tmpImage, outPutImage);
        
        cvReleaseImage(&tmpImage);
    }
}


int OpenCVTool::rgb2gray(const IplImage *srcIplImage, IplImage *destIplImage)
{
    for (int i=0; i<destIplImage->height; i++)
    {
        unsigned char *dest = (unsigned char *)(destIplImage->imageData + i * destIplImage->widthStep);
        unsigned char *src = (unsigned char *)(srcIplImage->imageData + i * srcIplImage->widthStep);
        
        for (int j=0; j<destIplImage->width; j++)
        {
            float   g = (src[j * 3 + 0] + src[j * 3 + 1] + src[j * 3 + 2])/3.0;
            
            dest[j * 3 + 0] = g;
            dest[j * 3 + 1] = g;
            dest[j * 3 + 2] = g;
        }
    }
    return 0;
}

UIImage *OpenCVTool::rotateImage(UIImage *image)
{
    CGImageRef imgRef = image.CGImage;
    UIImageOrientation orient = image.imageOrientation;
    UIImageOrientation newOrient = UIImageOrientationUp;
    switch (orient) {
        case 3://竖拍 home键在下
            newOrient = UIImageOrientationRight;
            break;
        case 2://倒拍 home键在上
            newOrient = UIImageOrientationLeft;
            break;
        case 0://左拍 home键在右
            newOrient = UIImageOrientationUp;
            break;
        case 1://右拍 home键在左
            newOrient = UIImageOrientationDown;
            break;
        default:
            newOrient = UIImageOrientationRight;
            break;
    }
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    switch(newOrient)
    {
        case UIImageOrientationUp:
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
            
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRight:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (newOrient == UIImageOrientationRight || newOrient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}



IplImage *OpenCVTool::createBGRIplImageFromUIImage(UIImage *image)
{
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    IplImage *iplimage = cvCreateImage(cvSize((int)CGImageGetWidth(imageRef), (int)CGImageGetHeight(imageRef)), IPL_DEPTH_8U, 4);
    
    CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height, iplimage->depth, iplimage->widthStep, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, (int)CGImageGetWidth(imageRef), (int)CGImageGetHeight(imageRef)), imageRef);
    
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    
    cvCvtColor(iplimage, ret, CV_RGBA2BGR); //颜色空间转换 重要!!
    
    cvReleaseImage(&iplimage);
    
    return ret;
}


IplImage *OpenCVTool::createBGRAIplImageFromUIImage(UIImage *image)
{
    
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    IplImage *iplimage = cvCreateImage(cvSize((int)CGImageGetWidth(imageRef), (int)CGImageGetHeight(imageRef)), IPL_DEPTH_8U, 4);
    
    CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height, iplimage->depth, iplimage->widthStep, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, (int)CGImageGetWidth(imageRef), (int)CGImageGetHeight(imageRef)), imageRef);
    
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 4);
    
    cvCvtColor(iplimage, ret, CV_RGBA2BGRA); //颜色空间转换 重要!!
    
    cvReleaseImage(&iplimage);
    
    return ret;
}

UIImage *OpenCVTool::createRGBUIImageFromIplImage(IplImage *image)
{
    //CCLogMessage(CCLogLevelDebug, @"IplImage (%d, %d) %d bits by %d channels, %d bytes/row %s", image->width, image->height, image->depth, image->nChannels, image->widthStep, image->channelSeq);
    
    IplImage *image2 = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 3);
    
    cvCvtColor(image, image2, CV_BGRA2RGB);//颜色空间转换 重要!!
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSData *data = [NSData dataWithBytes:image2->imageData length:image2->imageSize];
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    
    CGImageRef imageRef;
    
    imageRef = CGImageCreate(image2->width, image2->height, image2->depth, image2->depth * image2->nChannels, image2->widthStep, colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    
    
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    
    
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    cvReleaseImage(&image2);
    
    return ret;
}

UIImage *OpenCVTool::createRGBAUIImageFromIplImage(IplImage *image)
{
    //CCLogMessage(CCLogLevelDebug, @"IplImage (%d, %d) %d bits by %d channels, %d bytes/row %s", image->width, image->height, image->depth, image->nChannels, image->widthStep, image->channelSeq);
    
    IplImage *image2 = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 4);
    
    cvCvtColor(image, image2, CV_BGRA2RGBA);//颜色空间转换 重要!!
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSData *data = [NSData dataWithBytes:image2->imageData length:image2->imageSize];
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    
    CGImageRef imageRef;
    
    imageRef = CGImageCreate(image2->width, image2->height, image2->depth, image2->depth * image2->nChannels, image2->widthStep, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    
    
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    
    
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    cvReleaseImage(&image2);
    
    return ret;
}

//裁剪
int OpenCVTool::clip(IplImage *srcIplImage, IplImage *destIplImage, int x, int y, int width, int height)
{
    
    if (srcIplImage == NULL || destIplImage == NULL)
    {
        return  1;
    }
    
    if (srcIplImage->width <  width || srcIplImage->height < height)
    {
        return  2;
    }
    
    if (destIplImage->width <  width || destIplImage->height < height)
    {
        return  3;
    }
    
   /* for (int i=0; i<height; i++)
    {
        //printf("i = %d", i);
        unsigned char *dest = (unsigned char *)(destIplImage->imageData + i * destIplImage->widthStep);
        
        unsigned char *src = (unsigned char *)(srcIplImage->imageData + (i + y) * srcIplImage->widthStep);
        
        for (int j=0; j<width; j++)
        {
            for (int nc = 0; nc<destIplImage->nChannels; nc++)
            {
                //CCLogMessage(CCLogLevelDebug, @"i = %d j = %d\n", i, j);
                dest[3 * j + nc] = src[3 * (x + j) + nc];
            }
        }
    }*/
    
    cvSetImageROI(srcIplImage, cvRect(x, y, width, height));
    
    cvCopy(srcIplImage, destIplImage);
    
    cvResetImageROI(srcIplImage);
    
    
    return 0;
}
