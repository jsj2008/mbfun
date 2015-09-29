//
//  testViewController.m
//  Wefafa
//
//  Created by wave on 15/6/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "testViewController.h"
#import "Utils.h"
@interface testViewController ()

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];
    [self setupNavbar];
}

- (void)setupNavbar {
//    [super setupNavbar];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_black@2x.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    self.navigationController.navigationBar.barTintColor = [Utils HexColor:0xf2f2f2 Alpha:1];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_transparentblack.png"] forBarMetrics:UIBarMetricsDefault];

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [rightBtn setImage:[UIImage imageNamed:@"Unico/common_navi_message.png"] forState:UIControlStateNormal];
    UIButton *rightBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn2.frame = CGRectMake(0, 0, 44, 44);
    [rightBtn2 setImage:[UIImage imageNamed:@"Unico/common_navi_message.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    UIBarButtonItem *barItem2 = [[UIBarButtonItem alloc]initWithCustomView:rightBtn2];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 15;
    NSArray *ary = @[barItem,  space,barItem2];
    self.navigationItem.rightBarButtonItems = ary;
    
    /*
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/common_navi_message.png"] style:UIBarButtonItemStylePlain target:self action:nil];
    barItem.width = 22;
    UIBarButtonItem *barItem2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/common_navi_message.png"] style:UIBarButtonItemStylePlain target:self action:nil];
    barItem2.width = 22;
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 15;
    NSArray *ary = @[barItem, space, barItem2];
    self.navigationItem.rightBarButtonItems = ary;
     */
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
