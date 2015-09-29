//
//  CommentTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "Utils.h"
#import "CommMBBusiness.h"
#import "SQLiteOper.h"
#import "MBShoppingGuideInterface.h"
#import "AppDelegate.h"
#import "AppSetting.h"

static const int CommentTableViewCellHeight=62;
static const int Margin=12;
static const int ImageWidth=40;
static const NSString * COMMENT_DEFAULT=@"";
static const int _lb_height=12;

static const int FontSize=12;

@implementation CommentTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self innerInit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)innerInit
{
    self.backgroundColor=COLLOCATION_TABLE_BG;
    self.frame=CGRectMake(0, 0, self.frame.size.width, CommentTableViewCellHeight);
    
    if (imageView==nil)
    {
        int x=(CommentTableViewCellHeight-ImageWidth)/2;
        imageView=[[UIUrlImageView alloc] initWithFrame:CGRectMake(Margin, x, ImageWidth, ImageWidth)];
        imageView.layer.masksToBounds=YES;
        imageView.layer.cornerRadius =imageView.frame.size.width/2;
        imageView.layer.borderColor = (COLLOCATION_TABLE_LINE).CGColor;
        imageView.layer.borderWidth =1.0;
        imageView.userInteractionEnabled=YES;
        [self.contentView addSubview: imageView];
        UITapGestureRecognizer *imgTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImgHeader:)];
        [imageView addGestureRecognizer:imgTap];
        

        
        int _lb_time_width=100;
        int _lb_comment_y=34;
        int _lbname_x=imageView.frame.origin.x+imageView.frame.size.width+Margin;
        int _lb_y=13;
        _lbUserName=[[UILabel alloc] initWithFrame:CGRectMake(_lbname_x, _lb_y, SCREEN_WIDTH-_lbname_x-_lb_time_width-Margin, _lb_height)];
        _lbUserName.font=[UIFont systemFontOfSize:12];
        _lbUserName.textColor=[Utils HexColor:0xf46c56 Alpha:1.0];
        [self.contentView addSubview:_lbUserName];
        
        int _lbtime_x=_lbname_x+_lbUserName.frame.size.width;
        _lbDate=[[UILabel alloc] initWithFrame:CGRectMake(_lbtime_x, _lb_y, _lb_time_width, _lb_height)];
        _lbDate.font=[UIFont systemFontOfSize:12];
        _lbDate.textColor=[Utils HexColor:0xacacac Alpha:1.0];
        [_lbDate setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lbDate];
        
        _lbComment=[[UILabel alloc] initWithFrame:CGRectMake(_lbUserName.frame.origin.x, _lb_comment_y,SCREEN_WIDTH-3*Margin-ImageWidth, _lb_height)];
        _lbComment.font=[UIFont systemFontOfSize:FontSize];
        _lbComment.numberOfLines=0;
//        _lbComment.lineBreakMode = UILineBreakModeWordWrap;
        _lbComment.textColor=[Utils HexColor:0x6b6b6b Alpha:1.0];
        [self.contentView addSubview:_lbComment];
        
        _btnLevel=[UIButton buttonWithType:UIButtonTypeCustom];
        _btnLevel.frame=CGRectMake(_lbUserName.frame.origin.x, _lbUserName.frame.origin.y, 14, 14);
        _btnLevel.layer.masksToBounds=YES;
        _btnLevel.layer.cornerRadius =_btnLevel.frame.size.width/2;
        _btnLevel.titleLabel.font = [UIFont systemFontOfSize:8];
        _btnLevel.titleLabel.textAlignment = NSTextAlignmentCenter;
        _btnLevel.titleEdgeInsets = UIEdgeInsetsMake(0,2, 0, 0);
        [_btnLevel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnLevel setBackgroundColor:[Utils HexColor:0xf98a3e Alpha:1.0]];
//        [self.contentView addSubview:_btnLevel];
        
        imageSeparator=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
        imageSeparator.backgroundColor=COLLOCATION_TABLE_LINE;
        [self.contentView addSubview:imageSeparator];
    }
}

