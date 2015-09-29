//
//  MyAttentionOrFansCell.m
//  Wefafa
//
//  Created by fafatime on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//
// 废弃 不用  我的粉丝 我的关注 列表cell

#import "MyAttentionOrFansCell.h"
#import "Utils.h"
#import "CommMBBusiness.h"
#import "WeFaFaGet.h"
#import "Toast.h"
#import "AppDelegate.h"
#import "AppSetting.h"
#import "SQLiteOper.h"
#import "UIUrlImageView.h"
#import "MBShoppingGuideInterface.h"
#import "UIImageView+WebCache.h"
@implementation MyAttentionOrFansCell

- (void)awakeFromNib
{
    [_attenShowBtn setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateSelected];
    [_attenShowBtn setImage:[UIImage imageNamed:@"jiaguanzhu"] forState:UIControlStateNormal];
    [_showLineImgView setFrame:CGRectMake(_showLineImgView.frame.origin.x, _showLineImgView.frame.origin.y, _showLineImgView.frame.size.width, 0.5)];
    
    [_showLineImgView setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
    
     
}
-(void)setAttendDic:(NSDictionary *)attendParam
{
     _attendDic = attendParam;
    NSString *imgUrl ;
    NSString *gender;
    NSString *ced;
    NSString *concerned;
    if (_attendDic==nil)
    {
        
    }
    else
    {
//        NSString *useid=[NSString stringWithFormat:@"%@",_attendDic[@"useId"]];
     
//        if ([useid isEqualToString:sns.ldap_uid])
//        {
        NSMutableString *nickNameStr=[NSMutableString stringWithFormat:@"%@",_attendDic[@"nickName"]];
       //名称中有换行
        NSRange rangeT = [nickNameStr rangeOfString:@"\n"];
        
        if ([nickNameStr rangeOfString:@"\n"].location==NSNotFound) {
            _userName.text = [Utils getSNSString: _attendDic[@"nickName"]];
        }
        else
        {
            [nickNameStr replaceCharactersInRange:rangeT withString:@""];
            _userName.text =[Utils getSNSString:nickNameStr];
        }
//          _userName.text =[Utils getSNSString: _attendDic[@"nickName"]];
//        }
//        else
//        {
//            _userName.text =[Utils getSNSString: _attendDic[@"nickName"]];//userName
//        }
        
        if (_attendDic[@"concernedCount"]!=nil)
        {
              concerned=[NSString stringWithFormat:@"%@",_attendDic[@"concernedCount"]];
        }
        if (_attendDic[@"concernCount"]!=nil )
        {
              ced = [NSString stringWithFormat:@"%@",_attendDic[@"concernCount"]];
        }

        if (_attendDic[@"gender"]!=nil ) {
              gender = [NSString stringWithFormat:@"%@",_attendDic[@"gender"]];
        }
        if (_attendDic[@"headPortrait"]!=nil)
        {
            imgUrl = [NSString stringWithFormat:@"%@",_attendDic[@"headPortrait"]];
        }
        if (_attendDic[@"userLevel"]!=nil)
        {
//              _levelLabel.text=[NSString stringWithFormat:@"%@",_attendDic[@"userLevel"]];
            _levelLabel.text=@"v1";
            
        }
        if (_attendDic[@"isConcerned"]) {
            NSNumber *isConcerned = _attendDic[@"isConcerned"];
            self.attenShowBtn.selected = isConcerned.boolValue;
        }
    _collocationFansLb.text = [NSString stringWithFormat:@"关注%@    粉丝%@",ced,concerned];


    }
   
    NSString *baImg;
    if ([gender isEqualToString:@"0"])
    {
        [_userHeadImage setImage:[UIImage imageNamed:@"default_header_image@2x.png"]];
         baImg=@"default_header_image@2x.png";
    }
    else
    {
        [_userHeadImage setImage:[UIImage imageNamed:@"ico_userprofile_maleimage@3x.png"]];

        baImg=@"ico_userprofile_maleimage@3x.png";
        
    }
#ifdef DEBUG
  NSLog(@"————————attendIDC----%@.........%@,.,.,..,>>>>>>userid--%@",_attendDic[@"nickName"],_attendDic[@"headPortrait"], _attendDic[@"concernId"]);
    
#endif
    bool ismyAtt = [_attendDic[@"isConcerned"] boolValue];
//    ismyAtt = [self dugeExistMyAttendFriend];
//    ismyAtt =[Utils dugeExistMyAttendFriendWithUserId:_attendDic[@"concernId"]];
    if(ismyAtt)
    {
      [self CancelAttenState];
    }
    else
    {
      [self AttenState];
    }
  


    _userHeadImage.layer.masksToBounds=YES;
    _userHeadImage.layer.cornerRadius =_userHeadImage.frame.size.width/2;
//    _userHeadImage.layer.borderColor = [Utils HexColor:0xc7c7c7 Alpha:1.0].CGColor;
//    _userHeadImage.layer.borderWidth =1.0;
    
    //项目里面已经引用了sdwebimage
    if(_attendDic[@"headPortrait"]!=nil){
//        [self.userHeadImage setImageWithURL:[NSURL URLWithString:_attendDic[@"headPortrait"]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
        NSString *filepath = [NSString stringWithFormat:@"%@/%@", [AppSetting getSNSHeadImgFilePath],[Utils fileNameHash:_attendDic[@"headPortrait"]]];
        
        UIImage *img1=nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]==YES)
        {
            img1 = [[UIImage alloc] initWithContentsOfFile:filepath];
        }
        else
        {
            img1= [Utils getImageAsyn:_attendDic[@"headPortrait"] path:[AppSetting getSNSHeadImgFilePath] downloadLock:download_lock ImageCallback:^(UIImage * image,NSObject *recv_img_id){
                NSString *r_id=(NSString *)recv_img_id;
                if ([r_id isEqualToString:[Utils fileNameHash:_attendDic[@"headPortrait"]]])
                {
                    _userHeadImage.contentMode=UIViewContentModeScaleAspectFit;
                    _userHeadImage.image=image;
                    
                }
            } ErrorCallback:^{
            }];
        }
        if (img1!=nil) _userHeadImage.image=img1;
    }else{
//        self.userHeadImage.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
    }
    
    _userHeadImage.layer.masksToBounds=YES;
    _userHeadImage.layer.cornerRadius =_userHeadImage.frame.size.width/2;
