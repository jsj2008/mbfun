//
//  SMineViewController.h
//  Wefafa
//
//  Created by unico_0 on 6/4/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ISSUE_HEIGHT 42
@class ShoppIngBagShowButton;
@class HeadVipImgView;
@interface SMineViewController : SBaseViewController




@property (nonatomic,strong) NSString *person_id;

//是否从他人中心进入
@property (nonatomic, assign) BOOL isHiddenBackItem;
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;
// 子类要用
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (strong, nonatomic) IBOutlet UIView *userHeaderView;

- (void)listViewDidScroll:(UIScrollView *)scrollView;
- (void)setttingNavigationAlpha:(CGFloat)offset_Y;
//没有数据显示背景图
-(void)configNotifyViewWithTitle;
@end
