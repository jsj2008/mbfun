//
//  NoShoppingCommentsViewController.h
//  Wefafa
//
//  Created by chencheng on 15/7/15.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"

@interface NoShoppingCommentsViewController : UIViewController//SBaseViewController

@property (nonatomic, copy) NSString *collocationID;
@property (nonatomic, strong) NSMutableString *commentDetailCount;


@property (strong, nonatomic)  UIView *showCommentLevelView;
@property (strong, nonatomic)  UIView *commentContentBearingView;
@property (strong, nonatomic)  UITableView *contentTableView;
@property (strong, nonatomic)  UILabel *commentCountLabel;
@property (strong, nonatomic)  UIView *commentContentView;
@property (strong, nonatomic)  UILabel *commentTotalScoreLabel;
@property (strong, nonatomic)  UITextField *commentSendMessageTextFiled;
- (IBAction)commentSendButtonAction:(UIButton *)sender;

@property (nonatomic, strong) UIView *shieldView;

@property (nonatomic, strong) NSMutableArray *contentModelArray;
@property (nonatomic, assign) int commentCount;
@property (nonatomic, assign) CGFloat commentTotalScore;
@property (nonatomic, strong) UIView *commentLevelView;
@property (nonatomic, strong) UIView *commentLevelNoneView;

- (void)requestSendMessage;

@end
