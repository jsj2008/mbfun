//
//  JSWebAgilityNavigationViewController.h
//  Wefafa
//
//  Created by Mr_J on 15/9/7.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "JSWebViewController.h"
@class ShoppIngBagShowButton, SMenuBottomModel;

@interface JSWebAgilityNavigationViewController : JSWebViewController

@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;
@property (nonatomic, strong) UIView *navigationTitleView;
@property (nonatomic, copy) NSString *titleViewUrl;
@property (nonatomic, strong) SMenuBottomModel *layoutModel;

@end
