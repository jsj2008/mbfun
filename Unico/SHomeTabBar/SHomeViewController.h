//
//  SHomeViewController.h
//  Wefafa
//
//  Created by unico_0 on 6/17/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMenuBottomModel;

extern BOOL g_socialStatus;

@interface SHomeViewController : UITabBarController

@property (nonatomic, weak) UIScrollView *controlScrollView;
@property (nonatomic, weak) UIScrollView *scrollViewBegin;

@property (nonatomic, weak) NSNumber *isShowTabbar;
@property (nonatomic, strong) NSString *messageBadge;
@property (nonatomic, strong) SMenuBottomModel *layoutModel;

+ (SHomeViewController*)instance;
@end
