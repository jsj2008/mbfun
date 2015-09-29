//
//  SActivityOnSaleCell.h
//  Wefafa
//
//  Created by unico on 15/5/17.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommentMsg)(NSDictionary* data);
typedef void(^ShareContent)(NSDictionary* data);
typedef void(^ShowOtherProfile)(NSString* userIdStr);

@interface SActivityOnSaleCell : UITableViewCell

@property (strong, nonatomic) UIImageView *cellImageView;
@property (strong, nonatomic)  UIButton *shareBtn;
@property (strong, nonatomic)  UIButton *likeBtn;
@property (strong, nonatomic)  UIButton *commentBtn;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *nameLabel;


@property (strong,nonatomic) NSMutableDictionary *data;
@property (nonatomic, strong) CommentMsg commentMsg;
@property (nonatomic, strong) ShareContent shareContent;
@property (nonatomic, strong) ShowOtherProfile showOtherProfile;
@property (nonatomic) NSInteger cellHeight;

@end