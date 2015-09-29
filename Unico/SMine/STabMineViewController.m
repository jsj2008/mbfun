//
//  STabMineViewController.m
//  Wefafa
//
//  Created by su on 15/6/20.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "STabMineViewController.h"
#import "ShoppIngBagShowButton.h"
#import "WeFaFaGet.h"
#import "HeadVipImgView.h"
#import "SAgilityNavigationBarTool.h"
#import "SMenuBottomModel.h"

@interface STabMineViewController ()

@end

@implementation STabMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavbar];
    [self initNavigationBar];
    // 临时解决下切换账号问题。
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:sns.myStaffCard.photo_path_big] placeholderImage:[UIImage imageNamed:@"Unico/common_navi_portarit.png"]];
}

- (void)initNavigationBar{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_transparentblack.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self.tabBarController setValue:_layoutModel forKey:@"layoutModel"];
    self.tabBarController.navigationItem.titleView = nil;
}

#pragma mark - scroll to hide tabbar

- (void)listViewWillBeginDraggingScroll:(UIScrollView *)scrollView{
    [self.tabBarController setValue:scrollView forKey:@"scrollViewBegin"];

}

- (void)listViewDidScroll:(UIScrollView *)scrollView{
    
    [self.tabBarController setValue:scrollView forKey:@"controlScrollView"];
    
    [super listViewDidScroll:scrollView];
}

@end
