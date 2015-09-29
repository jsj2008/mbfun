//
//  SDiscoveryShowConfigPicAndTextView.h
//  Wefafa
//
//  Created by metesbonweios on 15/7/30.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDiscoveryFlexibleModel;
@class SDiscoveryPicAndTextModel;
@interface SDiscoveryShowConfigPicAndTextView : UIView

@property (nonatomic, strong) SDiscoveryFlexibleModel *contentModel;
@property (nonatomic, strong) NSArray *contentModelArray;
@property (nonatomic, assign) UIViewController *target;
@end

@interface SDiscoveryPicAndTextViewContentView : UIView

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descripLabel;
@end
