//
//  SProductShowImageCell.m
//  Wefafa
//
//  Created by Jiang on 8/3/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SProductShowImageCell.h"
#import "SCollocationDetailViewController.h"
#import "SUtilityTool.h"
@implementation SProductShowImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentImageView.frame = self.bounds;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}
-(void)initData:(NSDictionary *)dict{
        NSURL *url=[NSURL URLWithString:[dict objectForKey:@"video_url"]];
        @autoreleasepool{
            const char* queueName = [[[NSDate date] description] UTF8String];
            dispatch_queue_t myQueue = dispatch_queue_create(queueName, NULL);
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            
            dispatch_async(myQueue, ^{
                UIImage *image=[self CreateVideoImage:url];
                dispatch_async(mainQueue, ^{
                    if(self.contentImageView.image==nil)
                    self.contentImageView.image = image;
                });
            });
    }
}
-(UIImage *)CreateVideoImage:(NSURL *)url{
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:[AVAsset assetWithURL:url]];
    
    NSError *error=nil;
    CMTime actualTime;
    
    UIImage *image= nil;
    
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:kCMTimeZero actualTime:&actualTime error:&error];
    if(error == nil)
    {
        CMTimeShow(actualTime);
        image=[UIImage imageWithCGImage:cgImage];
        
        CGImageRelease(cgImage);
    }
    
    return image;
}
@end
