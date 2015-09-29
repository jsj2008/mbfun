//
//  SDiscoverShowBigPicAndTitleView.m
//  Wefafa
//
//  Created by metesbonweios on 15/7/30.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//  自由

#import "SDiscoverShowBigPicAndTitleView.h"
#import "SHomeAgilityModel.h"
#import "SUtilityTool.h"
#import "SDiscoveryFlexibleModel.h"

@interface SDiscoverShowBigPicAndTitleView  ()
{
}

@property (nonatomic, strong) NSMutableArray *contentViewArray;
@end

@implementation SDiscoverShowBigPicAndTitleView
-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return  self;
}

- (void)awakeFromNib{
    _contentViewArray = [NSMutableArray array];
    self.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];
    self.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)setContentModel:(SHomeAgilityModel *)contentModel{
    if (contentModel.config.count <= 0) return;
    _contentModel = contentModel.config[0];
    [self showContent];
}
- (void)setTarget:(UIViewController *)target{
    _target = target;
}
- (void)showContent{
    NSInteger count = _contentModel.config.count - _contentViewArray.count;
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImageJump:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
        [_contentViewArray addObject:imageView];
    }
    for (UIImageView *imageView in _contentViewArray){
        imageView.hidden = YES;
    }
    for (int i = 0; i < _contentModel.config.count; i++) {
        SHomeAgilityConfigModel *model = _contentModel.config[i];
        UIImageView *imageView = _contentViewArray[i];
        imageView.userInteractionEnabled = YES;
        imageView.hidden = NO;
        imageView.tag = 20 + i;
        CGFloat imageWidth = _contentModel.width.floatValue <= 0? 1: _contentModel.width.floatValue;
        CGFloat scale = (UI_SCREEN_WIDTH/ imageWidth);
        CGFloat height = model.height.floatValue * scale;
        CGFloat width = model.width.floatValue * scale;
        CGFloat oringin_X = model.x.floatValue * scale;
        CGFloat oringin_Y = model.y.floatValue * scale;
        imageView.frame = CGRectMake(oringin_X, oringin_Y, width, height);
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageProgressiveDownload | SDWebImageHighPriority];
    }
}

- (void)touchImageJump:(UITapGestureRecognizer*)tap{
    NSInteger index = tap.view.tag - 20;
    SHomeAgilityConfigModel *model = _contentModel.config[index];
    [[SUtilityTool shared]jumpControllerWithContent:model.jump.dict target:_target];
}

@end
