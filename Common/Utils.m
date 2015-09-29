//
//  Utils.m
//  FaFa
//
//  Created by mac on 12-9-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#include <arpa/inet.h>  
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "AppSetting.h"
#import "SQLiteOper.h"
#import "WeFaFaGet.h"
#import "sys/sysctl.h"
#import "AppDelegate.h"
#import "Hash.h"
#import "Reachability.h"
#import <Accelerate/Accelerate.h>

@implementation Utils

+(int)indexOfArray:(Byte *)arr Length:(int)length StartPos:(int)startpos SplitChar:(Byte)splitchar
{
    int rst=0;
    for (int i=startpos;i<startpos+length;i++)
    {
        if (arr[i]==splitchar)
        {
            rst=i;
            break;
        }
    }
    return rst;
}

+ (int) GetAvailTCPListenPort
{
    int sockfd;
    int port = 13002;
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0); 
    if (sockfd < 0) 
    { 
        return port;
    } 
    
    struct sockaddr_in localAddr;
    
    localAddr.sin_family      = AF_INET;
    localAddr.sin_addr.s_addr = htonl(INADDR_ANY);
    localAddr.sin_port        = htons(0);
    
    if ( bind(sockfd, (struct sockaddr*)&localAddr, sizeof(localAddr)) < 0 )
    {
        port=ntohs(localAddr.sin_port);
    }
    close(sockfd);
    return port;
}

+(void) createDirectory:(NSString *)dirname
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
//     NSLog(@"dirname---%@",dirname);
    BOOL existed = [fileManager fileExistsAtPath:dirname];
    if ( existed == NO)
    {
        [fileManager createDirectoryAtPath:dirname withIntermediateDirectories:YES attributes:nil error:nil];
//        NSLog(@"dirname---%@",dirname);
    }
}

//+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath
//{
//    if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
//        return NO;
//    
//    @try
//    {
//        NSData *imageData = nil;
//        
//        NSString *ext = [aPath pathExtension];
//        
//        if ([[ext uppercaseString] isEqualToString:@"PNG"])
//        {
//            imageData = UIImagePNGRepresentation(image); 
//        }
//        else 
//        {
//            imageData = UIImageJPEGRepresentation(image, 0.5);
//        }
//         
//        if ((imageData == nil) || ([imageData length] <= 0))
//            return NO;
//        
//        [imageData writeToFile:aPath atomically:YES];       
//        return YES;
//    }
//    @catch (NSException *e) 
//    {
//        NSLog(@"create thumbnail exception.");
//    }
//    return NO;
//}

+ (NSData *)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath
{
    NSData *imageData = nil;
    if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
        return imageData;
    
    @try
    {
        
        NSString *ext = [aPath pathExtension];
        
        if ([[ext uppercaseString] isEqualToString:@"PNG"])
        {
            imageData = UIImagePNGRepresentation(image);
        }
        else
        {
            imageData = UIImageJPEGRepresentation(image, 0.5);
        }
        
        if ((imageData == nil) || ([imageData length] <= 0))
            return NO;
        
        [imageData writeToFile:aPath atomically:YES];
    }
    @catch (NSException *e)
    {
        NSLog(@"create thumbnail exception.");
        imageData=nil;
    }
    return imageData;
}

+ (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 根据UI Image裁剪，不能简单的判断不透明，因为装饰物可能超出区域。
    return image;
}

//等比缩放
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
	UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

//自定长宽
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
//    UIImage *reSizeImage = [UIImage imageWithCGImage:image.CGImage scale:0.5 orientation:image.imageOrientation];
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return reSizeImage;
}

