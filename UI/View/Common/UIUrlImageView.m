//
//  UIUrlImageView.m
//  Wefafa
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "UIUrlImageView.h"
#import "Hash.h"
#import "ASIHTTPRequest.h"

@implementation UIUrlImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
+(NSString *)fileNameHash:(NSString *)filename
{
    NSString *ext=[filename pathExtension];
    NSString *estr=@"";
    if (ext.length>0)
        estr=[[NSString alloc] initWithFormat:@".%@",ext];
    return [[NSString alloc] initWithFormat:@"%@%@",[Hash dataMD5:[filename dataUsingEncoding:NSUTF8StringEncoding]],estr];
}

-(void)downloadImageUrl:(NSString *)imageUrl cachePath:(NSString *)cachePath defaultImageName:(NSString *)defaultImageName
{
    localImageFilePath = [NSString stringWithFormat:@"%@/%@", cachePath, [UIUrlImageView fileNameHash:imageUrl]];
    
//    [[NSFileManager defaultManager] removeItemAtPath:localImageFilePath error:nil];
    if (imageUrl.length>0) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:localImageFilePath])
        {
            NSURL *url=[NSURL URLWithString:imageUrl];
            //实例化ASIHTTPRequest
            ASIHTTPRequest *_httpRequest=[ASIHTTPRequest requestWithURL:url];
            
            //本次请求参数
            _httpRequest.userInfo=[[NSMutableDictionary alloc] init];
            [_httpRequest.userInfo setValue:self forKey:@"imageView"];
            [_httpRequest.userInfo setValue:localImageFilePath forKey:@"localFilePath"];
            
            [_httpRequest setDelegate:self];
            //开始异步下载
            [_httpRequest startAsynchronous];
            
            if (defaultImageName.length>0)
                self.image=[UIImage imageNamed:defaultImageName];
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imgdata=[[NSData alloc] initWithContentsOfFile:localImageFilePath];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image=[UIImage imageWithData:imgdata];
                });
             });

//            self.image=[UIImage imageWithContentsOfFile:localImageFilePath];
        }
    }
    else
    {
        if (defaultImageName.length>0)
            self.image=[UIImage imageNamed:defaultImageName];
    }
}

#pragma mark ---异步下载完成
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSError *error=[request error];
    if (error) {
        return;
    }
    if ([request responseStatusCode]/100!=2 )
        return;
    
    //创建图片,图片来源于ASIHTTPRequest对象（NSSData类型）
    NSString *filenamepath=request.userInfo[@"localFilePath"];
    NSData *filedata=[request responseData];
    if (filedata.length<20) return;
    
    [filedata writeToFile:filenamepath atomically:NO];
    
    //param:cellView,imageView,rownum
    UIImageView *imgView=request.userInfo[@"imageView"];
    if ([localImageFilePath isEqualToString: filenamepath])
    {
//        imgView.contentMode = UIViewContentModeScaleAspectFit;
//        imgView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//        imgView.backgroundColor=[UIColor whiteColor];//SNS_BACKGROUND_SILVERCOLOR;
        imgView.image=[UIImage imageWithData:filedata];
    }
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(completeDownloadImage:imageLocalPath:)])
    {
        [_delegate completeDownloadImage:self imageLocalPath:localImageFilePath];
    }
}

@end
