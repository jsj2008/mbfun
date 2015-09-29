//
//  SHomeNavigationViewController.m
//  Wefafa
//
//  Created by unico_0 on 6/19/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SHomeNavigationViewController.h"

@interface SHomeNavigationViewController ()

@end

@implementation SHomeNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count == 0) {
        [super pushViewController:viewController animated:animated];
    }else{
        [self.tabBarController.navigationController pushViewController:viewController animated:animated];
    }
}

@end
