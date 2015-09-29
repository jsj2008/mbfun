//
//  PraiseBoxView.h
//  Wefafa
//  app stroe点赞、投诉页面
//  Created by wave on 15/8/27.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *IS_PRAISEBOX_HASSHOW = @"IS_PRAISEBOX_HASSHOW";

@interface PraiseBoxView : NSObject
/**
 *  登陆提示评价
 */
+ (instancetype)loginToShow;
/**
 *  app内操作提示评价
 */
+ (instancetype)show;
@end
