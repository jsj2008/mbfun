//
//  SMineTableViewCell.m
//  Wefafa
//
//  Created by wave on 15/5/22.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SMineTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"
#import "MBShoppingGuideInterface.h"
#import "MBOtherUserInfoModel.h"
#import "SUtilityTool.h"
@implementation SMineTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.headImg.layer.cornerRadius = self.headImg.width/2;
    self.headImg.layer.masksToBounds = YES;
    self.nameLabel.textColor = COLOR_C2;
    self.detailLabel.textColor = COLOR_C7;
    self.userInteractionEnabled=YES;
    _vipImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.headImg.frame.origin.y+self.headImg.frame.size.width - 3,self.headImg.frame.origin.y + self.headImg.frame.size.height - 13, 12, 12)];
    [_vipImgView setImage:[UIImage imageNamed:@"Unico/v"]];
    _vipImgView.layer.cornerRadius=_vipImgView.frame.size.width/ 2;
    _vipImgView.layer.borderWidth = 1.0;
    _vipImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _vipImgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_vipImgView];
    
}

- (void)setdic:(NSDictionary *)dic {
    _dic = dic;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:dic[@"headPortrait"]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    NSString *nameStr, *detailStr;
    nameStr = dic[@"nickName"];
    detailStr = dic[@"concernTime"];
    self.nameLabel.text = nameStr;
    self.detailLabel.text =  detailStr;
    
    _AccessoryBtn.selected = ![dic[@"isConcerned"] isEqual:@"1"];
    if ([[dic allKeys] containsObject:@"user_vip_type"]) {
        NSString *head_v_type=[NSString stringWithFormat:@"%@",dic[@"user_vip_type"]];
        
        switch ([head_v_type integerValue]) {
            case 0:
            {
                _vipImgView.hidden=YES;
            }
                break;
            case 1:
            {
                _vipImgView.hidden=NO;
                [_vipImgView setImage:[UIImage imageNamed:@"brandvip@2x"]];
            }
                break;
            case 2:
            {
                [_vipImgView setImage:[UIImage imageNamed:@"peoplevip@2x"]];
                _vipImgView.hidden=NO;
            }
                break;
            default:
                break;
        }
    }


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

- (void)setContentModel:(MBOtherUserInfoModel *)contentModel{
    _contentModel = contentModel;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:contentModel.headPortrait] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    
//    NSString *detailStr=[Utils g  etdate:contentModel.concernTime];
//    detailStr = [SUTILITY_TOOL_INSTANCE getTimeByTodayWithString:detailStr];
    
    if(contentModel.concernTime){
        NSString *detailStr = contentModel.concernTime;
        detailStr = [SUTILITY_TOOL_INSTANCE getTimeByTodayWithString:detailStr];
        self.detailLabel.text = detailStr;
        [self.timeImageView setHidden:NO];
    }else{
        self.detailLabel.text = @"";
        [self.timeImageView setHidden:YES];
    }
    
    self.nameLabel.text = contentModel.nickName;
    
    NSString *head_v_type=[NSString stringWithFormat:@"%@",_contentModel.head_v_type];
    
    switch ([head_v_type integerValue]) {
        case 0:
        {
            _vipImgView.hidden=YES;
        }
            break;
        case 1:
        {
            _vipImgView.hidden=NO;
            [_vipImgView setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
        case 2:
        {
            [_vipImgView setImage:[UIImage imageNamed:@"peoplevip@2x"]];
            _vipImgView.hidden=NO;
        }
            break;
        default:
            break;
    }
//    if([contentModel.isConcerned integerValue]==2){
//        [self.AccessoryBtn setImage:[UIImage imageNamed:@"Unico/icon_focus_no.png"] forState:UIControlStateNormal];
//         [self.AccessoryBtn setImage:[UIImage imageNamed:@"Unico/icon_focus_no.png"] forState:UIControlStateSelected];
//    }

    if ([contentModel.concernId isEqualToString:sns.ldap_uid]&&[contentModel.nickName isEqualToString:sns.myStaffCard.nick_name])
    {
        self.AccessoryBtn.hidden=YES;
    }
    else
    {
        self.AccessoryBtn.hidden=NO;
        self.AccessoryBtn.enabled = YES;
    }

    if (self.AccessoryBtn.hidden==NO) {
        
        if ([contentModel.userId isEqualToString:sns.ldap_uid]&&[contentModel.nickName isEqualToString:sns.myStaffCard.nick_name])
        {
            self.AccessoryBtn.hidden=YES;
        }
        else
        {
            self.AccessoryBtn.hidden=NO;
            self.AccessoryBtn.enabled = YES;
        }
        
    }

    
    self.AccessoryBtn.userInteractionEnabled = YES;
//    switch ([contentModel.isConcerned integerValue]) {
//        case 0:
//        case 1:
//            self.AccessoryBtn.selected=NO;
//            break;
//        case 2:
//        case 3:
//            self.AccessoryBtn.selected=YES;
//            break;
//        default:
//            break;
//    }
    self.AccessoryBtn.selected = contentModel.isConcerned.boolValue;
}

- (IBAction)accessoryBtnClicked:(id)sender {
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(mineTableViewCell:attentionButtonAction:)]) {
        [self.delegate mineTableViewCell:self attentionButtonAction:sender];
    }
    if ([self.delegate respondsToSelector:@selector(mineTableConetntModel:attentionButtonAction:)]) {
        [self.delegate mineTableConetntModel:_contentModel attentionButtonAction:sender];
    }
}

- (void)CancelAttenState {
    
}

@end
