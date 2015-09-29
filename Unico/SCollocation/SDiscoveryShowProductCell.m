//
//  SDiscoveryShowProductCell.m
//  Wefafa
//
//  Created by unico_0 on 7/8/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryShowProductCell.h"
#import "SDiscoveryProductModel.h"
#import "SUtilityTool.h"

@implementation SDiscoveryShowProductCell

- (void)awakeFromNib {
    
}

- (void)setContentModel:(SDiscoveryProductModel *)contentModel{
    _contentModel = contentModel;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.item_img] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    self.nameLable.text = contentModel.name;
    self.describeLable.text = contentModel.info;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context,
                        kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,
                          1.0/ [UIScreen mainScreen].scale);
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

@end
