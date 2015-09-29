//
//  SDiscoveryActiovityView.h
//  Wefafa
//
//  Created by unico_0 on 7/10/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//  活动倒计时

#import <UIKit/UIKit.h>
@class SDiscoveryFlexibleModel;

@interface SDiscoveryActiovityView : UIView

@property (nonatomic, strong) SDiscoveryFlexibleModel *contentModel;
@property (nonatomic, strong) NSArray *contentModelArray;
@property (nonatomic, assign) UIViewController *target;

@end

@interface SDiscoveryActiovityContentView : UIView

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end