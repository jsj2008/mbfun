//
//  SDiscoveryActivityShowPlayerView.h
//  Wefafa
//
//  Created by unico_0 on 7/23/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SActivityProductListModel;

@protocol SDiscoveryActivityShowPlayerViewDelegate <NSObject>

- (void)activityGoodsBuyNow:(UIButton *)button model:(SActivityProductListModel *)model;
- (void)activityGoodsTouchContentImage:(UIImageView *)imageView model:(SActivityProductListModel *)model;

@end

@interface SDiscoveryActivityShowPlayerView : UIView

@property (nonatomic, assign) id<SDiscoveryActivityShowPlayerViewDelegate> delegate;
@property (nonatomic, strong) SActivityProductListModel *contentModel;
@property (nonatomic, copy) NSString *surplusTimeString;
@property (nonatomic, assign, getter=isActivityEnd) BOOL activityEnd;

@end