+(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool
{
    
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    
    
    float imgwidth = image.size.width;
    float imgheight = image.size.height;
    float viewwidth = mCGRect.size.width;
    float viewheight = mCGRect.size.height;
    CGRect rect;
    if(centerBool)
        rect = CGRectMake((imgwidth-viewwidth)/2, (imgheight-viewheight)/2, viewwidth, viewheight);
    else{
        if (viewheight < viewwidth) {
            if (imgwidth <= imgheight) {
                rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
            }else {
                float width = viewwidth*imgheight/viewheight;
                float x = (imgwidth - width)/2 ;
                if (x > 0) {
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
                }
            }
        }else {
            if (imgwidth <= imgheight) {
                float height = viewheight*imgwidth/viewwidth;
                if (height < imgheight) {
                    rect = CGRectMake(0, 0, imgwidth, height);
                }else {
                    rect = CGRectMake(0, 0, viewwidth*imgheight/viewheight, imgheight);
                }
            }else {
                float width = viewwidth*imgheight/viewheight;
                if (width < imgwidth) {
                    float x = (imgwidth - width)/2 ;
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgheight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+(UIImage *)rotateImage:(UIImage *)aImage dir:(int)orient
{
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = 1;
    
    CGFloat boundHeight;
    //UIImageOrientation orient = aImage.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
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
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

+ (NSDate *)stringToDate:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"]; 

    NSDate *destDate= [dateFormatter dateFromString:dateString];
    OBJC_RELEASE(dateFormatter);
    
    return destDate;
}

+ (NSString *)dateToString:(NSDate *)currentdate Format:(NSString *)formatStr
{
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatStr];
    NSMutableString *timeString = [NSMutableString stringWithFormat:@"%@",[formatter stringFromDate:currentdate]];
    OBJC_RELEASE(formatter);
    
#if ! __has_feature(objc_arc)
    return [[[NSString alloc] initWithFormat:@"%@",timeString] autorelease];
#else
    return [[NSString alloc] initWithFormat:@"%@",timeString];
#endif
}

+ (NSString *)getGMTDateString:(NSNumber *)dateNumber Format:(NSString *)formatStr
{
    if (dateNumber==nil || (NSNull *)dateNumber==[NSNull null])
        return @"";
    if ([dateNumber longLongValue]==-30600)
        return @"";
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMT];
    return [Utils dateToString:[NSDate dateWithTimeIntervalSince1970:[dateNumber longLongValue]+interval] Format:formatStr];
}

+(UIColor *)getcolor:(NSString *)sharp_colorstr alpha:(CGFloat)alpha
{
    UIColor *color1=nil;
    if (sharp_colorstr.length>1 && [[sharp_colorstr substringToIndex:1] isEqualToString:@"#"])
    {
        NSArray *arr=[sharp_colorstr componentsSeparatedByString:@"#"];
        NSString *s=[arr lastObject];
        NSNumber *num=[Utils numericFromHexString:s];
        color1=[Utils HexColor:num.intValue Alpha:alpha];
    }
    return color1;
}

+(UIColor *)HexColor:(int)hexValue Alpha:(float)alpha;
{
    return [UIColor colorWithRed:((hexValue>>16)&0xFF)/255.0 green:((hexValue>>8)&0xFF)/255.0 blue:(hexValue&0xFF)/255.0 alpha:alpha]; 
}
+(NSArray* )rgbFromHexColor:(int)hexValue Alpha:(float)alpha
{
    NSString * red = [NSString stringWithFormat:@"%d",((hexValue>>16)&0xFF) ];
    NSString * green = [NSString stringWithFormat:@"%d",((hexValue>>8)&0xFF) ];
    NSString * blue = [NSString stringWithFormat:@"%d",(hexValue&0xFF) ];
    NSArray * arr = @[red,green,blue];
    
    return arr;
    
    

}
//
+ (NSString*) hexStringFromData : (NSData*) data {
    //overflow detection
    const unsigned char *dataBuffer = [data bytes];
    return [[NSString alloc] initWithFormat: @"%02x%02x",
            (unsigned char)dataBuffer[0],
            (unsigned char)dataBuffer[1]];
}

// convert a hex string to a number
+ (NSNumber*) numericFromHexString : (NSString *) hexstring {
    NSScanner * scan = NULL;
    unsigned int numbuf= 0;
    
    scan = [NSScanner scannerWithString:hexstring];
    [scan scanHexInt:&numbuf];
    return [NSNumber numberWithInt:numbuf];
}

+(void)alertMessage:(NSString *)msg
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" 
                                                   message:msg
                                                  delegate:self 
                                         cancelButtonTitle:@"确定" 
                                         otherButtonTitles:nil,nil];
    [alert show];
#if ! __has_feature(objc_arc)
    [alert release];
#endif
}

+(NSString *)replaceHtmlTagNewLine:(NSString *)content
{
    NSRegularExpression *psupperlink = [NSRegularExpression regularExpressionWithPattern:
                                        @"(<BR/>|<BR>)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *message=[NSString stringWithFormat:@"%@",content];
    NSString *replaceStr = [psupperlink stringByReplacingMatchesInString:message
                                                                 options:0
                                                                   range:NSMakeRange(0, [message length])
                                                            withTemplate:@"\n"];
    
    return replaceStr;
}

+(NSString *)filterHTMLString:(NSString *)htmlstring
{
    //替换换行
    NSString *newHtmlStr=[Utils replaceHtmlTagNewLine:htmlstring];
    
    //过滤掉其他格式
//    NSRange range;
//    NSString *string=[NSString stringWithFormat:@"%@",newHtmlStr];
//    while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
//        string=[string stringByReplacingCharactersInRange:range withString:@""];
//    }
//    return string;
    
    NSRegularExpression *psupperlink = [NSRegularExpression regularExpressionWithPattern:
                                        @"<[^>]+>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *message=[NSString stringWithFormat:@"%@",newHtmlStr];
    NSString *replaceStr = [psupperlink stringByReplacingMatchesInString:message
                                                                 options:0
                                                                   range:NSMakeRange(0, [message length])
                                                            withTemplate:@""];
    return replaceStr;
}

+(void)AudioSpeakerOn:(bool)isOn
{
    NSError *err = nil;
    [[AVAudioSession sharedInstance] setCategory :AVAudioSessionCategoryPlayback error:&err];
    
    UInt32 route;
    //    OSStatus error;
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    
    //    error =
    AudioSessionSetProperty (
                             kAudioSessionProperty_AudioCategory,
                             sizeof (sessionCategory),
                             &sessionCategory
                             );
    
    route = isOn ? kAudioSessionOverrideAudioRoute_Speaker : kAudioSessionOverrideAudioRoute_None;
    //    error =
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    
}

+(NSString *)genGUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    
    //get the string representation of the UUID
    
#if ! __has_feature(objc_arc)
    NSString    *uuidString = (NSString *)CFUUIDCreateString(nil, uuidObj);
#else
    NSString    *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
#endif
    
    CFRelease(uuidObj);
    
#if ! __has_feature(objc_arc)
    return [uuidString autorelease];
#else
    return uuidString;
#endif
    
}
+(NSString *)getSNSInteger:(NSString *)str
{
    NSString *rst;
    if ((NSNull *)str!=[NSNull null])
    {
        rst=[NSString stringWithFormat:@"%d", [str intValue]];
    }
    else
    {
        rst=[NSString stringWithFormat:@"0"];
    }
    return rst;
}

+(NSString *)getSNSString:(NSString *)str
{
    if (!str) {
        return @"";
    }
    NSString *rst;
    
    if (str && (NSNull *)str!=[NSNull null])
    {
        if ([str isEqualToString:@"<null>"]||str==nil||[[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@""]||[str isEqualToString:@"(null)"] || [str isEqualToString:@"null"])
            str=@"";
        rst=[NSString stringWithFormat:@"%@", str];
    }
    else
    {
        rst=[NSString stringWithFormat:@""];
    }
    return rst;
}
+(NSString *)getSNSFloat:(NSString *)str
{
    NSString *rst;
    if ((NSNull *)str!=[NSNull null])
    {
        rst=[NSString stringWithFormat:@"%f", [str floatValue]];
    }
    else
    {
        rst=[NSString stringWithFormat:@"0"];
    }
    return rst;
}

+(NSString *)getSNS02Float:(NSString *)str
{
    NSString *rst;
    if ((NSNull *)str!=[NSNull null])
    {
        rst=[NSString stringWithFormat:@"%0.2f", [str floatValue]];
    }
    else
    {
        rst=[NSString stringWithFormat:@"0"];
    }
    return rst;
}

+(NSString *)getSNSDouble:(NSString *)str
{
    NSString *rst;
    if ((NSNull *)str!=[NSNull null])
    {
        rst=[NSString stringWithFormat:@"%f", [str doubleValue]];
    }
    else
    {
        rst=[NSString stringWithFormat:@"0"];
    }
    return rst;
}

+(NSString *)getSNSMoney:(NSString *)str
{
    NSString *rst;
    if ((NSNull *)str!=[NSNull null])
    {
        rst=[NSString stringWithFormat:@"%0.2f", [str floatValue]];
    }
    else
    {
        rst=[NSString stringWithFormat:@"0.00"];
    }
    return rst;
}
-(NSString *)changeFloat:(NSString *)stringFloat
{
    NSUInteger length = [stringFloat length];
    for(int i = 1; i<=2; i++)
    {
        NSString *subString = [stringFloat substringFromIndex:length - i];
        if(![subString isEqualToString:@"0"])
        {
            return stringFloat;
        }
        else
        {
            stringFloat = [stringFloat substringToIndex:length - i];
        }
        
    }
    return [stringFloat substringToIndex:length - 2];
}
+(NSString *)getSNSRMBMoney:(NSString *)str
{
    NSString *rst;
    int money = [str doubleValue] * 100;
 
    if ((NSNull *)str!=[NSNull null]){
        if (money % 100 == 0) {
            rst = [NSString stringWithFormat:@"￥%d", money/ 100];
        }
        else if(money %10==0)
        {
            rst = [NSString stringWithFormat:@"￥%0.1f", [str floatValue]];
        }
        else
        {
            rst = [NSString stringWithFormat:@"￥%0.2f", [str floatValue]];
        }
    }else{
        rst=[NSString stringWithFormat:@"￥0"];
    }
    return rst;
}
+(NSString *)getSNSRMBMoneyWithoutMark:(NSString *)str
{
    NSString *rst;
    int money = [str doubleValue] * 100;
    
    if ((NSNull *)str!=[NSNull null]){
        if (money % 100 == 0) {
            rst = [NSString stringWithFormat:@"%d", money/ 100];
        }
        else if(money %10==0)
        {
            rst = [NSString stringWithFormat:@"%0.1f", [str floatValue]];
        }
        else
        {
            rst = [NSString stringWithFormat:@"%0.2f", [str floatValue]];
        }
    }else{
        rst=[NSString stringWithFormat:@"0"];
    }
    return rst;
}

+(NSDate *)getDateTimeInterval_MS:(NSString *)str
{
    NSDate *rst;
    if ((NSNull *)str!=[NSNull null])
    {
        rst = [NSDate dateWithTimeIntervalSince1970:[str floatValue]/1000.0];
    }
    else
    {
        rst=[NSDate date];
    }
    return rst;
}

+(void)clearUserData
{
    //删除 receive snsattachfile snsheadcache tmp
    NSFileManager *fm = [NSFileManager defaultManager];
    
    [fm removeItemAtPath:[AppSetting getRecvFilePath] error:nil];
    [fm removeItemAtPath:[AppSetting getSNSAttachFilePath] error:nil];
    [fm removeItemAtPath:[AppSetting getSNSHeadImgFilePath] error:nil];
    [fm removeItemAtPath:[AppSetting getTempFilePath] error:nil];
    [fm removeItemAtPath:[AppSetting getPluginFilePath] error:nil];
    [fm removeItemAtPath:[AppSetting getAppCenterFilePath] error:nil];
    [fm removeItemAtPath:[AppSetting getMBCacheFilePath] error:nil];
    [fm removeItemAtPath:[AppSetting getXMLFilePath] error:nil];
    
    [AppSetting createPersonalFileDir];
    
    //clearDB Data
//    [sqlite clearHisData]; 已经单独分离出清除所有聊天记录
}

+(void)clearAllPlugin
{
    //删除 receive snsattachfile snsheadcache tmp
    NSFileManager *fm = [NSFileManager defaultManager];
    
    [fm removeItemAtPath:[AppSetting getPluginFilePath] error:nil];
    
    [Utils createDirectory:[AppSetting getPluginFilePath]];
}

+(void)delUserAccount:(NSString*)loginaccount
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *jidbare = [AppSetting getFafaJid:loginaccount];
    if (jidbare != nil && [jidbare length]>0)
    {
        NSString *path = [[AppSetting getFaFaDocPath] stringByAppendingPathComponent:jidbare];
        [fm removeItemAtPath:path error:nil];
    }
    
    [AppSetting del:loginaccount];
    [AppSetting save];
}

//判断是否为整形
+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}

+ (UIImage*) convertImageToGreyScale:(UIImage*) image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGBitmapByteOrderDefault);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

+(void)imageViewDrawLine:(UIImageView *)imageView fromPoint:(CGPoint)startpoint toPoint:(CGPoint)endpoint lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor
{
    CGFloat r=0.0;
    CGFloat g=0.0;
    CGFloat b=0.0;
    CGFloat a=1.0;
    [lineColor getRed:&r green:&g blue:&b alpha:&a];
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(con, lineWidth);  //线宽
//    CGContextSetAllowsAntialiasing(con,NO);
//    CGContextSetShouldAntialias(con, NO );
    CGContextSetRGBStrokeColor(con, r, g, b, a);  //颜色
    CGContextBeginPath(con);
    CGContextMoveToPoint(con, startpoint.x, startpoint.y);  //起点坐标
    CGContextAddLineToPoint(con, endpoint.x, endpoint.y);   //终点坐标
    CGContextClosePath(con);
    CGContextStrokePath(con);
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

+(NSString *)filterJSONString:(NSString *)jsonstr
{
//    \a - Sound alert
//    \b - 退格
//    \f - Form feed
//    \n - 换行
//    \r - 回车
//    \t - 水平制表符
//    \v - 垂直制表符
//    \\ - 反斜杠
//    \" - 双引号
//    \' - 单引号
    NSMutableString *responseString = [NSMutableString stringWithString:jsonstr];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    return responseString;
}

+ (void)logDictionary:(NSDictionary *)dic
{
    NSString *tempStr1 = [[dic description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    NSLog(@"dic:%@",str);
}

+(void)appendLog2File:(NSString*)logmsg
{
//#ifdef DEBUG
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%@", logmsg);
        
        NSString *logfilepath = [[AppSetting getFaFaDocPath] stringByAppendingPathComponent:@"debug.log"];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:logfilepath])
        {
            [fm createFileAtPath:logfilepath contents:nil attributes:nil];
        }
        
        NSFileHandle *handler = [NSFileHandle fileHandleForUpdatingAtPath: logfilepath];
        [handler seekToEndOfFile];
        [handler writeData: [[NSString stringWithFormat:@"%@ %@", [NSDate date], logmsg] dataUsingEncoding: NSUTF8StringEncoding]];
        [handler writeData: [@"\r\n" dataUsingEncoding: NSUTF8StringEncoding]];
        [handler closeFile];
    });
//#endif
}
+(void)sendLogFile
{
#ifdef DEBUG
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *logfilepath = [[AppSetting getFaFaDocPath] stringByAppendingPathComponent:@"debug.log"];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:logfilepath])
        {
            return;
        }
        
        NSFileHandle *handler = [NSFileHandle fileHandleForUpdatingAtPath: logfilepath];
        NSData *data = [handler readDataToEndOfFile];
        [handler closeFile];
        [fm removeItemAtPath:logfilepath error:nil];
        if ([data length]>0)
            [sns errReport:[NSString
                        stringWithFormat:@"DEBUGLOG\r\n[device]\r\n%@ %@\r\n%@",
                        [[UIDevice currentDevice] systemName],
                        [[UIDevice currentDevice] systemVersion],
                        [NSString stringWithUTF8String:[data bytes]]]];
    });
