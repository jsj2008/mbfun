//
//  DesignerTopTenTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-9-26.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "DesignerTopTenTableViewCell.h"
#import "Utils.h"
#import "AppSetting.h"
#import "WeFaFaGet.h"
#import "CommMBBusiness.h"

@implementation DesignerTopTenTableViewCell

- (void)awakeFromNib
{
    [self innerInit];
}

-(void)innerInit
{
    _imageHead.layer.borderColor = (COLLOCATION_TABLE_LINE).CGColor;
    _imageHead.layer.borderWidth =1.0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary *)data1
{
    _data=data1;
    if (_data[@"headPortrait"]!=nil)
    {
        [self loadUserInfo:_data[@"headPortrait"]];
    }
    else
    {
    }
//    [CommMBBusiness getStaffInfoByStaffID:_data[@"userId"] staffType:STAFF_TYPE_OPENID defaultProcess:^{
//        _imageHead.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
//    }complete:^(SNSStaffFull *staff, BOOL success){
//        if (success)
//        {
//            [self loadUserInfo:staff.photo_path];
//        }
//    }];
}

-(void)loadUserInfo:(NSString *)photo
{
    if (download_lock==nil)
        download_lock=[[NSCondition alloc] init];
    
    //    [self setImageLikeFrame];
    [Utils getImageAsyn:photo path:[AppSetting getSNSHeadImgFilePath] downloadLock:download_lock ImageCallback:^(UIImage * image,NSObject *recv_img_id){
        NSString *r_id=(NSString *)recv_img_id;
        if ([r_id isEqualToString:[Utils fileNameHash:photo]])
        {
            _imageHead.contentMode=UIViewContentModeScaleAspectFit;
            _imageHead.image=image;
        }
    } ErrorCallback:^{}];
    
//    if ([photo hasPrefix:@"http://"]||[photo hasPrefix:@"https://"]) {
//        UIImage *img1=[Utils getImageUrl:photo fileID: path:(NSString*)path downloadLock:(NSCondition*)downloadLock ImageCallback:(void (^)(UIImage * image,NSObject *recv_img_id))imageBlock ErrorCallback:(void (^)(void))errorBlock
//                       }
//                       else
//                       {
//                           UIImage *img1=[Utils getSnsImageAsyn:photo downloadLock:download_lock ImageCallback:^(UIImage *img, NSObject *recv_img_id)
//                                          {
//                                              NSString *r_id=(NSString *)recv_img_id;
//                                              if ([r_id isEqualToString:photo])
//                                              {
//                                                  _imageHead.contentMode=UIViewContentModeScaleAspectFit;
//                                                  _imageHead.image=img;
//                                              }
//                                          } ErrorCallback:^{}];
//                           if (img1!=nil) _imageHead.image=img1;
//
//                       }
}

@end
