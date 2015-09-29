//
//  DesignerTopTenListViewCell.m
//  Wefafa
//
//  Created by mac on 14-12-7.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//
//废弃 不用 以前的 热门前十cell
#import "DesignerTopTenListViewCell.h"
#import "Utils.h"
#import "CommMBBusiness.h"
#import "AppSetting.h"
#import "MBShoppingGuideInterface.h"
#import "Toast.h"

@implementation DesignerTopTenListViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setData:(NSDictionary*)data
{
    _data=data;
    switch (_row) {
        case 0:
            _imgTop.image=[UIImage imageNamed:@"btn_first_iPhone@3x.png"];
            _lbTop.text=@"";
            break;
        case 1:
            _imgTop.image=[UIImage imageNamed:@"btn_second_iPhone@3x.png"];
            _lbTop.text=@"";
            break;
        case 2:
            _imgTop.image=[UIImage imageNamed:@"btn_third_iPhone@3x.png"];
            _lbTop.text=@"";
            break;
            
        default:
            _imgTop.image=[UIImage imageNamed:@"btn_more_iPhone@3x.png"];
            _lbTop.text=[[NSString alloc] initWithFormat:@"%d",_row+1];
            break;
    }
    
    _imgHead.layer.masksToBounds=YES;
    _imgHead.layer.cornerRadius=_imgHead.frame.size.width/2;
    _imgHead.layer.borderColor = (COLLOCATION_TABLE_LINE).CGColor;
    _imgHead.layer.borderWidth =1.0;
    
    _btnAtten.layer.borderColor = (COLLOCATION_TABLE_LINE).CGColor;
    _btnAtten.layer.borderWidth =1.0;
    
//    NSString *nickname=[Utils getSNSString:data[@"nickName"]];
//    _lbName.text=nickname.length>0?nickname:[Utils getSNSString:data[@"userName"]];
    _lbName.text=[Utils getSNSString:data[@"userName"]];
    _lbCollNum.text=@"搭配";
    _lbFansNum.text=@"粉丝";
    
    [self showAtten:data[@"userId"]];
    if (data[@"headPortrait"]!=nil)
    {
        _imgHead.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
        [self loadUserInfo:data[@"headPortrait"]];
    }
    
//    [CommMBBusiness getStaffInfoByStaffID:data[@"userId"] staffType:STAFF_TYPE_OPENID defaultProcess:^{
//        _imgHead.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
//    }complete:^(SNSStaffFull *staff, BOOL success){
//        if (success)
//        {
//            _lbName.text=[[NSString alloc] initWithFormat:@"%@",staff.nick_name];
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
            _imgHead.contentMode=UIViewContentModeScaleAspectFit;
            _imgHead.image=image;
        }
    } ErrorCallback:^{}];
}

-(void)showAtten:(NSString *)userid
{
    //是否关注
    BOOL isatten = [Utils dugeExistMyAttendFriendWithUserId:userid];
    
    if(isatten)
    {
        [_btnAtten setTitle:@"     已关注" forState:UIControlStateNormal];
        [_imgAtten setImage:[UIImage imageNamed:@"ico_meadded_iPhone@3x.png"]];
        _btnAtten.enabled=NO;
    }
    else
    {
        [_btnAtten setTitle:@"     关注" forState:UIControlStateNormal];
        [_imgAtten setImage:[UIImage imageNamed:@"ico_meadd_iPhone@3x.png"]];
        _btnAtten.enabled=YES;
    }
}

- (IBAction)btnAttenClick:(id)sender
{
//    [Toast makeToastActivity:@"正在获取动态..." hasMusk:YES];
    NSString *userId=[NSString stringWithFormat:@"%@",_data[@"userId"]];
    
    if ([sns.ldap_uid isEqualToString:userId]) {
        [Toast hideToastActivity];
        [Utils alertMessage:@"自己不能关注自己"];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableString *returnMessage=[[NSMutableString alloc]init];
            NSDictionary *paramDic=@{@"UserId":sns.ldap_uid,
                                     @"ConcernId":_data[@"userId"],
                                     @"ConcernType":@"造型师"
                                     };
            BOOL sucess = [SHOPPING_GUIDE_ITF requestPostUrlName:@"UserConcernCreate" param:paramDic responseAll:nil responseMsg:returnMessage];
            
            //刷新我的关注人员
            if (sucess)
            {
                NSString *centerFilePath= [AppSetting getPersonalFilePath];
                NSString *filePath=[centerFilePath stringByAppendingPathComponent:@"attendFriend"];
                
                NSMutableArray *listAttend=[NSMutableArray arrayWithContentsOfFile:filePath];
                
                NSString *useId=[NSString stringWithFormat:@"%@",_data[@"userId"]];
                
                [listAttend addObject:useId];
                
                NSArray *writeArray = [NSArray arrayWithArray:listAttend];
                [writeArray writeToFile:filePath atomically:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    [_btnAtten setTitle:@"     已关注" forState:UIControlStateNormal];
                    [_imgAtten setImage:[UIImage imageNamed:@"ico_meadded_iPhone@3x.png"]];
                    _btnAtten.enabled=NO;
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
//                    [Utils alertMessage:@"关注失败!"];
                    [Utils alertMessage:returnMessage];
                    
                });
            }
        });
    }
}

@end