#endif
}

+(NSString *)getDateTime
{
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowTime = [NSDate date];
    NSMutableString *timeString = [NSMutableString stringWithFormat:@"%@",[formatter stringFromDate:nowTime]];
    return [[NSString alloc] initWithFormat:@"%@",timeString];
}
+(NSString *)getdate:(NSString *)datestr
{
    NSString *dateString=nil;
    NSDate *date ;
    
    if (datestr.length>1 && [[datestr substringToIndex:1] isEqualToString:@"/"])
    {
        NSArray *arr=[datestr componentsSeparatedByString:@"/Date("];
        NSString *s=[arr lastObject];
        arr=[s componentsSeparatedByString:@")/"];
        
        s=[arr firstObject];
        arr=[s componentsSeparatedByString:@"-"];
        s=[arr firstObject];
        date =[NSDate dateWithTimeIntervalSince1970:[s longLongValue]/1000];
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateString=[NSString stringWithFormat:@"%@",[format stringFromDate:date]];
        
    }
    return dateString;
}

+(NSString *)getYearDaydate:(NSString *)datestr
{
    NSString *dateString=nil;
    NSDate *date ;
    
    if (datestr.length>1 && [[datestr substringToIndex:1] isEqualToString:@"/"])
    {
        NSArray *arr=[datestr componentsSeparatedByString:@"/Date("];
        NSString *s=[arr lastObject];
        arr=[s componentsSeparatedByString:@")/"];
        
        s=[arr firstObject];
        arr=[s componentsSeparatedByString:@"-"];
        s=[arr firstObject];
        date =[NSDate dateWithTimeIntervalSince1970:[s longLongValue]/1000];
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd"];
        dateString=[NSString stringWithFormat:@"%@",[format stringFromDate:date]];
        
    }
    return dateString;
}

