//
//  BindCompleteViewController.m
//  Designer
//
//  Created by Charles on 15/1/20.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "BindCompleteViewController.h"

@interface BindCompleteViewController ()

@end

@implementation BindCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"绑定银行卡";
}

- (IBAction)continueBind:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
