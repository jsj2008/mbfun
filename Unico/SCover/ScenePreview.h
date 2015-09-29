//
//  ScenePreview.h
//  Wefafa
//
//  Created by moooc on 15/7/9.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>

@interface ScenePreview : UIView<AVAudioPlayerDelegate>
{
    NSMutableArray *_imageMutableArray;
    
    UIView  *_previewPlayerView;//预览播放器
    MPMoviePlayerController *_moviePlayerController;
    
    AVAudioPlayer *_player;
}

@property(strong, readwrite, nonatomic)NSArray *assetsArray;//用于预览视频的照片资源数组

- (void)startPreview;//开始预览

- (void)createMP4FileWithUpdateProgress:(void (^)(float progress, NSString *mp4Filepath))updateProgress;

@end
