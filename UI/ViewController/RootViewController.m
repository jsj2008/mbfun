//
//  RootViewController.m
//  Wefafa
//
//  Created by fafa  on 13-6-22.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "RootViewController.h"
//#import "MainTabViewController.h"
//#import "LaunchScreenView.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationBar.barStyle = UIBarStyleBlack;
//        self.navigationBarHidden = YES;
//        self.viewControllers= @[[[MainTabViewController alloc]initWithNibName:@"MainTabViewController" bundle:nil]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        //        self.view = nil;
    }
}
- (void)dealloc
{
}

-(void)setSubViewController:(UIViewController*)viewcontroller
{
    self.viewControllers= @[viewcontroller];
}

@end
