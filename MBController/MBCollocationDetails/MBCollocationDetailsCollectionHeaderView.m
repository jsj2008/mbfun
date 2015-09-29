//
//  MBCollocationDetailsCollectionHeaderView.m
//  Wefafa
//
//  Created by Jiang on 5/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBCollocationDetailsCollectionHeaderView.h"
#import "MBCollocationInfoModel.h"
#import "MBCollocationUserPublicModel.h"
#import "MBCollocationTagMappingModel.h"
#import "UIImageView+AFNetworking.h"
#import "Utils.h"

@interface MBCollocationDetailsCollectionHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *userInfoContentView;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
- (IBAction)attentionButtonAction:(UIButton *)sender;
//
@property (weak, nonatomic) IBOutlet UIImageView *showCollocationImageView;
//-----
@property (weak, nonatomic) IBOutlet UIView *decreptionContentView;
@property (weak, nonatomic) IBOutlet UILabel *decreptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *descreptionImageView;
//-----
@property (weak, nonatomic) IBOutlet UIButton *shoppingBagButton;
- (IBAction)shoppingBagButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *buyNowButton;
- (IBAction)buyNowButtonAction:(UIButton *)sender;

@end

@implementation MBCollocationDetailsCollectionHeaderView

- (void)awakeFromNib {
    
    [self initSubViews];
}

- (void)initSubViews{
    self.descreptionImageView.image = [UIImage imageNamed:@"show_tag_image@2x.png"];
    
    self.shoppingBagButton.layer.cornerRadius = 4.0;
    self.buyNowButton.layer.cornerRadius = 4.0;
    self.userIconImageView.layer.masksToBounds = YES;
    self.userIconImageView.layer.cornerRadius = self.userIconImageView.bounds.size.width/ 2;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userContentTapAction:)];
    [self.userInfoContentView addGestureRecognizer:tapGesture];
}

- (void)setContentInfoModel:(MBCollocationInfoModel *)contentInfoModel{
    _contentInfoModel = contentInfoModel;
    UIImage *image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    [self.showCollocationImageView sd_setImageWithURL:[NSURL URLWithString:contentInfoModel.pictureUrl] placeholderImage:image];
    self.decreptionLabel.text = contentInfoModel.aDescription;
    
}

- (void)setContentUserModel:(MBCollocationUserPublicModel *)contentUserModel{
    _contentUserModel = contentUserModel;
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:contentUserModel.headPortrait] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    self.userNameLabel.text = contentUserModel.nickName;
}

- (void)setContentTagModel:(NSArray *)contentTagModel{
    _contentTagModel = contentTagModel;
    CGFloat tag_X = 40.0;
    CGFloat tag_Y = 50.0;
    for(int i = 0; i < contentTagModel.count; i++){
        MBCollocationTagMappingModel *model = contentTagModel[i];
        CGSize size = [model.showTagName boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 30, 0)
                       options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                       attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
        if (size.width + 20 + tag_X > UI_SCREEN_WIDTH - 15) {
            tag_X = 15.0;
            tag_Y += 30;
        }
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(tag_X, tag_Y, size.width + 20, 25)];
        button.tag = i + 20;
        [button addTarget:self action:@selector(tagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor lightGrayColor];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        button.titleLabel.textColor = [UIColor whiteColor];
        [button setTitle:model.showTagName forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3.0;
        [self.decreptionContentView addSubview:button];
        
        tag_X += size.width + 30;
    }
    
    CGRect frame = self.decreptionContentView.frame;
    frame.size.height += tag_Y - 50.0;
    self.decreptionContentView.frame = frame;
//    frame = self.frame;
//    frame.size.height += tag_Y - 50;
//    self.frame = frame;
}

- (void)setIsConcerned:(BOOL)isConcerned{
    _isConcerned = isConcerned;
    self.attentionButton.selected = isConcerned;
}

- (void)setHeaderImageView:(UIImageView *)headerImageView{
    headerImageView = self.showCollocationImageView;
}

- (IBAction)shoppingBagButtonAction:(UIButton *)sender {
    if ([self.headerDelegate respondsToSelector:@selector(collocationDetails:ShoppingBagButton:)]) {
        [self.headerDelegate collocationDetails:self ShoppingBagButton:sender];
    }
}
- (IBAction)buyNowButtonAction:(UIButton *)sender {
    if ([self.headerDelegate respondsToSelector:@selector(collocationDetails:BuyNowButton:)]) {
        [self.headerDelegate collocationDetails:self BuyNowButton:sender];
    }
}

- (IBAction)attentionButtonAction:(UIButton *)sender {
    if ([self.headerDelegate respondsToSelector:@selector(collocationDetails:AttentionButton:)]) {
        [self.headerDelegate collocationDetails:self AttentionButton:sender];
    }
}

- (void)userContentTapAction:(UITapGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:sender.view];
    if (location.x < self.attentionButton.frame.origin.x - 15) {
        if ([self.headerDelegate respondsToSelector:@selector(collocationDetailsUserContentTouchTap:)]) {
            [self.headerDelegate collocationDetailsUserContentTouchTap:self];
        }
    }
}

- (void)tagButtonAction:(UIButton*)button{
    if ([self.headerDelegate respondsToSelector:@selector(collocationDetails:TagIndex:)]) {
        [self.headerDelegate collocationDetails:self TagIndex:button.tag - 20];
    }
}

@end
