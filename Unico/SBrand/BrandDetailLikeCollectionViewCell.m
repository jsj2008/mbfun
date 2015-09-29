//
//  BrandDetailLikeCollectionViewCell.m
//  Wefafa
//
//  Created by wave on 15/8/7.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "BrandDetailLikeCollectionViewCell.h"


@interface BrandDetailLikeCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;

@end

@implementation BrandDetailLikeCollectionViewCell

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    [_contentImg sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
}

- (void)awakeFromNib {
    // Initialization code
    _contentImg.layer.cornerRadius = 30/2;
    _contentImg.layer.masksToBounds = YES;
}

@end
