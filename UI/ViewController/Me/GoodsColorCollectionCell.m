//
//  GoodsColorCollectionCell.m
//  Wefafa
//
//  Created by Jiang on 15/8/28.
//  Copyright (c) 2015年 Kong. All rights reserved.
//

#import "GoodsColorCollectionCell.h"
#import "MBGoodsDetailsColorModel.h"
#import "CommMBBusiness.h"
#import "SUtilityTool.h"
#import "Utils.h"

@interface GoodsColorCollectionCell ()
@end

@implementation GoodsColorCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
    }
    return self;
}

- (void)initializer
{
    CGRect rect = self.bounds;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    imgView.layer.borderColor = COLOR_C9.CGColor;//[UIColor lightGrayColor].CGColor;
    imgView.layer.borderWidth = 0.5f;
    imgView.image = [UIImage imageNamed:NONE_DATA_ITEM];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.masksToBounds = YES;
    [self.contentView addSubview:imgView];
    
    self.imgView = imgView;
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.imgView.layer.borderWidth = 2.f;
        self.imgView.layer.borderColor = COLOR_C1.CGColor;//[UIColor yellowColor].CGColor;
    } else {
        self.imgView.layer.borderWidth = 0.5f;
        self.imgView.layer.borderColor = COLOR_C9.CGColor;//[UIColor lightGrayColor].CGColor;
    }
}

@end
