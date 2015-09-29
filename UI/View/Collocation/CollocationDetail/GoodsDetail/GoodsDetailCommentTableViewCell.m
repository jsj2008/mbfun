//
//  GoodsDetailCommentTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-9-4.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "GoodsDetailCommentTableViewCell.h"
#import "Utils.h"
#import "CommMBBusiness.h"
#import "SQLiteOper.h"
#import "MBShoppingGuideInterface.h"
#import "AppSetting.h"

static const int GoodsDetailCommentTableViewCellHeight=46;
static const int FontSize=10;
static const int Margin=8;
static const int ImageWidth=28;
static const int _lb_height=14;

static const NSString * COMMENT_DEFAULT=@"";

@implementation GoodsDetailCommentTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary *)data1
{
    _data=data1;
    
    NSString *comment=[Utils getSNSString:_data[@"content"]];
    if (comment.length==0) comment=[NSString stringWithFormat:@"%@",COMMENT_DEFAULT];
//    CGSize size=[comment sizeWithFont:_lbComment.font constrainedToSize:CGSizeMake(SCREEN_WIDTH-4*Margin, MAXFLOAT)];
//    _lbComment.frame=CGRectMake(2*Margin,_lbComment.frame.origin.y,SCREEN_WIDTH-4*Margin,size.height);
//    self.frame=CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,size.height+(GoodsDetailCommentTableViewCellHeight-FontSize));
    
    CGSize size=[comment sizeWithFont:_lbComment.font constrainedToSize:CGSizeMake(SCREEN_WIDTH-3*Margin-ImageWidth, MAXFLOAT)];
    int height=size.height>_lb_height?size.height:_lb_height;
    
    _lbComment.frame=CGRectMake(_lbComment.frame.origin.x,_lbComment.frame.origin.y,SCREEN_WIDTH-3*Margin-ImageWidth,height);
    self.frame=CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,height+(GoodsDetailCommentTableViewCellHeight-_lb_height));
    _lbComment.numberOfLines=0;
    _lbComment.text=comment;

    NSString *username=[Utils getSNSString:_data[@"creatE_USER"]];
    _lbUserName.text=username;
    
    NSString *jsondate=[Utils getSNSString:_data[@"creatE_DATE"]];
    if (jsondate.length>0)
    {
        NSString *interval=[MBShoppingGuideInterface getJsonDateInterval:jsondate];
        NSDate *datetime=[Utils getDateTimeInterval_MS:interval];
        NSString *createdatestr=[Utils dateToString:datetime Format:@"yyyy-MM-dd HH:mm"];
        _lbDate.text=createdatestr;
    }
    else
    {
        NSDate *datetime=[NSDate date];
        NSString *createdatestr=[Utils dateToString:datetime Format:@"yyyy-MM-dd HH:mm"];
        _lbDate.text=createdatestr;
    }
    
    [CommMBBusiness getStaffInfoByStaffID:_data[@"userId"] staffType:STAFF_TYPE_OPENID defaultProcess:^{
//        _imageHead.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    }complete:^(SNSStaffFull *staff, BOOL success){
        if (success)
        {
            [self loadUserInfo:staff];
        }
    }];
}

-(void)loadUserInfo:(SNSStaffFull *)staff
{
    if (download_lock==nil)
        download_lock=[[NSCondition alloc] init];
    staffFull=staff;
    _imageHead.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
//    UIImage *img1=[Utils getSnsImageAsyn:staffFull.photo_path downloadLock:download_lock ImageCallback:^(UIImage *img, NSObject *recv_img_id)
//                   {
//                       NSString *r_id=(NSString *)recv_img_id;
//                       if ([r_id isEqualToString:staffFull.photo_path])
//                       {
//                           _imageHead.contentMode=UIViewContentModeScaleAspectFit;
//                           _imageHead.image=img;
//                       }
//                   } ErrorCallback:^{}];
    UIImage *img1= [Utils getImageAsyn:staffFull.photo_path path:[AppSetting getSNSHeadImgFilePath] downloadLock:download_lock ImageCallback:^(UIImage * image,NSObject *recv_img_id){
        NSString *r_id=(NSString *)recv_img_id;
        if ([r_id isEqualToString:[Utils fileNameHash:staff.photo_path]])
        {
            _imageHead.image=image;
        }
    } ErrorCallback:^{
    }];
    if (img1!=nil) _imageHead.image=img1;
}


-(NSDictionary*)data
{
    return _data;
}

+(int)getCellHeight:(id)data1
{
    NSString *data=(NSString *)data1;
    if (data.length==0) data=[NSString stringWithFormat:@"%@",COMMENT_DEFAULT];
    if (data.length==0)
        return GoodsDetailCommentTableViewCellHeight;

    CGSize size=[data sizeWithFont:[UIFont systemFontOfSize:FontSize] constrainedToSize:CGSizeMake(SCREEN_WIDTH-3*Margin-ImageWidth, MAXFLOAT)];
    int height=size.height>_lb_height?size.height:_lb_height;
    return height+(GoodsDetailCommentTableViewCellHeight-_lb_height);
}

@end
