//
//  SCollocationCommitmentsView.m
//  Wefafa
//
//  Created by unico_0 on 7/24/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SCollocationCommitmentsView.h"
#import "ShowAdvertisementView.h"
#import "SCollocationDetailModel.h"
#import "SUtilityTool.h"

@interface SCollocationCommitmentsView ()

@property (nonatomic, strong) ShowAdvertisementView *advertView;

@end

@implementation SCollocationCommitmentsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    titleLabel.font = FONT_t4;
    titleLabel.textColor = COLOR_C2;
    titleLabel.text = @"有范承诺";
    [self addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unico/funcn.jpg"]];
    imageView.frame = CGRectMake(0, 30, UI_SCREEN_WIDTH, SCALE_UI_SCREEN * 67);
    [self addSubview:imageView];
    
    _advertView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), UI_SCREEN_WIDTH, 115 * SCALE_UI_SCREEN)];
    [self addSubview:_advertView];
}

- (void)setContentModel:(SCollocationDetailModel *)contentModel{
    _contentModel = contentModel;
    _advertView.contentModelArray = contentModel.banner;
    SDiscoveryBannerModel *model = [contentModel.banner firstObject];
    if (model.img_width.floatValue > 0) {
        _advertView.height = model.img_height.floatValue * (UI_SCREEN_WIDTH/ model.img_width.floatValue);
    }else{
        _advertView.height = 0;
    }
    
}

@end
