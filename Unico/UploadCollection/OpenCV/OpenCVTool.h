//
//  OpenCVTool.h
//  OpenCVDemo
//
//  Created by 陈诚 on 15/6/23.
//  Copyright (c) 2015年 陈诚. All rights reserved.
//

#ifndef __OpenCVDemo__OpenCVTool__
#define __OpenCVDemo__OpenCVTool__

#include <stdio.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <opencv2/highgui/highgui_c.h>
#import <opencv2/imgproc/imgproc_c.h>

class OpenCVTool
{
public:
    static  UIImage* imageScaleToSize(UIImage*img, CGSize size);
    
    static  UIImage* imageReducedSize(UIImage*img, CGSize size);
    
    static UIImage *rotateImage(UIImage *image);
    
    static IplImage *createBGRIplImageFromUIImage(UIImage *image);
    
    static IplImage *createBGRAIplImageFromUIImage(UIImage *image);
    
    
    static UIImage *createRGBUIImageFromIplImage(IplImage *image);
    
    static UIImage *createRGBAUIImageFromIplImage(IplImage *image);
    
    
    static IplImage  *cvQueryFrameRepeatMode(CvCapture **capture, const char *filePath);
    
    
    static void mergeImageLayer(const IplImage *inputImage1, const IplImage *inputImage2, IplImage *outPutImage, unsigned char alphaColor[3]);
    
    static void mergeBGRAImageLayer(const IplImage *inputImage1, const IplImage *inputImage2, IplImage *outPutImage);
    
    static void rotateImage(const IplImage *inputImage, IplImage *outPutImage, double degree, CvScalar fillval CV_DEFAULT(cvScalarAll(255)));
    static IplImage* rotateImageAndResize(IplImage* img,int degree);
    
    static void translationImage(const IplImage *inputImage, IplImage *outPutImage, int tx, int ty, CvScalar fillval CV_DEFAULT(cvScalarAll(255)));
    
    static void scaleImage(const IplImage *inputImage, IplImage *outPutImage, float sx, float sy, CvScalar fillval CV_DEFAULT(cvScalarAll(255)));
    
    static void scaleAspectFitToSize(const IplImage *inputImage, IplImage *outPutImage, CvScalar fillval CV_DEFAULT(cvScalarAll(255)));
    
    static void scaleAspectFillToSize(const IplImage *inputImage, IplImage *outPutImage);
    
    static int rgb2gray(const IplImage *srcIplImage, IplImage *destIplImage);

    
    static int clip(IplImage *srcIplImage, IplImage *destIplImage, int x, int y, int width, int height);
};

#endif /* defined(__OpenCVDemo__OpenCVTool__) */
