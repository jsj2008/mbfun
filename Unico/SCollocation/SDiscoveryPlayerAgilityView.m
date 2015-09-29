//
//  SDiscoveryPlayerAgilityView.m
//  Wefafa
//
//  Created by Mr_J on 15/8/25.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SDiscoveryPlayerAgilityView.h"
#import "SDiscoveryShowTitleView.h"
#import "ShowAdvertisementView.h"
#import "SDiscoveryFlexibleModel.h"
#import "SDiscoverShowBigPicAndTitleView.h"

@interface SDiscoveryPlayerAgilityView () <SDiscoveryShowTitleViewDelegate>

@property (nonatomic, strong) ShowAdvertisementView *advertView;
@property (nonatomic, strong) SDiscoveryShowTitleView *titleView;

@end

@implementation SDiscoveryPlayerAgilityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    self.backgroundColor = [UIColor whiteColor];
    _titleView = [[SDiscoveryShowTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40) title:@"灵活的"];
    _titleView.delegate = self;
    _titleView.subTitleLabel.hidden = NO;
    _titleView.moreButton.hidden = YES;
    [self addSubview:_titleView];
    
    _advertView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 115)];
    _advertView.hidden = YES;
    [self addSubview:_advertView];
}

- (void)setTarget:(UIViewController *)target{
    _target = target;
    _advertView.target = _target;
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    if (contentModel.banner_list.count > 0) {
        _advertView.hidden = NO;
        _advertView.contentModelArray = contentModel.banner_list;
    }else{
        _advertView.hidden = YES;
    }
    _titleView.titleString = contentModel.name;
    _titleView.subTitleLabel.text = contentModel.title;
}

- (void)showTitleTouchMoreButton:(UIButton *)sender{
    
}

@end