+(void)copyResourceFile:(NSString *)sourceFileName toFile:(NSString *)toFile
{
    NSMutableArray* directoryParts = [NSMutableArray arrayWithArray:[sourceFileName componentsSeparatedByString:@"/"]];
    NSString* filename = [directoryParts lastObject];
    
    //资源文件路径pathForResource接口：工程-》Build Phases -》 Copy Buindle Resource要添加才能使用
    //NSArray *f_arr=[NSArray arrayWithArray:[filename componentsSeparatedByString:@"."]];
    //NSString* sourcefile = [[NSBundle mainBundle] pathForResource:f_arr[0] ofType:f_arr[1]];
    NSString *sourcefile=[[NSString alloc] initWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],filename ];
    
    [[NSFileManager defaultManager] copyItemAtPath:sourcefile toPath:toFile error:nil];

    if (![[NSFileManager defaultManager] fileExistsAtPath:toFile])
    {
        toFile=toFile;
        return;
    }
}

+ (IOS_DEVICE_TYPE)getDeviceVersion:(NSMutableString *)versionString{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    free(name);
    
    IOS_DEVICE_TYPE devicetype=0;
    if ([machine rangeOfString:@"iPhone"].location != NSNotFound)
    {
        devicetype=IOS_DEVICE_TYPE_IPHONE;
        
        if (versionString!=nil)
        {
            if( [machine isEqualToString:@"iPhone1,1"] ) [versionString setString: @"iPhone_1G"];
            else if( [machine isEqualToString:@"iPhone1,2"] ) [versionString setString:@"iPhone_3G"];
            else if( [machine isEqualToString:@"iPhone2,1"] ) [versionString setString:@"iPhone_3GS"];
            else if( [machine isEqualToString:@"iPhone3,1"] ) [versionString setString:@"iPhone_4"];
        }
    }
    else if ([machine rangeOfString:@"iPod"].location != NSNotFound)
    {
        devicetype=IOS_DEVICE_TYPE_IPOD;
        
        if (versionString!=nil)
        {
            if( [machine isEqualToString:@"iPod1,1"] ) [versionString setString:@"iPod_Touch_1G"];
            else if( [machine isEqualToString:@"iPod2,1"] ) [versionString setString:@"iPod_Touch_2G"];
            else if( [machine isEqualToString:@"iPod3,1"] ) [versionString setString:@"iPod_Touch_3G"];
            else if( [machine isEqualToString:@"iPod4,1"] ) [versionString setString:@"iPod_Touch_4G"];
        }
    }
    else if ([machine rangeOfString:@"iPad"].location != NSNotFound)
    {
        devicetype=IOS_DEVICE_TYPE_IPAD;
        
        if (versionString!=nil)
        {
            if( [machine isEqualToString:@"iPad1,1"] ) [versionString setString:@"iPad_1"];
            else if( [machine isEqualToString:@"iPad2,1"] ) [versionString setString:@"iPad_2"];
        }
    }
    else if( [machine isEqualToString:@"i386"] || [machine isEqualToString:@"x86_64"] )
    {
        devicetype=IOS_DEVICE_TYPE_SIMULATOR;
        
        if (versionString!=nil)
        {
            [versionString setString:@"ios_Simulator"];
        }
    }
    else
    {
        devicetype=IOS_DEVICE_TYPE_UNKNOWN;
        
        if (versionString!=nil)
        {
            [versionString setString:machine = @"unknown device"];
        }
    }
    
    return devicetype;
}

