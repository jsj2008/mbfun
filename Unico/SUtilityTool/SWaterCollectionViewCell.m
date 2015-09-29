//
//  SWaterCollectionViewCell.m
//  Wefafa
//
//  Created by unico_0 on 6/16/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SWaterCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SMineViewController.h"
#import "AppDelegate.h"
#import "SDataCache.h"
#import "MBSettingMainViewController.h"
#import "WeFaFaGet.h"
#import "LNGood.h"
#import "SMDataModel.h"

@interface SWaterCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;
@property (weak, nonatomic) IBOutlet UILabel *discrptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) UIImageView *head_V_View;
@property (weak, nonatomic) IBOutlet UIImageView *head_v_view;
- (IBAction)userHeaderAction:(UIButton *)sender;

@end

@implementation SWaterCollectionViewCell

- (void)awakeFromNib {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0;
    
    self.userHeaderImageView.layer.cornerRadius = 10;
    self.userHeaderImageView.layer.masksToBounds = YES;
    _head_v_view.layer.masksToBounds = YES;
    _head_v_view.layer.cornerRadius= _head_v_view.frame.size.height/2;
    _head_v_view.layer.borderWidth = 1.0;
    _head_v_view.layer.borderColor = [UIColor whiteColor].CGColor;
    [_head_v_view setImage:[UIImage imageNamed:@"peoplevip@2x"]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.maskImageView.frame = _contentImageView.frame;
}

- (void)setModel:(SMDataModel *)model {
    _model = model;
    _discrptionLabel.text = model.content_info;
    [_likeButton setTitle:model.like_count forState:UIControlStateNormal];
    _likeButton.selected = [model.is_love boolValue];
    //HEADv headView 哈哈哈
    NSString *head_v_type=[NSString stringWithFormat:@"%@",_contentGoodsModel.head_v_type];
    
    switch ([head_v_type integerValue]) {
        case 0:
        {
            _head_v_view.hidden=YES;
        }
            break;
        case 1:
        {
            _head_v_view.hidden=NO;
            [_head_v_view setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
        case 2:
        {
            [_head_v_view setImage:[UIImage imageNamed:@"peoplevip@2x"]];
            _head_v_view.hidden=NO;
        }
            break;
        default:
            break;
    }
    [_userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    [_contentImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    if (model.stick_img_url.length > 0) {
        _maskImageView.hidden = NO;
        [_maskImageView sd_setImageWithURL:[NSURL URLWithString:model.stick_img_url]];
    }else{
        _maskImageView.hidden = YES;
    }

}

- (void)setContentGoodsModel:(LNGood *)contentGoodsModel{
    _contentGoodsModel = contentGoodsModel;
    _discrptionLabel.text = contentGoodsModel.content_info;
    [_likeButton setTitle:contentGoodsModel.like_count forState:UIControlStateNormal];
    _likeButton.selected = [contentGoodsModel.is_love boolValue];
   //HEADv headView 哈哈哈
    NSString *head_v_type=[NSString stringWithFormat:@"%@",_contentGoodsModel.head_v_type];
    
    switch ([head_v_type integerValue]) {
        case 0:
        {
            _head_v_view.hidden=YES;
        }
            break;
        case 1:
        {
            _head_v_view.hidden=NO;
            [_head_v_view setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
        case 2:
        {
            [_head_v_view setImage:[UIImage imageNamed:@"peoplevip@2x"]];
            _head_v_view.hidden=NO;
        }
            break;
        default:
            break;
    }
     [_userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:contentGoodsModel.head_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    [_contentImageView sd_setImageWithURL:[NSURL URLWithString:contentGoodsModel.img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    if (contentGoodsModel.stick_img_url.length > 0) {
        _maskImageView.hidden = NO;
        [_maskImageView sd_setImageWithURL:[NSURL URLWithString:contentGoodsModel.stick_img_url]];
    }else{
        _maskImageView.hidden = YES;
    }
}

- (IBAction)userHeaderAction:(UIButton *)sender {
   if(_contentGoodsModel)
   {
       if ([_contentGoodsModel.user_id isEqualToString:sns.ldap_uid]) {
           MBSettingMainViewController *controller = [MBSettingMainViewController new];
           [[AppDelegate rootViewController] pushViewController:controller animated:YES];
       }else{
           SMineViewController *vc = [[SMineViewController alloc]init];
           vc.person_id = _contentGoodsModel.user_id;
           [[AppDelegate rootViewController] pushViewController:vc animated:YES];
       }
   }
    else
    {
        if ([_model.user_id isEqualToString:sns.ldap_uid]) {
            MBSettingMainViewController *controller = [MBSettingMainViewController new];
            [[AppDelegate rootViewController] pushViewController:controller animated:YES];
        }else{
            SMineViewController *vc = [[SMineViewController alloc]init];
            vc.person_id = _model.user_id;
            [[AppDelegate rootViewController] pushViewController:vc animated:YES];
        }
    }

}

- (IBAction)likeButtonAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    if (_contentGoodsModel) {

        [[SDataCache sharedInstance]likeCollocation:_contentGoodsModel.product_ID complete:^(NSArray *data) {
           
            _contentGoodsModel.like_count = [NSString stringWithFormat:@"%d", [_contentGoodsModel.like_count intValue] + 1];
            [_likeButton setTitle:_contentGoodsModel.like_count forState:UIControlStateNormal];
            _contentGoodsModel.is_love = @"1";
            sender.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.2 animations:^{
                sender.imageView.transform = CGAffineTransformMakeScale(0, 1);
            }completion:^(BOOL finished) {
                sender.selected = YES;
                [UIView animateWithDuration:0.2 animations:^{
                    sender.imageView.transform = CGAffineTransformIdentity;
                }completion:^(BOOL finished) {
                    sender.userInteractionEnabled = YES;
                }];
            }];
        }];
    }
    else
    {

        [[SDataCache sharedInstance]likeCollocation:[NSString stringWithFormat:@"%@",_model.idValue] complete:^(NSArray *data) {
            
            _model.like_count = [NSString stringWithFormat:@"%d", [_model.like_count intValue] + 1];
            [_likeButton setTitle:_model.like_count forState:UIControlStateNormal];
            _model.is_love = @1;
            sender.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.2 animations:^{
                sender.imageView.transform = CGAffineTransformMakeScale(0, 1);
            }completion:^(BOOL finished) {
                sender.selected = YES;
                [UIView animateWithDuration:0.2 animations:^{
                    sender.imageView.transform = CGAffineTransformIdentity;
                }completion:^(BOOL finished) {
                    sender.userInteractionEnabled = YES;
                }];
            }];
        }];
        
    }

}

@end
