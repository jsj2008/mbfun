//
//  Globle.m
//  SlideSwitchDemo
//
//  Created by liulian on 13-4-23.
//  Copyright (c) 2013年 liulian. All rights reserved.
//

#import "Globle.h"
#define ViewOffset 140

#define viewwh 140
@implementation Globle

@synthesize globleWidth, globleHeight, globleAllHeight;

+ (Globle *)shareInstance {
    static Globle *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion=[[self alloc] init];
    });
    return __singletion;
}

-(SNSStaffFull *)getUserInfo{
  
//    if (_myUser == nil) {
//         _myUser = [XMPPUserSqliteStorageObject userForJIDFromCache:AppDelegate.xmppConnectDelegate.xmppStream.myJID.bare];
//    }
//   
//    return _myUser.staffFull;
    return sns.myStaffCard;
    
}





+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

#pragma 删除NSUserDefaults上带http的数据
-(void)deleteCreatematchWithNSUserDefaultsKeys{
    NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefatluts dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        NSLog(@"keykeykey----%@",key);
       
        if ([[key substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"http"]) {
             NSLog(@"%@",[key substringWithRange:NSMakeRange(0, 4)]);
            [userDefatluts removeObjectForKey:key];
            [userDefatluts synchronize];
        }
        
    }

}
-(NSString *)getDeviceModelNameAndSystemVersion{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSArray *modelArray = @[
                            
                            @"i386", @"x86_64",
                            
                            @"iPhone1,1",
                            @"iPhone1,2",
                            @"iPhone2,1",
                            @"iPhone3,1",
                            @"iPhone3,2",
                            @"iPhone3,3",
                            @"iPhone4,1",
                            @"iPhone5,1",
                            @"iPhone5,2",
                            @"iPhone5,3",
                            @"iPhone5,4",
                            @"iPhone6,1",
                            @"iPhone6,2",
                            @"iPhone7,2",
                            @"iPhone7,1",
                            
                            @"iPod1,1",
                            @"iPod2,1",
                            @"iPod3,1",
                            @"iPod4,1",
                            @"iPod5,1",
                            
                            @"iPad1,1",
                            @"iPad2,1",
                            @"iPad2,2",
                            @"iPad2,3",
                            @"iPad2,4",
                            @"iPad3,1",
                            @"iPad3,2",
                            @"iPad3,3",
                            @"iPad3,4",
                            @"iPad3,5",
                            @"iPad3,6",
                            
                            @"iPad2,5",
                            @"iPad2,6",
                            @"iPad2,7",
                            ];
    NSArray *modelNameArray = @[
                                
                                @"iPhone Simulator", @"iPhone Simulator",
                                
                                @"iPhone 2G",
                                @"iPhone 3G",
                                @"iPhone 3GS",
                                @"iPhone 4(GSM)",
                                @"iPhone 4(GSM Rev A)",
                                @"iPhone 4(CDMA)",
                                @"iPhone 4S",
                                @"iPhone 5(GSM)",
                                @"iPhone 5(GSM+CDMA)",
                                @"iPhone 5c(GSM)",
                                @"iPhone 5c(Global)",
                                @"iphone 5s(GSM)",
                                @"iphone 5s(Global)",
                                @"iPhone 6",
                                @"iPhone 6 Plus",
                                
                                @"iPod Touch 1G",
                                @"iPod Touch 2G",
                                @"iPod Touch 3G",
                                @"iPod Touch 4G",
                                @"iPod Touch 5G",
                                
                                @"iPad",
                                @"iPad 2(WiFi)",
                                @"iPad 2(GSM)",
                                @"iPad 2(CDMA)",
                                @"iPad 2(WiFi + New Chip)",
                                @"iPad 3(WiFi)",
                                @"iPad 3(GSM+CDMA)",
                                @"iPad 3(GSM)",
                                @"iPad 4(WiFi)",
                                @"iPad 4(GSM)",
                                @"iPad 4(GSM+CDMA)",
                                
                                @"iPad mini (WiFi)",
                                @"iPad mini (GSM)",
                                @"ipad mini (GSM+CDMA)"
                                ];
    NSInteger modelIndex = - 1;
    NSString *modelNameString = nil;
    modelIndex = [modelArray indexOfObject:deviceString];
    if (modelIndex >= 0 && modelIndex < [modelNameArray count]) {
        modelNameString = [modelNameArray objectAtIndex:modelIndex];
    }
    
    
    NSLog(@"----设备类型---%@",modelNameString);
    /*
    NSLog(@"name: %@", [[UIDevice currentDevice] name]);
    NSLog(@"systemName: %@", [[UIDevice currentDevice] systemName]);
    NSLog(@"systemVersion: %@", [[UIDevice currentDevice] systemVersion]);
    NSLog(@"model: %@", [[UIDevice currentDevice] model]);
    NSLog(@"localizedModel: %@", [[UIDevice currentDevice] localizedModel]);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
     */
    return [NSString stringWithFormat:@"%@-%@",modelNameString,[[UIDevice currentDevice] systemVersion]];

}
//iOS中获取UUID的代码如下:
-(NSString*) getuuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result ;
}

- (NSString *)getTimeNow
{
    NSString* date;
    NSString *timeNow;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    //[formatter setDateFormat:@"YYYY.MM.dd.hh.mm.ss"];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    NSLog(@"%@", timeNow);
    return timeNow;
}

- (NSString *)getRandomWord
{
    const int N = 12;
    
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init] ;
    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}