+ (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
                                  onComplete:(void (^)(void))onComplete
                                      onExit:(void (^)(void))onExit
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    NSString * _mp4Quality=AVAssetExportPresetMediumQuality;
    if ([compatiblePresets containsObject:_mp4Quality])
    {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:_mp4Quality];
        
        exportSession.outputURL = outputURL;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    break;
                }
                    
                case AVAssetExportSessionStatusCancelled:
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (onComplete) onComplete();
                    });
                    break;
                }
                default:
                    break;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (onExit) onExit();
            });
        }];
    }
}

+(NSString *)fileNameHash:(NSString *)filename
{
    if ([filename hasPrefix:@"http:"] || [filename hasPrefix:@"https:"])
    {
        NSString *ext=[filename pathExtension];
        NSString *estr=@"";
        if (ext.length>0)
            estr=[[NSString alloc] initWithFormat:@".%@",ext];
        return [[NSString alloc] initWithFormat:@"%@%@",[Hash dataMD5:[filename dataUsingEncoding:NSUTF8StringEncoding]],estr];
    }
    return filename;
}

+(NSString *)convertImageUrl:(NSString *)urlStr WithFixedWidth:(CGFloat)width height:(CGFloat)height
{
    if ([urlStr isEqualToString:@""] || ![urlStr pathExtension]) {
        return urlStr;
    }
    NSString *extension = [urlStr pathExtension];

    NSString *baseStr = [urlStr substringToIndex:(urlStr.length - extension.length - 1)];
//    NSString *baseStr = [[urlStr componentsSeparatedByString:@"."] firstObject];
    baseStr = [baseStr stringByAppendingFormat:@"--%dx%d.%@",(int)width,(int)height,extension];
    return baseStr;
}

