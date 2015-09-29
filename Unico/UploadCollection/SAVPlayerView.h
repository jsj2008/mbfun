//
//  SAVPlayerView.h
//  Wefafa
//
//  Created by chencheng on 15/8/26.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *   视频播放器——默认只能播放小于等于10秒的视频
 */
@interface SAVPlayerView : UIView

@property(assign, readwrite, nonatomic)BOOL autoSetVolumeWithSystemVolume;//自动使用系统音量，可以通过左边的音量键控制音量
@property(assign, readwrite, nonatomic)BOOL tapForPlayOrPause;//单击自动暂停或者播放
@property(assign, readwrite, nonatomic)float volume;//0.0 ~ 1.0

@property (assign, readwrite, nonatomic) BOOL loopEnabled;

- (id)initWithAsset:(AVAsset *)asset;
- (id)initWithURL:(NSURL *)url;

- (void)setURL:(NSURL *)url;

- (void)setUrlForString:(NSString *)urlString;

- (BOOL)isPlaying;

- (void)play;

- (void)pause;

- (UIImage *)currentFrame;

- (void)seekToTime:(float)startTime endTime:(float)endTime;



@end
