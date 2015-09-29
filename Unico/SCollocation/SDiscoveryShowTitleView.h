//
//  SDiscoveryShowTitleView.h
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDiscoveryFlexibleModel;

@protocol SDiscoveryShowTitleViewDelegate <NSObject>

- (void)showTitleTouchMoreButton:(UIButton*)sender;

@end

@interface SDiscoveryShowTitleView : UIView

@property (nonatomic, assign) id<SDiscoveryShowTitleViewDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, strong) SDiscoveryFlexibleModel *contentModel;
@property (nonatomic, weak) UIButton *moreButton;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, weak) UIView *decorateView;
@property (nonatomic, assign) BOOL isHiddenLine;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;
- (void)initSubViews;

@end
