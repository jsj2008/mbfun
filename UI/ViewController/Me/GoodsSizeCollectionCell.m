//
//  GoodsSizeCollectionCell.m
//  Wefafa
//
//  Created by Jiang on 15/8/28.
//  Copyright (c) 2015年 Kong. All rights reserved.
//

#import "GoodsSizeCollectionCell.h"
#import "MBGoodsDetailesSpecModel.h"
#import "Utils.h"
#import "SUtilityTool.h"

@interface GoodsSizeCollectionCell ()
//@property (weak, nonatomic) UILabel *lb;
@end

@implementation GoodsSizeCollectionCell

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
    UILabel *lb = [[UILabel alloc] initWithFrame:rect];
    lb.layer.borderColor = COLOR_C9.CGColor;
    lb.layer.borderWidth = 0.5f;
#if 0
    lb.textColor = COLOR_C2;
#else 
    lb.textColor = COLOR_C6;
#endif
    lb.font = FONT_t7;
    lb.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:lb];
    
    self.lb = lb;
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.lb.layer.borderWidth = 2.f;
        self.lb.layer.borderColor = COLOR_C1.CGColor;//[UIColor yellowColor].CGColor;
//        self.lb.font = FONT_T7;
    } else {
        self.lb.layer.borderWidth = 0.5f;
        self.lb.layer.borderColor = COLOR_C9.CGColor;//[UIColor lightGrayColor].CGColor;
//        self.lb.font = FONT_T7;
    }
}

//- (void)setContentModel:(MBGoodsDetailesSpecModel *)contentModel{
//    _contentModel = contentModel;
//    self.lb.text = contentModel.name;
//    self.userInteractionEnabled = !contentModel.isUnStock;
//    if (contentModel.isUnStock) {
//        self.alpha = 0.2;
//    }else{
//        self.alpha = 1;
//    }
//}


@end
