//
//  SAgilityNavigationBarTool.h
//  Wefafa
//
//  Created by Mr_J on 15/9/7.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMenuBottomModel;

@interface SAgilityNavigationBarTool : NSObject

- (UIButton *)createNavigationBarButtonWithType:(int)type target:(UIViewController*)target;
- (void)createNavigationTitleViewWithModel:(SMenuBottomModel*)layoutModel;

@end
