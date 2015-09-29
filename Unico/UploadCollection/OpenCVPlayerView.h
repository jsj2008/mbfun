//
//  OpenCVPlayerView.h
//  Wefafa
//
//  Created by chen cheng on 15/8/18.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenCVTool.h"

@interface OpenCVPlayerView : UIView



+(IplImage*)cvQueryFrameFromCapture:(CvCapture**)capture videoFilePath:(NSString *)videoFilePath;

- (id)initWithCapture:(CvCapture **)capture videoFilePath:(NSString *)videoFilePath;


- (BOOL)playing;

- (void)play;

- (void)pause;

- (UIImage *)currentFrame;


@end
