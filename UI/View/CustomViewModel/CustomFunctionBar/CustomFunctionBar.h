//
//  CustomFunctionBar.h
//  Wefafa
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MBCustomClassifyModelView.h"
#import "AttendCustomButton.h"

#define CustomFunctionBarHeight 50

@interface CustomFunctionBar : MBCustomClassifyModelView

@property (strong,nonatomic) NSMutableArray *itemDataArray;

-(ATTEND_CLICK_SHOW_VIEW_TYPE)getShowViewForIndex:(int)index;
-(void)setShowViewForIndex:(int)index showType:(ATTEND_CLICK_SHOW_VIEW_TYPE)showType;

@end
