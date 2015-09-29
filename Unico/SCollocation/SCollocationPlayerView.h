//
//  SCollocationPlayerView.h
//  Wefafa
//
//  Created by Jiang on 8/2/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SCVideoPlayerView.h"

@interface SCollocationPlayerView : UIView

//搭配模型
@property (nonatomic, strong) SCollocationDetailModel *contentModel;
@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) NSArray *contentArray;
/**
 *	@简要 视频开始播放
 */
- (void)playerViewPlay;

/**
 *	@简要 视频暂停播放
 */
- (void)playerViewPause;
@end
