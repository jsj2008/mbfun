//
//  SDiscoveryShowTitleBarView.m
//  Wefafa
//
//  Created by Mr_J on 15/9/1.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SDiscoveryShowTitleBarView.h"
#import "SDiscoveryFlexibleModel.h"
#import "SUtilityTool.h"

@interface SDiscoveryShowTitleBarView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SDiscoveryShowTitleBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    _titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
    _titleLabel.textColor = UIColorFromRGB(999999);
    _titleLabel.font = [UIFont systemFontOfSize:13];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchJumpAction:)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.frame = self.bounds;
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    _titleLabel.text = contentModel.name;
}

- (void)touchJumpAction:(UITapGestureRecognizer*)tap{
    if (_contentModel.config.count <= 0) return;
    SDiscoveryBannerModel *model = _contentModel.config[0];
    [[SUtilityTool shared] jumpControllerWithContent:model.dict target:_target];
}

@end
