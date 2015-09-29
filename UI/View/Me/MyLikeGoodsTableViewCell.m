//
//  MyLikeGoodsTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-10-20.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MyLikeGoodsTableViewCell.h"
#import "Utils.h"
#import "AppSetting.h"
#import "CommMBBusiness.h"

@implementation MyLikeGoodsTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(id)data
{
    _data=data;
    _imageGoods.image=[UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    _lbPrice.text=@"--";
    _lbName.text=@"--";
    
    if (_data[@"prodList"]!=nil&&((NSArray*)_data[@"prodList"]).count>0)
    {
        NSDictionary *dict1=_data[@"prodList"][0];
        if(dict1[@"clsPicUrl"]!=nil&&((NSArray*)dict1[@"clsPicUrl"]).count>0)
        {
            NSDictionary *dict2=dict1[@"clsPicUrl"][0];
            [_imageGoods downloadImageUrl:[CommMBBusiness changeStringWithurlString:[Utils getSNSString:dict2[@"filE_PATH"]] size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:DEFAULT_LOADING_IMAGE];
        }
        if(dict1[@"clsList"]!=nil&&((NSArray*)dict1[@"clsList"]).count>0)
        {
            NSDictionary *dict2=dict1[@"clsList"][0];
            _lbPrice.text=[Utils getSNSMoney:dict2[@"sale_price"]];
            _lbName.text=[Utils getSNSString:dict2[@"name"]];
        }
    }
}

@end