+(UIImage *) getImageAsyn:(NSString *)fileID path:(NSString*)path downloadLock:(NSCondition*)downloadLock ImageCallback:(void (^)(UIImage * image,NSObject *recv_img_id))imageBlock ErrorCallback:(void (^)(void))errorBlock
{
    if (fileID.length==0)
    {
        return nil;
    }
    
    NSArray *s_url =[fileID componentsSeparatedByString:@"/"];
    BOOL isURL=NO;
    NSString *filename=fileID; //SNS数据文件
    if (s_url.count>1) //是否URL
    {
        NSString *https=[s_url[0] lowercaseString];
        if ([https isEqualToString:@"http:"] || [https isEqualToString:@"https:"])
        {
            isURL=YES;
            filename=[Utils fileNameHash:fileID];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%@", path, filename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]==YES)
    {
//        return [[UIImage alloc] initWithContentsOfFile:filepath];
        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void) {
            [downloadLock lock];
            //缓存图片数据
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:filepath];
            dispatch_async( dispatch_get_main_queue(), ^(void){
                if( image != nil )
                {
                    imageBlock( image,filename );
                } else {
                    errorBlock();
                }
            });
            [downloadLock unlock];
        });
    }
    else
    {
        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                       {
                           [downloadLock lock];
                           //缓存图片数据
                           UIImage *image=nil;
                           if (isURL)
                           {
                               //下载缓存图片
                               NSURL *url = [NSURL URLWithString:fileID];
                               ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
                               [request startSynchronous];
                               NSError *error = [request error];
                               if (!error) {
                                   NSData * filedata=[request responseData];
                                   if (filedata!=nil)
                                   {
                                       image = [[UIImage alloc] initWithData:filedata];
                                       [filedata writeToFile:filepath atomically:YES];
                                   }
                               }
                               
                               //                               NSData * filedata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:fileID]] ;
                               //                               image = [[UIImage alloc] initWithData:filedata];
                               //                               if (filedata!=nil)
                               //                                   [filedata writeToFile: filepath atomically: NO];
                           }
                           else
                           {
                               NSData *filedata = [sns getImage:SNS_IMAGE_ORIGINAL ImageName:filename];
                               if (filedata!=nil)
                               {
                                   [filedata writeToFile: filepath atomically: NO];
                               }
                               
                               image = [[UIImage alloc] initWithData:filedata];
                           }
                           
                           dispatch_async( dispatch_get_main_queue(), ^(void){
                               if( image != nil )
                               {
                                   imageBlock( image,filename );
                               } else {
                                   errorBlock();
                               }
                           });
                           [downloadLock unlock];
                       });
    }
    return nil;
}