//    _userHeadImage.layer.borderColor = [Utils HexColor:0xc7c7c7 Alpha:1.0].CGColor;
//    _userHeadImage.layer.borderColor = [UIColor whiteColor].CGColor;
//    _userHeadImage.layer.borderWidth =1.0;

}

-(void)setSnsStaff:(SNSStaff *)snsStaff
{
    _snsStaff = snsStaff;
    
    
    [CommMBBusiness getStaffInfoByStaffID:_snsStaff.login_account staffType:STAFF_TYPE_OPENID defaultProcess:^{
        _userName.text = @"--";
        _userHeadImage.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    }complete:^(SNSStaffFull *staff, BOOL success){
        if (success)
        {
            [self loadUserInfo:staff];
        }
    }];
   
    
}
//-(BOOL)dugeExistMyAttendFriend
//{
//    BOOL  isMyAttend = NO;
//    NSString *centerFilePath= [AppSetting getPersonalFilePath];
//    NSString *filePath=[centerFilePath stringByAppendingPathComponent:@"attendFriend"];
//    
//    NSArray *listAttend=[NSArray arrayWithContentsOfFile:filePath];
//    NSString *useId=[NSString stringWithFormat:@"%@",_attendDic[@"concernId"]];
//    if ([listAttend containsObject:useId])
//    {
//        isMyAttend = YES;
//    }
//    
//    return isMyAttend;
//}
-(void)loadUserInfo:(SNSStaffFull *)staff
{
    if (download_lock==nil)
        download_lock=[[NSCondition alloc] init];
    if ([CommMBBusiness isMyAttenDesigner:staff.login_account])
    {
               [self CancelAttenState];
               _attentionBtn.tag=1;
    }
    else
    {
             [self AttenState];
             _attentionBtn.tag=0;
    }
    
    _userName.text = _snsStaff.nick_name;
    _userHeadImage.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    
//    UIImage *img1=[Utils getSnsImageAsyn:_snsStaff.photo_path downloadLock:download_lock ImageCallback:^(UIImage *img, NSObject *recv_img_id)
//                   {
//                       NSString *r_id=(NSString *)recv_img_id;
//                       if ([r_id isEqualToString:_snsStaff.photo_path])
//                       {
//                           _userHeadImage.contentMode=UIViewContentModeScaleAspectFit;
//                           _userHeadImage.image=img;
//                       }
//                   } ErrorCallback:^{}];
    
    UIImage *img1= [Utils getImageAsyn:_snsStaff.photo_path path:[AppSetting getSNSHeadImgFilePath] downloadLock:download_lock ImageCallback:^(UIImage * image,NSObject *recv_img_id){
        NSString *r_id=(NSString *)recv_img_id;
        if ([r_id isEqualToString:[Utils fileNameHash:_snsStaff.photo_path]])
        {
            _userHeadImage.contentMode=UIViewContentModeScaleAspectFit;
            _userHeadImage.image=image;
            
        }
    } ErrorCallback:^{
    }];

    if (img1!=nil) _userHeadImage.image=img1;
    _userHeadImage.layer.masksToBounds=YES;
    _userHeadImage.layer.cornerRadius =_userHeadImage.frame.size.width/2;
    _userHeadImage.layer.borderColor =[UIColor whiteColor].CGColor;
    
//    [Utils HexColor:0xc7c7c7 Alpha:1.0].CGColor;
//
    _userHeadImage.layer.borderWidth =1.0;
}


