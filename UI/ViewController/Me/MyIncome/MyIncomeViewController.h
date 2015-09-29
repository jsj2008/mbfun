//
//  MyIncomeViewController.h
//  Wefafa
//
//  Created by mac on 14-8-2.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"

@interface MyIncomeViewController :SBaseViewController /*UIViewController*/<UIAlertViewDelegate,CustomAlertViewDelegate>
{

}
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong,nonatomic)IBOutlet UIButton *btnMenu;
- (IBAction)btnBackClick:(id)sender;
-(IBAction)showList:(id)sender;

///////////
- (IBAction)extractSQBtnCLick:(id)sender;
- (IBAction)waitSQBtnClick:(id)sender;
-(IBAction)getLSBtnClick:(id)sender;
- (IBAction)earningLSBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *showTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *showExtLabel;
@property (weak, nonatomic) IBOutlet UILabel *ljsyShowLabel;
@property (weak, nonatomic) IBOutlet UILabel *ljtxShowLabel;
@property (weak, nonatomic) IBOutlet UILabel *sysyShowLabel;
@property (weak, nonatomic) IBOutlet UILabel *qtsyShowLabel;
@property (weak, nonatomic) IBOutlet UIView *showMoreView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *showTitleView;
@property (weak, nonatomic) IBOutlet UIView *showExtView;
@property (weak, nonatomic) IBOutlet UIView *showBottomView;
@property (weak, nonatomic) IBOutlet UIButton *incomeBtn;

@property (weak, nonatomic) IBOutlet UIButton *setBalenceBtn;

@end
