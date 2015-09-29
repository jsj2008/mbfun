//
//  SHomeAgilityViewController.m
//  Wefafa
//
//  Created by unico_0 on 7/9/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SHomeAgilityTableViewCell.h"
#import "SHomeAgilityModel.h"
#import "SUtilityTool.h"

@interface SHomeAgilityTableViewCell ()

@property (nonatomic, strong) NSMutableArray *contentViewArray;

@end

@implementation SHomeAgilityTableViewCell

- (void)awakeFromNib{
    _contentViewArray = [NSMutableArray array];
}

- (void)setContentModel:(SHomeAgilityModel *)contentModel{
    _contentModel = contentModel;
    [self showContent];
}

- (void)showContent{
    NSInteger count = _contentModel.config.count - _contentViewArray.count;
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchJump:)];
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
        imageView.hidden = NO;
        imageView.tag = 20 + i;
        
        CGFloat scale = (UI_SCREEN_WIDTH/ _contentModel.width.floatValue);
        CGFloat height = model.height.floatValue * scale;
        CGFloat width = model.width.floatValue * scale;
        CGFloat oringin_X = model.x.floatValue * scale;
        CGFloat oringin_Y = model.y.floatValue * scale;
        imageView.frame = CGRectMake(oringin_X, oringin_Y, width, height);
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageProgressiveDownload | SDWebImageHighPriority];
    }
}

- (void)touchJump:(UITapGestureRecognizer*)tap{
    NSInteger index = tap.view.tag - 20;
    SHomeAgilityConfigModel *model = _contentModel.config[index];
    [[SUtilityTool shared]jumpControllerWithContent:model.jump.dict target:_target];
}

@end