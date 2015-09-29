//
//  MyIncomeViewController.m
//  Designer
//
//  Created by Charles on 15/1/16.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "MyIncomeViewController.h"
#import "IncomeDetailsViewController.h"
#import "BindCardViewController.h"
#import "NavigationTitleView.h"

@interface MyIncomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *bindButton;

@end

@implementation MyIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"我的收益";
    CGRect headrect=CGRectMake(0,0,_headView.frame.size.width,_headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:@selector(showRightMenu)];
    
    view.lbTitle.text=@"我的收益";
    [self.headView addSubview:view];

    [self SetRightButton:nil Image:@"more"];
}
-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)RightReturn:(UIButton *)sender {
    self.bindButton.hidden = !self.bindButton.hidden;
}

- (IBAction)bind:(UIButton *)sender {
    BindCardViewController *bind = [[BindCardViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:bind];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)detail:(UIButton *)sender {
    IncomeDetailsViewController *ic = [[IncomeDetailsViewController alloc]init];
    [self.navigationController pushViewController:ic animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
