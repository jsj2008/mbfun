//
//  SBrandShowListContentCell.m
//  Wefafa
//
//  Created by lizhaoxiang on 15/5/24.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SBrandShowListContentCell.h"
#import "UIImageView+AFNetworking.h"
#import "FilterBrandCategoryModel.h"
#import "SUtilityTool.h"
@interface SBrandShowListContentCell ()
{
    CALayer *rightLayer;
    CALayer *bottomLayer;
}
@end

@implementation SBrandShowListContentCell

- (void)awakeFromNib {
  
    rightLayer = [CALayer layer];
    rightLayer.backgroundColor = COLOR_C9.CGColor;
    rightLayer.zPosition = 5;
    rightLayer.frame = CGRectMake(self.width-0.5, 0, 0.5, self.height);
    [self.layer addSublayer:rightLayer];
    
    bottomLayer = [CALayer layer];
    bottomLayer.backgroundColor = COLOR_C9.CGColor;
    bottomLayer.zPosition = 5;
    bottomLayer.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
    [self.layer addSublayer:bottomLayer];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    rightLayer.frame = CGRectMake(self.width-0.5 , 0, 0.5, self.height);
    bottomLayer.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}
/*
-(void)drawRect:(CGRect)rect
{
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context,
                        kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context, 0.5);
    //设置颜色
    CGContextSetStrokeColorWithColor(context, COLOR_C9.CGColor);
    //    cgcontextset
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context,
                         self.bounds.size.width, 0);
    //下一点
    CGContextAddLineToPoint(context,
                            self.bounds.size.width, self.bounds.size.height);
    //下一点
    CGContextAddLineToPoint(context,
                            0, self.bounds.size.height);
    //绘制完成
    CGContextStrokePath(context);
}
*/

- (void)setSelected:(BOOL)selected{
    [super setSelected:NO];
}

- (void)setBrandModel:(FilterBrandCategoryModel *)brandModel{
//    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:brandModel.logO_URL]];
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:brandModel.logO_URL] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
}

@end