+(UIImage *) getSnsImageAsyn:(NSString *)fileID downloadLock:(NSCondition*)downloadLock ImageCallback:(void (^)(UIImage * image,NSObject *recv_img_id))imageBlock ErrorCallback:(void (^)(void))errorBlock
{
    if ([fileID isEqualToString:@""]==YES)
    {
        return nil;
    }
//    fileID =  [Utils fileNameHash:fileID];
    
    NSString *filepath = [NSString stringWithFormat:@"%@/%@", [AppSetting getSNSHeadImgFilePath], fileID];

    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]==YES)
    {
        return [[UIImage alloc] initWithContentsOfFile:filepath];
        
//        __block UIImage *imgNew=[[UIImage alloc] init];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSData *imgdata=[[NSData alloc] initWithContentsOfFile:filepath];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                imgNew=[UIImage imageWithData:imgdata];
//                
//            });
//        });
//        return imgNew;
    }
    else
    {
        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                       {
                           [downloadLock lock];
                           UIImage *image=nil;
                           //缓存图片数据
                           NSData *filedata = [sns getImage:SNS_IMAGE_ORIGINAL ImageName:fileID];
                           if (filedata!=nil)
                           {
                               [filedata writeToFile: filepath atomically: NO];
                           }
                           
                           image = [[UIImage alloc] initWithData:filedata];
                           dispatch_async( dispatch_get_main_queue(), ^(void){
                               if( image != nil )
                               {
                                   imageBlock( image,fileID );
                               } else {
                                   errorBlock();
                               }
                           });
                           [downloadLock unlock];
                       });
    }
    return nil;
}

+(NSString *)FormatDateTime:(NSDate *)datetime FormatType:(FORMAT_DATE_TYPE)format
{
    if (!datetime) {
        datetime = [NSDate date];
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    int current_year=(int)[comps year];
    int current_month = (int)[comps month];
    int current_day = (int)[comps day];
    //    int current_hour = [comps hour];
    //    int current_min = [comps minute];
    //    int current_week = [comps weekday];
    //    int current_sec = [comps second];
    
    
    NSString *year=[datetime toString:@"yyyy"];
    NSString *month=[datetime toString:@"MM"];
    NSString *day=[datetime toString:@"dd"];
    NSString *hour=[datetime toString:@"HH"];
    NSString *min=[datetime toString:@"mm"];
    
    BOOL isToday=NO;
    if ([year intValue]==current_year && [month intValue]==current_month && [day intValue]==current_day )
    {
        isToday=YES;
    }
    
    NSString *FormatString=nil;
    switch ((int)format) {
        case FORMAT_DATE_TYPE_YMDHN_CHN:
            if (isToday)
                FormatString=[[NSString alloc] initWithFormat:@"今天 %@:%@",hour,min];
            else
                FormatString=[[NSString alloc] initWithFormat:@"%@年%d月%d日 %@:%@",year,[month intValue],[day intValue],hour,min ];
            break;
        case FORMAT_DATE_TYPE_MDHN_CHN:
            if (isToday)
                FormatString=[[NSString alloc] initWithFormat:@"今天 %@:%@",hour,min];
            else
                FormatString=[[NSString alloc] initWithFormat:@"%d月%d日 %@:%@",[month intValue],[day intValue],hour,min ];
            break;
        case FORMAT_DATE_TYPE_DURATION:
            if (isToday)
                FormatString=[Utils compareCurrentTime:datetime];
            else
                FormatString=[[NSString alloc] initWithFormat:@"%0.4d-%0.2d-%0.2d %@:%@",[year intValue],[month intValue],[day intValue],hour,min ];
            break;
        case FORMAT_DATE_TYPE_DURATION_CHN:
            if (isToday)
                FormatString=[Utils compareCurrentTime:datetime];
            else
                FormatString=[[NSString alloc] initWithFormat:@"%d月%d日 %@:%@",[month intValue],[day intValue],hour,min ];
            break;
        case FORMAT_DATE_TYPE_DURATION_ALL:
            FormatString=[Utils compareCurrentTime:datetime];
            break;
    }
    return FormatString;
}

+(NSString *)FormatShortDateTime:(NSDate *)datetime lastDate:(NSDate*)lastDate
{
    NSString *FormatString=nil;
    if ([[datetime toString:@"yyyyMMdd"] intValue]<[[lastDate toString:@"yyyyMMdd"] intValue])
    {
        FormatString = [datetime toString:@"yyyy-MM-dd"];
    }
    else
    {
        FormatString=[Utils compareCurrentTime:datetime];
    }
    return FormatString;
}

+(NSString *) compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld个月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

+(NSDate *)dateadd:(NSDate*)date addType:(DATE_DIFF_TYPE)addtype diff:(int)diff
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //日期加
    
    NSTimeInterval add_interv = 0;
    switch (addtype) {
        case DATE_DIFF_TYPE_MINITE:
            add_interv = diff*60;
            break;
        case DATE_DIFF_TYPE_HOUR:
            add_interv = diff*60*60;
            break;
        case DATE_DIFF_TYPE_DAY:
            add_interv = diff*24*60*60;
            break;
        default:
            break;
    }
    
    NSDate *newdate = [NSDate dateWithTimeInterval:add_interv sinceDate:date];
//    //日期减
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    unsigned int unitFlags = NSHourCalendarUnit;//年、月、日、时、分、秒、周等等都可以
//    NSDateComponents *comps = [gregorian components:unitFlags fromDate:Date1 toDate:Date2 options:0];
//    int hours = [comps hour];//时间差
    return newdate;
}

