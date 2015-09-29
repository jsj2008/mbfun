//
//  SCommentListTableViewCell.h
//  Wefafa
//
//  Created by unico_0 on 5/30/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentListModel, SCommentListTableViewCell, SProductDetailCommentModel;

@protocol SCommentListTableViewCellDelegate <NSObject>

- (void)commentCell:(SCommentListTableViewCell*)cell model:(CommentListModel*)model;
- (void)commentCellUserImage:(UIImageView*)imageView userID:(NSString*)userID;
- (void)commentCell:(SCommentListTableViewCell*)cell actionButton:(UIButton*)button model:(CommentListModel*)model;
- (void)commentOpenCell:(SCommentListTableViewCell*)cell actionButton:(UIButton *)button model:(CommentListModel *)model;

@end

@interface SCommentListTableViewCell : UITableViewCell

@property (nonatomic, assign) id<SCommentListTableViewCellDelegate> delegate;
@property (nonatomic, strong) CommentListModel *contentModel;
@property (nonatomic, strong) SProductDetailCommentModel *productModel;
@property (nonatomic, assign) BOOL isScrollAction;

- (void)closeActionButton;

@end