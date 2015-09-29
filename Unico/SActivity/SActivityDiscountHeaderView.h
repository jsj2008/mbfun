//
//  SActivityDiscountHeaderView.h
//  Wefafa
//
//  Created by unico_0 on 6/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SActivityListModel;
@class SMBNewActivityListModel;
@protocol SActivityDiscountHeaderViewDelegate <NSObject>

@optional
- (void)activityReceiveButton:(UIButton *)button;
- (void)activityReceiveEndNavigation;

@end

@interface SActivityDiscountHeaderView : UIView

@property (nonatomic, assign) id<SActivityDiscountHeaderViewDelegate> delegate;
@property (nonatomic, strong) SMBNewActivityListModel *contentModel;
@property (nonatomic, strong) UIButton *receiveButton;

@end
