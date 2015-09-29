//
//  SCollocationCommentCollectionViewCell.h
//  Wefafa
//
//  Created by Jiang on 8/2/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentListModel, SCollocationCommentCollectionViewCell;

@protocol SCommentCollectionViewCellDelegate <NSObject>
- (void)commentCell:(SCollocationCommentCollectionViewCell*)cell model:(CommentListModel*)model;
- (void)commentCellUserImage:(UIImageView*)imageView userID:(NSString*)userID;
- (void)commentCell:(SCollocationCommentCollectionViewCell*)cell actionButton:(UIButton*)button model:(CommentListModel*)model;
- (void)commentOpenCell:(SCollocationCommentCollectionViewCell*)cell actionButton:(UIButton *)button model:(CommentListModel *)model;

@end

@interface SCollocationCommentCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) id<SCommentCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) CommentListModel *contentModel;

- (void)closeActionButton;


@end
