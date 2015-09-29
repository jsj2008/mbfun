//
//  PhotoVideoSceneSelecteViewController.h
//  Wefafa
//
//  Created by moooc on 15/7/9.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScenePreview.h"


@interface PhotoVideoSceneSelecteViewController : UIViewController
{
    UILabel *_titleLabel;
    
    NSArray *_assetsArray;
    
    UIView  *_previewPlayerView;//预览播放器
    
    UIScrollView *_sceneScrollView;//场景滚动视图
    
    int      _currentSceneIndex;
    
    UIView   *_sceneSelectedView;//场景选择视图
    
    ScenePreview *_scenePreview;
    
    NSString  *_mp4FilePath ;
}

@property(strong, readwrite, nonatomic)NSArray *assetsArray;//用于制作视频的照片数组

@end
