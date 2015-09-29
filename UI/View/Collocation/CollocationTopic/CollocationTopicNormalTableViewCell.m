//
//  CollocationTopicNormalTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CollocationTopicNormalTableViewCell.h"
#import "Utils.h"
#import "AppSetting.h"
#import "CommMBBusiness.h"
#import "MBShoppingGuideInterface.h"

@implementation CollocationTopicNormalTableViewCell

- (void)awakeFromNib
{
//    _imageTopic.contentMode = UIViewContentModeScaleAspectFit;
    _imageTopic.backgroundColor=self.contentView.backgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(id)data1
{
    _data=data1;
    
//json{
//    "topicInfo": {
//        "id": 32,
//        "accounT_ORIGINAL_CODE": "gh_d6e75bc5e759",
//        "userId": "p7sbvsssss8sb9omon23f9hzke",
//        "code": "10000032",
//        "name": "秋季童装",
//        "status": 1,
//        "pictureUrl": "http://10.100.20.22/sources/Topic/%E4%B8%BB%E9%A2%9812.jpg",
//        "listinG_DATE": "\/Date(1410364800000-0000)\/",
//        "delistinG_DATE": "\/Date(1410364800000-0000)\/",
//        "remark": "Topic4",
//        "creatE_USER": "A00298S496",
//        "creatE_DATE": "\/Date(1410424906667-0000)\/",
//        "lasT_MODIFIED_USER": "A00298S496",
//        "lasT_MODIFIED_DATE": "\/Date(1410747368317-0000)\/"
//    },
//    "detailList": [
//    
//    ]
//},
    
    _imgPoint.backgroundColor=[Utils HexColor:0x66cccc Alpha:1.0];//]@"ico_history_pressed@3x.png"];
    _imgPoint.layer.cornerRadius=_imgPoint.frame.size.height/2;
    _imgVert.backgroundColor=[Utils HexColor:0x66cccc Alpha:1.0];
    _imgTopVert.backgroundColor=[Utils HexColor:0x66cccc Alpha:1.0];
    if (_row==0)
        _imgTopVert.hidden=YES;
    else
        _imgTopVert.hidden=NO;
    
    if (_data[@"topicInfo"]!=nil)
    {
        _lbName.text=[Utils getSNSString:_data[@"topicInfo"][@"name"]];
        
        NSString *jsondate=[Utils getSNSString:_data[@"topicInfo"][@"creatE_DATE"]];
        if (jsondate.length>0)
        {
            NSString *interval=[MBShoppingGuideInterface getJsonDateInterval:jsondate];
            NSDate *datetime=[Utils getDateTimeInterval_MS:interval];
            NSString *createdatestr=[Utils FormatShortDateTime:datetime lastDate:[Utils dateadd:[NSDate date] addType:DATE_DIFF_TYPE_DAY diff:-3]];
            _lbTime.text=createdatestr;
        }
        else
        {
            NSDate *datetime=[NSDate date];
            _lbTime.text=[Utils FormatDateTime:datetime FormatType:FORMAT_DATE_TYPE_DURATION_ALL];
        }
        
        NSString *imgurl=[Utils getSNSString:_data[@"topicInfo"][@"pictureUrl"]];
        NSString *defaultImg=DEFAULT_LOADING_BIGLOADING;
        [_imageTopic downloadImageUrl:[CommMBBusiness changeStringWithurlString:imgurl size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:defaultImg];
    }
}

@end
