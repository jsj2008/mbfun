//
//  MBCollocationCollectionViewCell.m
//  Wefafa
//
//  Created by Jiang on 5/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBCollocationCollectionViewCell.h"
#import "MBGoodsDetailListModel.h"
#import "UIImageView+AFNetworking.h"
#import "Utils.h"

@interface MBCollocationCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UIView *showStateContentView;

@property (weak, nonatomic) IBOutlet UILabel *showStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *showPricLabel;

@end

@implementation MBCollocationCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setContentModel:(MBGoodsDetailListModel *)contentModel{
    _contentModel = contentModel;
    self.showPricLabel.text = [NSString stringWithFormat:@"￥%@", contentModel.proudctList.clsInfo.sale_price];
    UIImage *image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.detailInfo.productPictureUrl] placeholderImage:image];
    if (contentModel.proudctList.clsInfo.status.intValue != 2) {
        self.showStateContentView.hidden = NO;
        self.showStateLabel.text = @"已下架";
    }else if(contentModel.proudctList.clsInfo.stockCount.intValue <= 0){
        self.showStateContentView.hidden = NO;
        self.showStateLabel.text = @"已售罄";
    }else{
        self.showStateContentView.hidden = YES;
    }
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
    NSArray * arr = [Utils rgbFromHexColor:0xE2E2E2 Alpha:1];
    float red = [(NSString*)arr[0] integerValue]/255.0f;
    float green = [(NSString*)arr[1] integerValue]/255.0f;
    float blue = [(NSString*)arr[2] integerValue]/255.0f;
    
    CGContextSetRGBStrokeColor(context,
                               red, green, blue, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,
                         self.bounds.size.width, 0);
    CGContextAddLineToPoint(context,
                            self.bounds.size.width, self.bounds.size.height);
    CGContextAddLineToPoint(context,
                            0, self.bounds.size.height);
    CGContextStrokePath(context);
}


@end