-(void)setData:(NSDictionary *)data1
{
    _data=data1;
    
    NSString *comment=[Utils getSNSString:_data[@"content"]];
    if (comment.length==0) comment=[NSString stringWithFormat:@"%@",COMMENT_DEFAULT];
    
    CGSize size=[comment sizeWithFont:_lbComment.font constrainedToSize:CGSizeMake(SCREEN_WIDTH-3*Margin-ImageWidth, MAXFLOAT)];
    int height=size.height>_lb_height?size.height:_lb_height;
    
    _lbComment.frame=CGRectMake(_lbComment.frame.origin.x,_lbComment.frame.origin.y,SCREEN_WIDTH-3*Margin-ImageWidth,height+1);
    self.frame=CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,height+(CommentTableViewCellHeight-_lb_height));
    //过滤乱码？
    comment = [comment stringByReplacingOccurrencesOfString:@"?" withString:@""];
    _lbComment.text=comment;


    NSString *username=[Utils getSNSString:_data[@"creatE_USER"]];
    _lbUserName.text=username;
    
    NSString *jsondate=[Utils getSNSString:_data[@"creatE_DATE"]];
    if (jsondate.length>0)
    {
        NSString *interval=[MBShoppingGuideInterface getJsonDateInterval:jsondate];
        if ([interval isEqualToString:@""] ||interval.length==0||interval==nil) {
            _lbDate.text=jsondate;
        }else{
            NSDate *datetime=[Utils getDateTimeInterval_MS:interval];
            NSString *createdatestr=[Utils dateToString:datetime Format:@"yyyy-MM-dd HH:mm"];
            _lbDate.text=createdatestr;
        }
    }
    else
    {
        NSDate *datetime=[NSDate date];
        NSString *createdatestr=[Utils dateToString:datetime Format:@"yyyy-MM-dd HH:mm"];
        _lbDate.text=createdatestr;
    }
    
    imageSeparator.frame=CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
    
    imageView.image=[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
    [imageView downloadImageUrl:_data[@"headPortrait"] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:DEFAULT_LOADING_HEADIMGVIEW];
    /*
    [CommMBBusiness getStaffInfoByStaffID:_data[@"userId"] staffType:STAFF_TYPE_OPENID defaultProcess:^{
        imageView.image=[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
    }complete:^(SNSStaffFull *staff, BOOL success){
        if (success)
        {
            [self loadUserInfo:staff];
        }
    }];
     */
    
    [_btnLevel setTitle:@"V1" forState:UIControlStateNormal];
    [self setImageLevelFrame];
}
-(void)clickImgHeader:(UITapGestureRecognizer *)tapImgView
{

}
-(void)setImageLevelFrame
{
    CGSize size=[_lbUserName.text sizeWithFont:_lbUserName.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    _btnLevel.frame=CGRectMake(size.width>0?_lbUserName.frame.origin.x+size.width+3:_lbUserName.frame.origin.x, _lbUserName.frame.origin.y, _btnLevel.frame.size.width, _btnLevel.frame.size.height);
}

-(void)loadUserInfo:(SNSStaffFull *)staff
{
    if (download_lock==nil)
        download_lock=[[NSCondition alloc] init];
    staffFull=staff;
    imageView.image=[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
//    UIImage *img1=[Utils getSnsImageAsyn:staffFull.photo_path downloadLock:download_lock ImageCallback:^(UIImage *img, NSObject *recv_img_id)
//                   {
//                       NSString *r_id=(NSString *)recv_img_id;
//                       if ([r_id isEqualToString:staffFull.photo_path])
//                       {
//                           imageView.contentMode=UIViewContentModeScaleAspectFit;
//                           imageView.image=img;
//                       }
//                   } ErrorCallback:^{}];
    UIImage *img1= [Utils getImageAsyn:staffFull.photo_path path:[AppSetting getSNSHeadImgFilePath] downloadLock:download_lock ImageCallback:^(UIImage * image,NSObject *recv_img_id){
        NSString *r_id=(NSString *)recv_img_id;
        if ([r_id isEqualToString:[Utils fileNameHash:staffFull.photo_path]])
        {
//            imageView.contentMode=UIViewContentModeScaleAspectFit;
            imageView.image=image;
        }
    } ErrorCallback:^{
    }];
    if (img1!=nil) imageView.image=img1;
}

+(int)getCellHeight:(id)data1
{
    NSDictionary *data=(NSDictionary *)data1;
    NSString *commentStr=[NSString stringWithFormat:@"%@",COMMENT_DEFAULT];
    if (data[@"content"]!=nil && ((NSString *)data[@"content"]).length>0) commentStr=[Utils getSNSString:data[@"content"]];
    if (commentStr.length==0)
        return CommentTableViewCellHeight;
    
    CGSize size=[commentStr sizeWithFont:[UIFont systemFontOfSize:FontSize] constrainedToSize:CGSizeMake(SCREEN_WIDTH-3*Margin-ImageWidth, MAXFLOAT)];
    int height=size.height>_lb_height?size.height:_lb_height;
    return height+(CommentTableViewCellHeight-_lb_height);
}


@end
