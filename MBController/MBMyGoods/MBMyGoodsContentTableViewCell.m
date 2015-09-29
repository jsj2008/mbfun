//
//  MBMyGoodsContentTableViewCell.m
//  Wefafa
//
//  Created by Jiang on 4/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBMyGoodsContentTableViewCell.h"
#import "MBOtherUserInfoModel.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface MBMyGoodsContentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *collocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLaebl;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
- (IBAction)attentionButtonAction:(UIButton *)sender;

@end

@implementation MBMyGoodsContentTableViewCell

- (void)awakeFromNib {
    self.headerImageView.layer.cornerRadius = self.headerImageView.bounds.size.height/ 2;
    self.headerImageView.layer.masksToBounds = YES;
}

- (void)setModel:(MBOtherUserInfoModel *)model{
    _model = model;
//    [self.headerImageView setImageAFWithURL:[NSURL URLWithString:model.headPortrait] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.headPortrait] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
//    [self.headerImageView setImageWithURL:[NSURL URLWithString:model.headPortrait] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    self.nameLabel.text = model.nickName;
    self.fansLaebl.text = [NSString stringWithFormat:@"粉丝：%@", model.concernedCount];
    self.collocationLabel.text = [NSString stringWithFormat:@"关注：%@", model.concernCount];
    self.attentionButton.selected = model.isConcerned.boolValue;
}


- (IBAction)attentionButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(attentionButtonAction:model:)]) {
        [self.delegate attentionButtonAction:sender model:self.model];
    }
}
@end
