//
//  SCImageViewDisPlayViewController.h
//  SCAudioVideoRecorder
//
//  Created by 曾 宪华 on 13-11-5.
//  Copyright (c) 2013年 rFlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRecorder.h"
#import "SCImageFilterView.h"

@interface SCImageDisplayerViewController : UIViewController

@property (nonatomic, strong) UIImage *photo;
@property (weak, nonatomic) IBOutlet SCImageFilterView *filterSwitcherView;

-(void)changeFilterTo:(int)index;
-(void)changeFilter:(int)offsetIndex;
-(void)saveToCameraRoll;
- (UIImage*)saveImage;
@end
