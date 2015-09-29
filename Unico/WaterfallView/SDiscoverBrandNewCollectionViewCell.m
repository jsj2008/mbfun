//
//  SDiscoverBrandNewCollectionViewCell.m
//  Wefafa
//
//  Created by metesbonweios on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SDiscoverBrandNewCollectionViewCell.h"
#import "SDiscoveryPicAndTextModel.h"
#import "Utils.h"

@implementation SDiscoverBrandNewCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setBrandModel:(SDiscoveryPicAndTextConfigModel *)brandModel{
    
    NSString *imgSt =[brandModel.small_img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:imgSt] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    [self.brandLabel setText:[NSString stringWithFormat:@"%@",brandModel.name]];
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
                          0.5f);
    
    //设置颜色
    NSArray * arr = [Utils rgbFromHexColor:0xd9d9d9 Alpha:1];
    float red = [(NSString*)arr[0] integerValue]/255.0f;
    float green = [(NSString*)arr[1] integerValue]/255.0f;
    float blue = [(NSString*)arr[2] integerValue]/255.0f;
    
    CGContextSetRGBStrokeColor(context,
                               red, green, blue, 1.0);
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
