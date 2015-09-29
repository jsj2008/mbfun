//
//  VerifyViewController.m
//  Designer
//
//  Created by Charles on 15/1/20.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "VerifyViewController.h"
#import "BindCompleteViewController.h"

@interface VerifyViewController ()

@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(next)];
    bar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = bar;
    self.title = @"绑定银行卡";
}

-(void)next
{
    BindCompleteViewController *complete = [[BindCompleteViewController alloc]init];
    [self.navigationController pushViewController:complete animated:YES];
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
