//
//  SDesignerCell.h
//  Wefafa
//
//  Created by 凯 张 on 15/5/28.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBaseTableViewCell.h"
#import "DesignerModel.h"
#import "SDesignerViewController.h"
#import "SMineViewController.h"

typedef void(^CommentMsg)(NSDictionary* data);
typedef void(^ShareContent)(NSDictionary* data);
typedef void(^ShowOtherProfile)(NSString* userIdStr);

@interface SDesignerCell : SBaseTableViewCell

@property (strong, nonatomic) UIImageView *cellImageView;
@property (strong, nonatomic)  UIButton *shareBtn;
@property (strong, nonatomic)  UIButton *likeBtn;
@property (strong, nonatomic)  UIButton *commentBtn;
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong,nonatomic)SDesignerViewController * parentVC;
@property (strong,nonatomic) NSMutableDictionary *data;
@property (nonatomic, strong) CommentMsg commentMsg;
@property (nonatomic, strong) ShareContent shareContent;
@property (nonatomic, strong) ShowOtherProfile showOtherProfile;
-(void)updateDesignerModel:(DesignerModel*)model :(UITableView*)table :(NSIndexPath*)index;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end

