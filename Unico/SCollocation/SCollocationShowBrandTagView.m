//
//  SCollocationShowBrandTagView.m
//  Wefafa
//
//  Created by Mr_J on 15/9/8.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SCollocationShowBrandTagView.h"
#import "SSearchResultViewController.h"
#import "STopicDetailViewController.h"
#import "DailyNewViewController.h"
#import "SCollocationGoodsTagModel.h"

@interface SCollocationShowBrandTagView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SCollocationShowBrandTagView

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
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, UI_SCREEN_WIDTH - 20, 40)];
    _titleLabel.text = @"所用品牌";
    _titleLabel.textColor = UIColorFromRGB(0x3b3b3b);
    _titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_titleLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setContentModel:(SCollocationDetailModel *)contentModel{
    _contentModel = contentModel;
    self.contentArray = contentModel.useBrand;
}

- (void)setTitleName:(NSString *)titleName{
    _titleName = [titleName copy];
    _titleLabel.text = _titleName;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    self.hidden = contentArray.count <= 0;
    CGFloat tag_X = 10.0;
    CGFloat tag_Y = 40;
    for(int i = 0; i < contentArray.count; i++){
        SCollocationGoodsTagModel *tagModel = contentArray[i];
        NSString *tagString = tagModel.text;
        CGSize size = [tagString boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 30, 0)
                                                         options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                                      attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
        if (size.width + 20 + tag_X > UI_SCREEN_WIDTH - 10) {
            tag_X = 10.0;
            tag_Y += 30;
        }
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(tag_X, tag_Y, size.width + 20, 25)];
        button.tag = i + 160;
        [button addTarget:self action:@selector(tagTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = UIColorFromRGB(0xbbbbbb);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:tagString forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3.0;
        [self addSubview:button];
        tag_X += size.width + 25;
    }
    
    CGRect frame = self.frame;
    frame.size.height += tag_Y - 50.0;
    self.frame = frame;
}

#pragma mark tag touch action
- (void)tagTouchAction:(UIButton*)sender{
    SCollocationGoodsTagModel *tagModel = _contentArray[sender.tag - 160];
    DailyNewViewController *controller = [[DailyNewViewController alloc]init];
    controller.brandId = tagModel.brandCode;
    [_target.navigationController pushViewController:controller animated:YES];
}

@end
