//
//  OpenCVPlayerView.m
//  Wefafa
//
//  Created by chen cheng on 15/8/18.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "OpenCVPlayerView.h"
#import "OpenCVTool.h"
#include <sys/time.h>

@interface OpenCVPlayerView()
{
    UIImageView *_imageView;
    NSString    *_videoFilePath;
    CvCapture   **_capture;
    
    int _fps;
    
    BOOL _pause;
}

@end


static NSLock *g_lock = nil;

@implementation OpenCVPlayerView


+(IplImage*)cvQueryFrameFromCapture:(CvCapture**)capture videoFilePath:(NSString *)videoFilePath
{
    if (g_lock == nil)
    {
        g_lock = [[NSLock alloc] init];
    }
    
    [g_lock lock];
    
    IplImage *iplImage = nil;
    
    iplImage = cvQueryFrame(*capture);
    
    if (iplImage == nil)
    {
        cvReleaseCapture(capture);
        *capture = cvCreateFileCapture([videoFilePath UTF8String]);
        iplImage = cvQueryFrame(*capture);
    }
    
    [g_lock unlock];
    
    return iplImage;
}



- (id)initWithCapture:(CvCapture **)capture videoFilePath:(NSString *)videoFilePath
{
    self = [super init];
    if (self != nil)
    {
        _capture = capture;
        _videoFilePath = videoFilePath;
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
        _pause = YES;
        
        AVAsset *avAsset = [AVAsset assetWithURL:[[NSURL alloc] initFileURLWithPath:videoFilePath]];
        
        _fps = 24;
        
        NSArray * tracks = [avAsset tracks];
        for(AVAssetTrack* track in tracks)
        {
            if ([[track mediaType] isEqualToString:AVMediaTypeVideo])
            {
                _fps = track.nominalFrameRate;
                break;
            }
        }
        
        NSLog(@"_fps = %d", _fps);

    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if ([self playing])
    {
        [self pause];
    }
    else
    {
        [self play];
    }
}

- (void)dealloc
{
    [self pause];
    
    if (_capture != NULL && *_capture != nil)
    {
        cvReleaseCapture(_capture);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}

- (BOOL)playing
{
    return (!_pause);
}

- (void)pause
{
    _pause = YES;
}

- (UIImage *)currentFrame
{
    return _imageView.image;
}

- (void)play
{
    if (!_pause)
    {
        return;
    }
    
    
    _pause = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        while (!_pause)
        {
            for (int j=1; j<=_fps && !_pause; j++)
            {
                struct timeval time1;
                gettimeofday(&time1, NULL);

                
                IplImage  *iplImage = [OpenCVPlayerView cvQueryFrameFromCapture:_capture videoFilePath:_videoFilePath];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    @autoreleasepool {
                        
                        _imageView.image = OpenCVTool::createRGBAUIImageFromIplImage(iplImage);
                    }
                });
                
                struct timeval time2;
                gettimeofday(&time2, NULL);
                
                long d = (time2.tv_sec * 1000000 + time2.tv_usec) - (time1.tv_sec * 1000000 + time1.tv_usec);
                
                if (d < 1000000.0/_fps)
                {
                    usleep(1000000.0/_fps - d);
                }
            }
        }
    });
}

@end














