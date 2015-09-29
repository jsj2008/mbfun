//
//  SMinProductCell.m
//  Wefafa
//
//  Created by Jiang on 15/8/26.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMinProductCell.h"
#import "SMineProduct.h"
#import "UIImageView+WebCache.h"
#import "SUtilityTool.h"

static const CGFloat kTagLbH = 20.f;

@implementation SMinProductCell

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
    //
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.tag = 100;
    imgV.image = [UIImage imageNamed:@"裤子"];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    imgV.layer.borderWidth = 0.5f;
    imgV.layer.borderColor = COLOR_C9.CGColor;
    imgV.userInteractionEnabled = YES;
    [self.contentView addSubview:imgV];
    
    //
    UILabel *maskLb = [[UILabel alloc] init];
    maskLb.tag = 200;
    maskLb.font = FONT_t6;
    maskLb.textAlignment = NSTextAlignmentCenter;
    maskLb.textColor = [UIColor whiteColor];
    maskLb.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
    [self.contentView addSubview:maskLb];
    
    //
    UILabel *tagLb = [[UILabel alloc] init];
    tagLb.tag = 300;
    tagLb.font = FONT_t7;
    tagLb.textAlignment = NSTextAlignmentCenter;
    tagLb.backgroundColor = [UIColor clearColor];
    tagLb.opaque = NO;
    tagLb.textColor = [UIColor blackColor];
    [self.contentView addSubview:tagLb];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
//    UIImageView *imgV = (UIImageView *)[self.contentView viewWithTag:100];
//    UILabel *maskLb = (UILabel *)[self.contentView viewWithTag:200];
//    UILabel *tagLb = (UILabel *)[self.contentView viewWithTag:300];
    
    imgV.frame = CGRectMake(0, 0, width, height-kTagLbH);
    
    CGFloat maskLbY = CGRectGetMaxY(imgV.frame)-kTagLbH;
    maskLb.frame = CGRectMake(0, maskLbY, width, kTagLbH);
    
    CGFloat tagLbY = CGRectGetMaxY(imgV.frame);
    tagLb.frame = CGRectMake(0, tagLbY, width, kTagLbH);
}
/*
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    UIImageView *imgV = (UIImageView *)[self.contentView viewWithTag:100];
    UILabel *maskLb = (UILabel *)[self.contentView viewWithTag:200];
    UILabel *tagLb = (UILabel *)[self.contentView viewWithTag:300];
    
    imgV.frame = CGRectMake(0, 0, width, height-kTagLbH);
    
    CGFloat maskLbY = CGRectGetMaxY(imgV.frame)-kTagLbH;
    maskLb.frame = CGRectMake(0, maskLbY, width, kTagLbH);
    
    CGFloat tagLbY = CGRectGetMaxY(imgV.frame);
    tagLb.frame = CGRectMake(0, tagLbY, width, kTagLbH);
}*/

- (void)setProduct:(SMineProduct *)product
{
    _product = product;
    
    UIImageView *imgV = (UIImageView *)[self.contentView viewWithTag:100];
    UILabel *maskLb = (UILabel *)[self.contentView viewWithTag:200];
    UILabel *tagLb = (UILabel *)[self.contentView viewWithTag:300];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:product.product_img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        imgV.image = image;
    }];

    NSString *productCode=[NSString stringWithFormat:@"%@",product.product_code];
    if ([Utils getSNSString:productCode].length != 0) {
        NSString *salePrice=[NSString stringWithFormat:@"%f",product.price];
        maskLb.text = [Utils getSNSRMBMoney:salePrice];
        maskLb.hidden = NO;
    } else {
        maskLb.text = @"";
        maskLb.hidden = YES;
    }
    
    NSString *salePriTempStr = [self jugeNullWithText:product.cate_value];
    NSString *priTempStr = [self jugeNullWithText:product.brand_value];
    tagLb.text = [NSString stringWithFormat:@"%@%@", priTempStr, salePriTempStr];
}

- (NSString *)jugeNullWithText:(NSString *)text
{
    NSString *tempStr = @"";
    if ([text isEqualToString:@"(null)"]) {
        tempStr = @"";
    } else {
        tempStr = text;
    }
    return tempStr;
}

@end
