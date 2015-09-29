//
//  SDiscoveryHomeViewController.m
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryHomeViewController.h"
#import "SSearchViewController.h"
#import "STokenSearchView.h"

@interface SDiscoveryHomeViewController ()<STokenSearchViewDelegate>

@end

static NSString *headerIdentifier = @"SDiscoveryHeaderReusableViewIdentifier";
@implementation SDiscoveryHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupNavbar{
    [super setupNavbar];
    [self createNavigationCenterView];
}

#pragma mark - super method
- (void)createNavigationCenterView{
    STokenSearchView *searchBar = [[STokenSearchView alloc] initWithFrame:CGRectMake(0, 0, (UI_SCREEN_WIDTH - MAX(self.navigationItem.leftBarButtonItems.count, self.navigationItem.rightBarButtonItems.count) * 88), 26)];
    searchBar.delegate = self;
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
    searchBar.isNotBecomeFirstResponder = YES;
    self.tabBarController.navigationItem.titleView = searchBar;
}

#pragma mark - search delegate
- (void)tokenSearchView:(STokenSearchView *)searchView textFieldShouldBeginEditing:(UITextField *)textField{
    SSearchViewController *controller = [[SSearchViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