+(void)resizeLabel:(UILabel *)label defaultHeight:(float)defaultHeight defaultWidth:(float)defaultWidth
{
    CGSize size=[label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT)];
    label.frame=CGRectMake(label.frame.origin.x,label.frame.origin.y,defaultWidth,size.height>defaultHeight?size.height:defaultHeight);
}

+(CGSize)getFontSize:(UIFont*)font
{
    CGSize size=[@"十" sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    return size;
}

+(CGRect)getRect:(NSString *)str
{
    NSArray *arr=[str componentsSeparatedByString:@","];
    int x1=[[arr[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue];
    int y1=[[arr[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue];
    int x2=[[arr[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue];
    int y2=[[arr[3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue];
    return CGRectMake(x1,y1,x2,y2);
}

+(NSDictionary *)projectPlistToDictionary
{
    NSMutableDictionary *data=nil;
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@",WEFAFA_PLIST_URL];
    for (int i=0;i<3;i++)
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
        //    {items =     (
        //                 {
        //                     assets =             (
        //                                           {
        //                                               kind = "software-package";
        //                                               url = "https://www.51mb.com/apps/designer/designer.ipa";
        //                                           }
        //                                           );
        //                     metadata =             {
        //                         "bundle-identifier" = "com.metersbonwe.designer";
        //                         "bundle-version" = "0.0.2";
        //                         kind = software;
        //                         title = "\U9020\U578b\U5e08";
        //                     };
        //                 }
        //                 );
        //}
        if (data!=nil&& data.count>0)
            break;
    }
    return data;
}

+(BOOL)isLastVersion:(NSDictionary *)projectPlist versionString:(NSMutableString *)versionString
{
    BOOL rst=YES;
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* currVersion=[infoDict objectForKey:@"CFBundleShortVersionString"];
    [versionString setString:currVersion];
    
    if (projectPlist!=nil&& projectPlist.count>0)
    {
        NSDictionary *meta=projectPlist[@"items"][0][@"metadata"];
        NSString *lastVersion = meta[@"bundle-version"];
        if ([currVersion isEqualToString:lastVersion]==NO)
        {
            [versionString setString:lastVersion];
            rst=NO;
        }
    }
    return rst;
}
+(BOOL)dugeExistMyAttendFriendWithUserId:(NSString *)userid
{
    BOOL  isMyAttend = NO;
    NSString *centerFilePath= [AppSetting getPersonalFilePath];
    NSString *filePath=[centerFilePath stringByAppendingPathComponent:@"attendFriend"];
    
    NSArray *listAttend=[NSArray arrayWithContentsOfFile:filePath];
    NSString *useId=[NSString stringWithFormat:@"%@",userid];
    if ([listAttend containsObject:useId])
    {
        isMyAttend = YES;
    }
    
    return isMyAttend;
}
+(Boolean) isEmptyOrNull:(NSString *) str {
    
    if (!str) {
        
        // null object
        
        return true;
        
    } else {
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([trimedString length] == 0) {
            
            // empty string
            
            return true;
            
        } else {
            
            // is neither empty nor null 
            
            return false;
            
        }
        
    }
    
}

+(NSString *)dictionaryConvertedToStringWithdic:(NSDictionary *)dic
{
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return str2;
}
+(BOOL)reachRequestStatus
{
    Reachability *hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status = [hostReach currentReachabilityStatus];
    if (status == NotReachable)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
}
//加模糊效果，image是图片，blur是模糊度
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    //模糊度,
    if ((blur < 0.1f) || (blur > 2.0f)) {
        blur = 0.5f;
    }
    
    //boxSize必须大于0
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    NSLog(@"boxSize:%i",boxSize);
    //图像处理
    CGImageRef img = image.CGImage;
    //需要引入#import <Accelerate/Accelerate.h>
    /*
     This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
     本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
     */
    
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    //像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //    NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

//图片旋转
+(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation

{
    long double rotate = 0.0;
    
    CGRect rect;
    
    float translateX = 0;
    
    float translateY = 0;
    
    float scaleX = 1.0;
    
    float scaleY = 1.0;
    
    switch (orientation) {
            
        case UIImageOrientationLeft:
            
            rotate = M_PI_2;
            
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            
            translateX = 0;
            
            translateY = -rect.size.width;
            
            scaleY = rect.size.width/rect.size.height;
            
            scaleX = rect.size.height/rect.size.width;
            
            break;
            
        case UIImageOrientationRight:
            
            rotate = 3 * M_PI_2;
            
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            
            translateX = -rect.size.height;
            
            translateY = 0;
            
            scaleY = rect.size.width/rect.size.height;
            
            scaleX = rect.size.height/rect.size.width;
            
            break;
            
        case UIImageOrientationDown:
            
            rotate = M_PI;
            
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            translateX = -rect.size.width;
            
            translateY = -rect.size.height;
            
            break;
            
        default:
            
            rotate = 0.0;
            
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            translateX = 0;
            
            translateY = 0;
            
            break;
            
    }
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //做CTM变换
    
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextRotateCTM(context, rotate);
    
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    return newPic;
    
}
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end


