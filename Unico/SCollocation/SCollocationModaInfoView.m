//
//  SCollocationModaInfoView.m
//  Wefafa
//
//  Created by Mr_J on 15/9/8.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SCollocationModaInfoView.h"
#import "SCollocationDetailModel.h"

@interface SCollocationModaInfoView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *contentViewArray;
@property (nonatomic, strong) NSArray *showNameArray;

@end

@implementation SCollocationModaInfoView

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
    _titleLabel.text = @"模特资料";
    _titleLabel.textColor = UIColorFromRGB(0x3b3b3b);
    _titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_titleLabel];
    
    _showNameArray = @[@"身高:", @"体型:", @"年龄:"];
    
    [self initContentShowView];
}

- (void)initContentShowView{
    _contentViewArray = [NSMutableArray array];
    CGFloat width = (UI_SCREEN_WIDTH - 20)/ 3.0;
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 + width * i, 30, width, 40)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UIColorFromRGB(0x3b3b3b);
        label.textAlignment = i;
        label.text = _showNameArray[i];
        [self addSubview:label];
        [_contentViewArray addObject:label];
    }
    for (int i = 1; i < 3; i ++) {
        CALayer *layer = [CALayer layer];
        layer.zPosition = 5;
        layer.backgroundColor = UIColorFromRGB(0x3b3b3b).CGColor;
        layer.frame = CGRectMake(width * i + (i - 1) * 20, 30 + 12, 1, 16);
        [self.layer addSublayer:layer];
    }
}

- (void)setContentModel:(SCollocationDetailModel *)contentModel{
    _contentModel = contentModel;
    NSDictionary *userInfo = contentModel.user_json;
    UILabel *label = _contentViewArray[0];
    
    NSString *heightString = [[NSString stringWithFormat:@"%@", userInfo[@"height"]] isEqualToString:@"0"]? @"身高: 保密": [NSString stringWithFormat:@"身高: %@cm", userInfo[@"height"]];
    NSString *weightString = [[NSString stringWithFormat:@"%@",userInfo[@"weight"]] isEqualToString:@""]? @"体型: 保密": [NSString stringWithFormat:@"体型: %@", userInfo[@"weight"]];
    NSString *ageString = [[NSString stringWithFormat:@"%@",userInfo[@"age"]] isEqualToString:@"0"]? @"年龄: 保密": [NSString stringWithFormat:@"年龄: %@岁", userInfo[@"age"]];
    
    label.text = heightString;
    label = _contentViewArray[1];
    label.text = weightString;
    label = _contentViewArray[2];
    label.text = ageString;
}

@end
