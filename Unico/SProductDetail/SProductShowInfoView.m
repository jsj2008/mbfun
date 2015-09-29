//
//  SProductShowInfoView.m
//  Wefafa
//
//  Created by unico_0 on 7/30/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SProductShowInfoView.h"
#import "MBUserStatisticsFilterList.h"
#import "SUtilityTool.h"

@interface SProductShowInfoView ()

@property (nonatomic, strong) NSMutableArray *contentViewArray;

@end

@implementation SProductShowInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)awakeFromNib{
    [self initSubViews];
}

- (void)initSubViews{
    _contentViewArray = [NSMutableArray array];
    CGFloat width = (UI_SCREEN_WIDTH - 46 - 36)/ 3;
    CGFloat layerSpace = (UI_SCREEN_WIDTH - 46)/ 3;
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(23 + i * width + i * 18, 0, width, self.height)];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width*i, 0, width, self.height)];
        label.textAlignment = i;
        label.font = FONT_t6;
        label.textColor = COLOR_C2;
        [self addSubview:label];
        [_contentViewArray addObject:label];
        if (i >= 2) {
            continue;
        }
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(8 + (i + 1) * layerSpace + i * 30, 5, 0.5, self.height - 10);
        layer.backgroundColor = UIColorFromRGB(0xd9d9d9).CGColor;
        [self.layer addSublayer:layer];
    }
}

- (void)setContentModel:(MBUserStatisticsFilterList*)contentModel{
    _contentModel = contentModel;
    
    if (contentModel.commentCount.intValue <= 0) {
        contentModel.avgComment = @5;
    }
    UILabel *label = _contentViewArray[0];
    label.text = [NSString stringWithFormat:@"月销量%d件", contentModel.saleQty.intValue];
    label = _contentViewArray[1];
    label.text = [NSString stringWithFormat:@"好评度%d%%", contentModel.avgComment.intValue * 20];
    label = _contentViewArray[2];
    label.text = [NSString stringWithFormat:@"收藏%d人", contentModel.favoritCount.intValue];
}

@end
