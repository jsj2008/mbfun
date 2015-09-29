//
//  SubClassBaseViewController.m
//  Designer
//
//  Created by Jiang on 1/20/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "SubClassBaseViewController.h"

@interface SubClassBaseViewController ()

@end

@implementation SubClassBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)setTitle:(NSString *)title{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}
- (void)setLeftButton:(NSString*)title target:(id)target selector:(SEL)selector{
    NSString *string = [NSString stringWithFormat:@"  %@", title];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStylePlain target:target action:selector];
    [leftItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)setRightButton:(NSString *)title target:(id)target selector:(SEL)selector{
    title = [title stringByAppendingString:@"  "];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
    rightItem.tintColor = [UIColor yellowColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
