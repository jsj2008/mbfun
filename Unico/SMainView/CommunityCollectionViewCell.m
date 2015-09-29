    //
//  CommunityCollectionViewCell.m
//  Wefafa
//
//  Created by wave on 15/8/17.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityCollectionViewCell.h"
#import "SUtilityTool.h"

@interface CommunityCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *like;

@end

@implementation CommunityCollectionViewCell

- (void)setModel:(LNGood *)model {
    //img
    [_img sd_setImageWithURL:[NSURL URLWithString:model.img] isLoadThumbnail:YES placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    //count
    NSString *commentStr = model.comment_count.length >= 3 ? commentStr = [NSString stringWithFormat:@"%@.%@k", [model.comment_count substringToIndex:1], [model.comment_count substringWithRange:NSMakeRange(1, 1)]] : model.comment_count;
    NSString *likeStr = model.like_count.length >= 3 ? likeStr = [NSString stringWithFormat:@"%@.%@k", [model.like_count substringToIndex:1], [model.like_count substringWithRange:NSMakeRange(1, 1)]] : model.like_count;
    [_comment setTitle:commentStr forState:UIControlStateNormal];
    [_comment setTitle:commentStr forState:UIControlStateHighlighted];
    [_comment setTitle:commentStr forState:UIControlStateSelected];
    [_like setTitle:likeStr forState:UIControlStateNormal];
    [_like setTitle:likeStr forState:UIControlStateHighlighted];
    [_like setTitle:likeStr forState:UIControlStateSelected];
    //like
    _like.selected = [model.is_love boolValue];
    
    if(![_userID isEqualToString:@""]&&_userID){
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_img
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1
                                                        constant:0]];
    }
}

- (void)awakeFromNib {
    // Initialization code
//    Unico/icon_comment2.png", @"Unico/icon_like2.png", @"Unico/icon_like22.png"
    CGRect rect = _img.frame;
    rect.size.width = 124 * SCALE_UI_SCREEN;
    rect.size.height = 200 * SCALE_UI_SCREEN;
    _img.frame = rect;
    _img.contentMode = UIViewContentModeScaleAspectFill;
    _img.layer.masksToBounds = YES;
    
    
    [_comment setTintColor:COLOR_C7];
    [_comment setTitleColor:COLOR_C7 forState:UIControlStateNormal];
    _comment.titleLabel.font = FONT_t7;
    
    [_like setTintColor:COLOR_C7];
    [_like setTitleColor:COLOR_C7 forState:UIControlStateNormal];
    _like.titleLabel.font = FONT_t7;
    
    _comment.userInteractionEnabled = NO;
    _like.userInteractionEnabled = NO;
}

@end
