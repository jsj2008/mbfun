//
//  STabbarNavigationBarController.m
//  Wefafa
//
//  Created by unico_0 on 7/13/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "STabbarNavigationBarController.h"

@implementation STabbarNavigationBarController

- (void)viewDidLoad{
    [super viewDidLoad];
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
}

@end
