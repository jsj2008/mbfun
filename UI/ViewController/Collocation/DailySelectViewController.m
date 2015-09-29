//
//  DailySelectViewController.m
//  Wefafa
//
//  Created by mac on 14-8-2.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "DailySelectViewController.h"
#import "utils.h"
#import "Base.h"

@interface DailySelectViewController ()

@end

@implementation DailySelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.headView.backgroundColor = TITLE_BG;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
