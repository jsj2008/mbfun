//
//  SDiscoveryShowImageCell.m
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryShowImageCell.h"
#import "SUtilityTool.h"

@interface SDiscoveryShowImageCell ()
{
    UIView *rightView;
    UIView *bottomView;
}

@end

@implementation SDiscoveryShowImageCell

- (void)awakeFromNib {
    // Initialization code
    
//    self.reserveImageView.size = CGSizeMake(35 * SCALE_UI_SCREEN, 35 * SCALE_UI_SCREEN);
//    self.reserveImageView.center = CGPointMake(self.width/ 2.0, self.height/ 2.0);
    self.reserveImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.reserveImageView.image = [UIImage imageNamed:@"Unico/icon_show_more"];
    
    rightView = [UIView new];
    rightView.backgroundColor = COLOR_C4;
    rightView.layer.zPosition = 5;
    rightView.frame = CGRectMake(self.width - 0.5, 0, 0.5, self.height);
    [self addSubview:rightView];
    
    bottomView = [UIView new];
    bottomView.backgroundColor = COLOR_C4;
    bottomView.layer.zPosition = 5;
    bottomView.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
    [self addSubview:bottomView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    
    rightView.frame = CGRectMake(self.width - 0.5, 0, 0.5, self.height);
    bottomView.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}

//-(void)drawRect:(CGRect)rect
//{
//    CGContextRef
//    context = UIGraphicsGetCurrentContext();
//    //指定直线样式
//    CGContextSetLineCap(context,
//                        kCGLineCapSquare);
//    //直线宽度
//    CGContextSetLineWidth(context, 0.5);
//    //设置颜色
//    CGContextSetStrokeColorWithColor(context, COLOR_C9.CGColor);
//    //    cgcontextset
//    //开始绘制
//    CGContextBeginPath(context);
//    //画笔移动到点(31,170)
//    CGContextMoveToPoint(context,
//                         self.bounds.size.width, 0);
//    //下一点
//    CGContextAddLineToPoint(context,
//                            self.bounds.size.width, self.bounds.size.height);
//    //下一点
//    CGContextAddLineToPoint(context,
//                            0, self.bounds.size.height);
//    //绘制完成
//    CGContextStrokePath(context);
//}

@end
