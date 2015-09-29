//
//  MyLikeCollocationTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-10-20.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MyLikeCollocationTableViewCell.h"
#import "AppSetting.h"
#import "Utils.h"
#import "CommMBBusiness.h"

@implementation MyLikeCollocationTableViewCell

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
    if (_data[@"collocationList"]!=nil&&((NSArray*)_data[@"collocationList"]).count>0)
    {
        NSDictionary *dict=_data[@"collocationList"][0][@"collocationInfo"];
        [_imageColl downloadImageUrl:[CommMBBusiness changeStringWithurlString:[Utils getSNSString:dict[@"pictureUrl"]] size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:DEFAULT_LOADING_IMAGE];
        _lbDesigner.text=[Utils getSNSString:dict[@"creatE_USER"]];
        _lbName.text=[Utils getSNSString:dict[@"name"]];
    }
    else
    {
        _imageColl.image=[UIImage imageNamed:DEFAULT_LOADING_IMAGE];
        _lbDesigner.text=@"--";
        _lbName.text=@"--";
    }
}

@end
