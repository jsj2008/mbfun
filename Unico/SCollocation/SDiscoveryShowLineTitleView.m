//
//  SDiscoveryShowLineTitleView.m
//  Wefafa
//
//  Created by Mr_J on 15/9/22.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SDiscoveryShowLineTitleView.h"
#import "SDiscoveryFlexibleModel.h"

@interface SDiscoveryShowLineTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SDiscoveryShowLineTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.userInteractionEnabled = NO;
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, UI_SCREEN_WIDTH - 30, 0.5)];
    _lineView.centerY = self.height/ 2.0;
    _lineView.width = self.width - 30;
    _lineView.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [self addSubview:_lineView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
    _titleLabel.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _titleLabel.textColor = UIColorFromRGB(0xd9d9d9d);
    _titleLabel.font = [UIFont systemFontOfSize:10];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _lineView.width = self.width - 30;
    _lineView.centerY = self.height/ 2.0;
    _titleLabel.height = self.height;
    _titleLabel.center = CGPointMake(self.width/ 2.0, self.height/ 2.0);
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    _titleLabel.text = contentModel.name;
    CGSize size = [contentModel.name sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];
    _titleLabel.width = size.width + 60;
    _titleLabel.centerX = self.width/ 2.0;
}

@end
