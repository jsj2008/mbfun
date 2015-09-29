//
//  SCVideoPlayerViewController.h
//  SCAudioVideoRecorder
//
//  Created by Simon CORSIN on 8/30/13.
//  Copyright (c) 2013 rFlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRecorder.h"

@interface SCVideoPlayerViewController : UIViewController<SCPlayerDelegate>

@property (strong, nonatomic) SCRecordSession *recordSession;
@property (weak, nonatomic) IBOutlet SCSwipeableFilterView *filterSwitcherView;

@property (assign, readwrite, nonatomic)float heightWidthRatio;

-(void)changeFilter:(int)offsetIndex;
-(void)changeFilterTo:(int)newIndex;



-(int)getFilterIndex;

-(void)saveToCameraRoll;

-(void)saveVideo:(SDataVideoFunc)completeFunc;
-(void)saveVideoWithYOffset:(float)yOffsetPercent withCompletion:(SDataVideoFunc)competeFunc;
-(void)saveVideoWithYOffset:(float)yOffsetPercent startTime:(float)startTime endTime:(float)endTime withCompletion:(SDataVideoFunc)competeFunc;

-(void)saveVideoWithYOffset:(float)yOffsetPercent heightWidthRatio:(float)heightWidthRatio rotate:(BOOL)rotate startTime:(float)startTime endTime:(float)endTime withCompletion:(SDataVideoFunc)competeFunc;

-(void)seekToTimeAndReplay:(CMTime)time;

-(UIImage*)snapImage;
@end
