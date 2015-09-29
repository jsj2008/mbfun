//
//  SDiscoveryBrZoneCollectionViewCell.m
//  Wefafa
//
//  Created by metesbonweios on 15/8/3.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SDiscoveryBrZoneCollectionViewCell.h"
#import "SUtilityTool.h"
#import "Utils.h"
#import "SBrandStoryDetailModel.h"
@implementation SDiscoveryBrZoneCollectionViewCell

- (void)awakeFromNib {
    _brandLogo.layer.cornerRadius = _brandLogo.bounds.size.width /2;
    _brandLogo.layer.borderWidth = 1.0;
    _brandLogo.layer.borderColor = [Utils HexColor:0xd9d9d9 Alpha:1].CGColor;
    _brandLogo.layer.masksToBounds = YES;
    _brandName.backgroundColor=[UIColor clearColor];
    _likeCountLabe.backgroundColor=[UIColor clearColor];
    _brandName.font=FONT_T6;
    _likeCountLabe.font=FONT_t8;
    _likeCountLabe.textColor=[Utils HexColor:0xbbbbbb Alpha:1];
}
-(void)setContentDataModel:(SBrandStoryDetailModel *)contentDataModel
{
    _contentDataModel=contentDataModel;
    _brandName.text=[NSString stringWithFormat:@"%@",contentDataModel.english_name];
    [_brandLogo sd_setImageWithURL:[NSURL URLWithString:contentDataModel.logo_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    _likeCountLabe.text=[NSString stringWithFormat:@"%@喜欢",contentDataModel.like_count];
    
    
}
@end
