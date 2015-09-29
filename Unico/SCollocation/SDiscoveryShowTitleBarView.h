//
//  SDiscoveryShowTitleBarView.h
//  Wefafa
//
//  Created by Mr_J on 15/9/1.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDiscoveryFlexibleModel;

@interface SDiscoveryShowTitleBarView : UIView

@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) SDiscoveryFlexibleModel *contentModel;

@end
