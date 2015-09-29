//
//  SMyTopicPicCollectionViewCell.m
//  Wefafa
//
//  Created by wave on 15/7/22.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMyTopicPicCollectionViewCell.h"
#import "SMyTopicPicModel.h"
#import "SDataCache.h"
#import "MBSettingMainViewController.h"
#import "SMineViewController.h"
#import "WeFaFaGet.h"
#import "AppDelegate.h"
#import "SMyTopicViewController.h"
#import "UIButton+WebCache.h"

@interface SMyTopicPicCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *discrptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

- (IBAction)likeBtnClicked:(id)sender;
@end

@implementation SMyTopicPicCollectionViewCell

- (void)setModel:(SMyTopicPicModel *)model {
    if (!model) {
        return;
    }
    _model = model;
    
    [_contentImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    [_discrptionLabel setText:model.content_info];
    [_likeButton setTitle:model.like_count forState:UIControlStateNormal];
    _likeButton.selected = [_model.is_love intValue];
    [_commentBtn setTitle:model.comment_count forState:UIControlStateNormal];
    [_commentBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    CGSize size = _commentBtn.bounds.size;
    size = [_commentBtn intrinsicContentSize];
    size.width += 5;
//    [_commentBtn intrinsicContentSize];
}

- (void)awakeFromNib {
    // Initialization code
    self.layer.cornerRadius = 3;
    self.backgroundColor = [UIColor whiteColor];
    [_commentBtn setImage:[UIImage imageNamed:@"Unico/icon_comment2.png"] forState:UIControlStateNormal];
}

- (IBAction)likeBtnClicked:(id)sender {
    if (_likeButton.selected) {
        return;
    }
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    _model.like_count = [NSString stringWithFormat:@"%d", [_model.like_count intValue] + 1];
    [_likeButton setTitle:_model.like_count forState:UIControlStateNormal];
    _model.is_love = @"1";
    _likeButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        _likeButton.imageView.transform = CGAffineTransformMakeScale(0, 1);
    }completion:^(BOOL finished) {
        _likeButton.selected = YES;
        [UIView animateWithDuration:0.2 animations:^{
            _likeButton.imageView.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            _likeButton.userInteractionEnabled = YES;
        }];
    }];
    [[SDataCache sharedInstance]likeCollocation:_model.aid complete:^(NSArray *data) {
        ((SMyTopicViewController*)_collectionView).block();
    }];
}

/*
- (void)setLikeBtnStatus:(BOOL)status {
    _likeButton.selected = status;
}

- (void)changeLikeStatus:(BOOL)status {
    
}
*/
@end
