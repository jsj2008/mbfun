//
//  STimePeriodSelecterControl.h
//  Wefafa
//
//  Created by chencheng on 15/8/26.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *   时间段选择器
 */
@interface STimePeriodSelecterControl : UIControl


@property(assign, readonly, nonatomic)float totalDuration;//总的时间
@property(assign, readonly, nonatomic)float startSelecterTime;//选取器的开始时间
@property(assign, readonly, nonatomic)float endSelecterTime;//选取器的结束时间
@property(assign, readonly, nonatomic)float miniSelecterDuration;//选取器的最小选择范围
@property(assign, readonly, nonatomic)float maxSelecterDuration;//选取器的最大选择范围


- (id)initWithFrame:(CGRect)frame totalDuration:(float)totalDuration miniSelecterDuration:(float)miniSelecterDuration maxSelecterDuration:(float)maxSelecterDuration;


@end