- (IBAction)attentionBtnClick:(id)sender {
    
//    UIButton *btn=(UIButton*)sender;
//    btn.tag=!btn.tag;
//    NSLog(@"btn.tag====%d",btn.tag);
//    1-----展示取消关注。执行取消关注操作   0 --- 展示关注  执行 加关注操作
    NSDictionary *paramDic;
    if (self.cellType == cellAttention) {
        paramDic=@{@"UserId":sns.ldap_uid,
                   @"ConcernId":_attendDic[@"concernId"],
                   };
    }else if (self.cellType == cellFans){
        paramDic=@{@"UserId":sns.ldap_uid,
                   @"ConcernId":_attendDic[@"userId"],
                   };
    }
    NSString *file;
    if ([_attentionBtn.titleLabel.text isEqualToString:@"取消关注"])//btn.tag==1
    {
        file =@"UserConcernDelete";
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示"
                                                         message:@"确定要取消该关注" delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:@"取消", nil];
        [alertView show];
        
        return;
        
        
    }
    else
    {
        [Toast makeToastActivity:@"正在关注,请稍候..." hasMusk:YES];
        
        file =@"UserConcernCreate";
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableString *returnMessage=[[NSMutableString alloc]init];
        NSMutableDictionary *returnDic=[[NSMutableDictionary alloc]init];
                                        
        BOOL sucess =
        [SHOPPING_GUIDE_ITF requestPostUrlName:file param:paramDic responseAll:returnDic responseMsg:returnMessage];
        
        //刷新我的关注人员
        if (sucess)
        {
            NSString *centerFilePath= [AppSetting getPersonalFilePath];
            NSString *filePath=[centerFilePath stringByAppendingPathComponent:@"attendFriend"];
            
            NSMutableArray *listAttend=[NSMutableArray arrayWithContentsOfFile:filePath];
            NSString *useId=[NSString stringWithFormat:@"%@",_attendDic[@"concernId"]];
            
            if ([file isEqualToString:@"UserConcernDelete"])
            {
                [listAttend removeObject:useId];
            }
            else
            {
                [listAttend addObject:useId];
                
            }
            NSArray *writeArray = [NSArray arrayWithArray:listAttend];
            [writeArray writeToFile:filePath atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                
//                if (btn.tag==1)
//                {
//                    [self AttenState];
             
//
//                }
//                else
//                {
               [Toast hideToastActivity];
               [self CancelAttenState];
                   _attentionBtn.tag=1;
//                }

            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast hideToastActivity];
                if (returnMessage.length==0)
                {
                    if ([[returnDic allKeys]containsObject:@"message"])
                    {
                           [Utils alertMessage:returnDic[@"message"]];
                    }
                    else
                    {
                        [Utils alertMessage:@"失败"];
                    }
                }
                else
                {
                        [Utils alertMessage:returnMessage];
                }
            
//                btn.userInteractionEnabled=YES;
//                btn.tag=!btn.tag;
                
            });
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
        NSString *rst=[sns setAttenStaff:_snsStaff.login_account IsAtten:btn.tag returnMsg:msg];
        //刷新我的关注人员
        NSMutableArray *attenStaffs=[[NSMutableArray alloc] initWithCapacity:20];
        if ([rst isEqualToString:SNS_RETURN_SUCCESS])
        {
            NSString *ret=[sns getAttenStaffs:[AppSetting getFafaJid] Staffs:attenStaffs];
            if ([ret isEqualToString:SNS_RETURN_SUCCESS]==YES)
            {
                [sqlite saveAttenStaffs:[AppSetting getFafaJid] returnAttenList:attenStaffs];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([rst isEqualToString:SNS_RETURN_SUCCESS])
            {
//                [CommMBBusiness reloadMyAttenList];
            }
        });
    });
     */
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *file;
    NSDictionary *paramDic;
    
    if (buttonIndex==0)
    {
        [Toast hideToastActivity];
        [Toast makeToastActivity:@"正在取消,请稍候" hasMusk:YES];
        file =@"UserConcernDelete";
        if(self.cellType == cellAttention){
            paramDic=@{@"UserId":sns.ldap_uid,
                       @"ConcernIds":_attendDic[@"concernId"]};
        }else{
            paramDic=@{@"UserId":sns.ldap_uid,
                       @"ConcernIds":_attendDic[@"userId"]};
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableString *returnMessage=[[NSMutableString alloc]init];
            NSMutableDictionary *returnDic=[[NSMutableDictionary alloc]init];
            BOOL sucess =
            [SHOPPING_GUIDE_ITF requestPostUrlName:file param:paramDic responseAll:returnDic responseMsg:returnMessage];
            
            //刷新我的关注人员
            if (sucess)
            {
                NSString *centerFilePath= [AppSetting getPersonalFilePath];
                NSString *filePath=[centerFilePath stringByAppendingPathComponent:@"attendFriend"];
                
                NSMutableArray *listAttend=[NSMutableArray arrayWithContentsOfFile:filePath];
                NSString *useId=[NSString stringWithFormat:@"%@",_attendDic[@"concernId"]];
                
                [listAttend removeObject:useId];

                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshAttend" object:nil];
                
                NSArray *writeArray = [NSArray arrayWithArray:listAttend];
                [writeArray writeToFile:filePath atomically:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    [self AttenState];
                    _attentionBtn.tag=0;
                    
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    
                    [self CancelAttenState];
                    _attentionBtn.tag=1;
                    if (returnMessage.length==0)
                    {
                        if ([[returnDic allKeys]containsObject:@"message"])
                        {
                          [Utils alertMessage:returnDic[@"message"]];
                        }
                        else
                        {
                            [Utils alertMessage:@"失败"];
                        }
                    }
                    else
                    {
                        [Utils alertMessage:@"失败"];
                    }
                  
                    
                });
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
    }
    else
    {
        [Toast hideToastActivity];
//        [self CancelAttenState];
//        _attentionBtn.tag=1;
    }
}
-(void)AttenState
{
//    _attentionBtn.backgroundColor=[Utils HexColor:0xff4c3e Alpha:1.0];
    [_attentionBtn setBackgroundColor:[UIColor clearColor]];
    [_showAttenImg setImage:[UIImage imageNamed:@"ico_nav_addfriend.png"]];
    
    [_attentionBtn setTitle:@"加关注" forState:UIControlStateNormal];
    [_attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_attenShowBtn setSelected:NO];
//    [_attenShowBtn setTitle:@"加关注" forState:UIControlStateNormal];
    
    
}

-(void)CancelAttenState
{
    _attentionBtn.backgroundColor=[UIColor clearColor];
    
    [_showAttenImg setImage:[UIImage imageNamed:@"ico_home_follow_pressed.png"]];
    [_attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    [_attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_attenShowBtn setSelected:YES];
//        [_attenShowBtn setTitle:@"取消关注" forState:UIControlStateNormal];
}

@end
