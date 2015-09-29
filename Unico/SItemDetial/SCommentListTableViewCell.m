//
//  SCommentListTableViewCell.m
//  Wefafa
//
//  Created by unico_0 on 5/30/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SCommentListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommentListModel.h"
#import "SProductDetailCommentModel.h"
#import "SUtilityTool.h"
#import "WeFaFaGet.h"
#import "Utils.h"

@interface SCommentListTableViewCell ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *showUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *showNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *showCmmentContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *showDateLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *showContentView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (strong,nonatomic) UIImageView *head_V_view;

- (IBAction)actionButtonTouch:(UIButton *)sender;

@end

@implementation SCommentListTableViewCell

- (void)awakeFromNib {
    self.showUserImageView.layer.masksToBounds = YES;
    self.showUserImageView.layer.cornerRadius = self.showUserImageView.width/ 2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImageTapAction:)];
    [self.showUserImageView addGestureRecognizer:tap];
    _contentScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH + _actionButton.frame.size.width, 0);
    _contentScrollView.delegate = self;
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchContentViewTap:)];
    [_showContentView addGestureRecognizer:tap];
    
    
    _head_V_view=[[UIImageView alloc]initWithFrame:CGRectMake(self.showUserImageView.frame.origin.x+self.showUserImageView.frame.size.width-10, self.showUserImageView.frame.size.height+self.showUserImageView.frame.origin.y-12, 12, 12)];
    [_head_V_view setImage:[UIImage imageNamed:@"peoplevip@2x"]];
    _head_V_view.layer.cornerRadius=_head_V_view.frame.size.width/ 2;
    _head_V_view.layer.borderWidth = 1.0;
    _head_V_view.layer.borderColor = [UIColor whiteColor].CGColor;
    _head_V_view.layer.masksToBounds = YES;

    [_showContentView addSubview:_head_V_view];
    
    
}

- (void)setContentModel:(CommentListModel *)contentModel{
    _contentModel = contentModel;
    
    [self.showUserImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.head_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    
    NSString *listHead_v_type = [NSString stringWithFormat:@"%@",_contentModel.head_v_type];
    
    switch ([listHead_v_type integerValue]) {
        case 0:
        {
            _head_V_view.hidden=YES;
        }
            break;
        case 1:
        {
            _head_V_view.hidden=NO;
            [_head_V_view setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
        case 2:
        {
            [_head_V_view setImage:[UIImage imageNamed:@"peoplevip@2x"]];
            _head_V_view.hidden=NO;
        }
            break;
        default:
            break;
    }
    self.showNickNameLabel.text = contentModel.nick_name;
    self.showDateLabel.text = [SUTILITY_TOOL_INSTANCE getTimeByTodayWithString:contentModel.create_time];
    if (contentModel.to_user_id.length > 0) {
        NSString *touserName = contentModel.to_user[@"nick_name"];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"回复@%@：%@", touserName, contentModel.info]];
        [attributeString addAttribute:NSForegroundColorAttributeName value:COLOR_C1 range:NSMakeRange(2, touserName.length + 1)];
        _showCmmentContentLabel.attributedText = attributeString;
    }else{
        self.showCmmentContentLabel.text = contentModel.info;
    }
    
    if ([contentModel.user_id isEqualToString:sns.ldap_uid]) {
        _actionButton.selected = YES;
        _actionButton.backgroundColor = [Utils HexColor:0xfd5b4e Alpha:1];
    }else{
        _actionButton.selected = NO;
        _actionButton.backgroundColor = [Utils HexColor:0xc4c4c4 Alpha:1];
    }
}

- (void)setProductModel:(SProductDetailCommentModel *)productModel{
    _productModel = productModel;
    _head_V_view.hidden=YES;
    [self.showUserImageView sd_setImageWithURL:[NSURL URLWithString:productModel.headPortrait] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    self.showNickNameLabel.text = productModel.nickName;
    self.showDateLabel.text = [SUTILITY_TOOL_INSTANCE getTimeByTodayWithString:productModel.creatE_DATE];
    self.showCmmentContentLabel.text = productModel.content;
    self.contentScrollView.scrollEnabled = NO;
}

- (void)touchContentViewTap:(UITapGestureRecognizer*)tap{
    if (_contentModel.to_user_id.length > 0) {
        CGPoint location = [tap locationInView:tap.view];
        NSString *touserName = _contentModel.to_user[@"nick_name"];
        touserName = [NSString stringWithFormat:@"回复@%@：", touserName];
        CGSize size = [touserName sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        size.height += 3;
        CGRect rect = _showCmmentContentLabel.frame;
        rect.size = size;
        if (CGRectContainsPoint(rect, location)) {
            if ([self.delegate respondsToSelector:@selector(commentCellUserImage:userID:)]) {
                [self.delegate commentCellUserImage:_showUserImageView userID:_contentModel.to_user_id];
            }
            return;
        }
    }
    if([_contentModel.user_id isEqualToString:sns.ldap_uid]) return;
    if ([self.delegate respondsToSelector:@selector(commentCell:model:)]) {
        [self.delegate commentCell:self model:_contentModel];
    }
}

- (void)setIsScrollAction:(BOOL)isScrollAction{
    _isScrollAction = isScrollAction;
    self.contentScrollView.scrollEnabled = isScrollAction;
}

- (void)closeActionButton{
    [_contentScrollView setContentOffset:CGPointZero animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect frame = _actionButton.frame;
    frame.origin.x = UI_SCREEN_WIDTH - frame.size.width + scrollView.contentOffset.x;
    _actionButton.frame = frame;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == _actionButton.bounds.size.width) {
        if ([self.delegate respondsToSelector:@selector(commentOpenCell:actionButton:model:)]) {
            [self.delegate commentOpenCell:self actionButton:_actionButton model:_contentModel];
        }
    }
}

- (void)showImageTapAction:(UITapGestureRecognizer*)tap{
    if ([self.delegate respondsToSelector:@selector(commentCellUserImage:userID:)]) {
        [self.delegate commentCellUserImage:_showUserImageView userID:_contentModel.user_id];
    }
}

- (IBAction)actionButtonTouch:(UIButton *)sender {
    [self closeActionButton];
    if ([self.delegate respondsToSelector:@selector(commentCell:actionButton:model:)]) {
        [self.delegate commentCell:self actionButton:sender model:_contentModel];
    }
}

@end