+ (UIImage *)resizeImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageW = image.size.width * 0.5;
    CGFloat imageH = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, imageH, imageW) resizingMode:UIImageResizingModeTile];
}
#pragma mark--YYAnimationIndicator
-(YYAnimationIndicator *)addYYAnimationIndicator{
    YYAnimationIndicator *__YYAnimationIndicator;
    if ([[AppDelegate shareAppdelegate].window viewWithTag:10000]== nil) {
        __YYAnimationIndicator= [[YYAnimationIndicator alloc]initWithFrame:CGRectMake([AppDelegate shareAppdelegate].window.frame.size.width/2-40,     [AppDelegate shareAppdelegate].window.frame.size.height/2-40, 80, 80)];
        __YYAnimationIndicator.tag = 10000;
        __YYAnimationIndicator.hidden = YES;
        [__YYAnimationIndicator setLoadText:@"正在加载..."];
        [[AppDelegate shareAppdelegate].window addSubview:__YYAnimationIndicator];
    }
    
    [[AppDelegate shareAppdelegate].window bringSubviewToFront:[[AppDelegate shareAppdelegate].window viewWithTag:10000]];
    
    return (YYAnimationIndicator *)[[AppDelegate shareAppdelegate].window viewWithTag:10000];
}

#pragma mark -直接画成image图片
-(UIImage *)imageDrawGroupimageWithimageArray:(NSArray *)imageArray{
    
    //    NSArray *imgArray = [[NSArray alloc] initWithObjects:
    //                         [self circleImage:[UIImage imageNamed:@"0"] withParam:0],
    //                         [self circleImage:[UIImage imageNamed:@"1"] withParam:0],
    //                         [self circleImage:[UIImage imageNamed:@"2"] withParam:0],
    //                         [self circleImage:[UIImage imageNamed:@"3"] withParam:0],
    //                         nil];
    NSMutableArray *imgArray = [NSMutableArray new];
    for (int i = 0; i<imageArray.count; i++) {
        if (i >= 4) {
            break;
        }
        [imgArray addObject:[self circleImage:imageArray[i] withParam:0]];
    }
    
    if (imgArray.count == 0 || imgArray == nil) {
        NSLog(@"图片数组为空");
        return nil;
    }
    NSArray *imgPointArray;
    switch (imgArray.count) {
        case 1:
            imgPointArray =@[
                             [NSString stringWithFormat:@"%d",viewwh/2],[NSString stringWithFormat:@"%d",viewwh/2]];
            break;
        case 2:
            imgPointArray =@[
                             [NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",viewwh/2],
                             [NSString stringWithFormat:@"%d",viewwh],[NSString stringWithFormat:@"%d",viewwh/2]];
            break;
        case 3:
            imgPointArray =@[
                             [NSString stringWithFormat:@"%d",viewwh/2],[NSString stringWithFormat:@"%d",viewwh/6],
                             [NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",viewwh],
                             [NSString stringWithFormat:@"%d",viewwh],[NSString stringWithFormat:@"%d",viewwh]];
            break;
        case 4:
            imgPointArray =@[[NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",0],
                             [NSString stringWithFormat:@"%d",viewwh],[NSString stringWithFormat:@"%d",viewwh],
                             [NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",viewwh],
                             [NSString stringWithFormat:@"%d",viewwh],[NSString stringWithFormat:@"%d",0]];
            
            
            break;
        default:
            imgPointArray =@[[NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",0],
                             [NSString stringWithFormat:@"%d",viewwh],[NSString stringWithFormat:@"%d",viewwh],
                             [NSString stringWithFormat:@"%d",0],[NSString stringWithFormat:@"%d",viewwh],
                             [NSString stringWithFormat:@"%d",viewwh],[NSString stringWithFormat:@"%d",0]];
            break;
    }
    
    
    return [self mergedImageOnMainImage:[UIImage imageNamed:@"0.png"] WithImageArray:imgArray AndImagePointArray:imgPointArray];
    
    
}

- (UIImage *) mergedImageOnMainImage:(UIImage *)mainImg WithImageArray:(NSArray *)imgArray AndImagePointArray:(NSArray *)imgPointArray
{
    
    
    UIGraphicsBeginImageContext(CGSizeMake(viewwh+ViewOffset, viewwh+ViewOffset));
    
    //    [mainImg drawInRect:CGRectMake(0, 0, viewwh+ViewOffset, viewwh+ViewOffset)];
    int i = 0;
    for (UIImage *img in imgArray) {
        NSLog(@"imgimgimg-------%d",i);
        [img drawInRect:CGRectMake([[imgPointArray objectAtIndex:i] floatValue],
                                   [[imgPointArray objectAtIndex:i+1] floatValue],
                                   viewwh,
                                   viewwh)];
        //        [img drawAtPoint:CGPointMake([[imgPointArray objectAtIndex:i] floatValue],
        //                                     [[imgPointArray objectAtIndex:i+1] floatValue])];
        i+=2;
        
        if (i>=8) {
            break;
        }
    }
    
    CGImageRef NewMergeImg = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage,
                                                          CGRectMake(0, 0, viewwh+ViewOffset, viewwh+ViewOffset));
    
    UIGraphicsEndImageContext();
    
    
    if (NewMergeImg == nil) {
        return NO;
    }
    else {
        
        //        UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:NewMergeImg], self, nil, nil);
        return [UIImage imageWithCGImage:NewMergeImg];
    }
}


-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


-(BOOL)handleResponseQQZoneWithurl:(NSURL *)qqurl{
    return [QQApiInterface handleOpenURL:qqurl delegate:self];

}
-(void)onReq:(QQBaseReq *)req{


}
- (void)onResp:(QQBaseResp *)resp{
    NSLog(@"resp.errorDescription----%@",resp.errorDescription);
     NSLog(@"result----%@",resp.result);
    
    if (resp.result.intValue == 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareCountAdd" object:@0];
        
    }

}

@end
