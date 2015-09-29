//
//  SMyTopicHeaderCollectionReusableView.m
//  Wefafa
//
//  Created by wave on 15/7/22.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMyTopicHeaderCollectionReusableView.h"
#import "WeFaFaGet.h"
#import "SMyTopicHeadModel.h"
#import "SUtilityTool.h"
#import "MBSettingMainViewController.h"

@implementation SMyTopicHeaderCollectionReusableView

- (void)setTarger:(UIViewController *)targer {
    _targer = targer;
}

- (void)awakeFromNib {
    // Initialization code
    _headImg.layer.cornerRadius = _headImg.width/2;
    _headImg.layer.masksToBounds = YES;
    _headImg.layer.borderWidth = 3.0;
    _headImg.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImg.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    _headImg.userInteractionEnabled = YES;
    [_headImg addGestureRecognizer:tap];
    
    _descriptionLabel.font = FONT_t6;
    _descriptionLabel.textColor = COLOR_C2;
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setModel:(SMyTopicHeadModel *)model {
    if (model == nil) {
        return;
    }
    if (!IS_STRING(model.userinfo.head_img)) {
        [_headImg sd_setImageWithURL:[NSURL URLWithString:DEFAULT_HEADIMG]];
    }else {
        [_headImg sd_setImageWithURL:[NSURL URLWithString:sns.myStaffCard.photo_path_big]];
    }
    [_nameLabel setText:sns.myStaffCard.nick_name];
    if (!IS_STRING(model.userinfo.back_img)) {
        [_backImg setImage:[UIImage imageNamed:@"Unico/smin_backimg.png"]];
    }else {
        [_backImg sd_setImageWithURL:[NSURL URLWithString:model.userinfo.back_img]];
    }
    _descriptionLabel.text = [NSString stringWithFormat:@"获赞 %d  |  回复 %d", [model.likeCount intValue], [model.commentCount intValue]];
}

- (void)click {
    MBSettingMainViewController *vc = [MBSettingMainViewController new];
    [_targer.navigationController pushViewController:vc animated:YES];
}

@end
