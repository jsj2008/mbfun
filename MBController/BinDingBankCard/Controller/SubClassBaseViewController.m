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
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Menu_PopOver_BG.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    

}


- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
    [super viewWillAppear:animated];
}

- (void)setTitle:(NSString *)title{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}

- (void)setLeftButtonImage:(NSString*)imageName target:(id)target selector:(SEL)selector{
//    UIImage *image = [UIImage imageNamed:imageName];
//    UIButton *btn = [[UIButton alloc]init];
//    btn.frame = CGRectMake(0, 0, 15, 22);
//    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
////    [btn setBackgroundImage:image forState:UIControlStateNormal];
//    [btn setImage:image forState:UIControlStateNormal];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *leftItem= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,leftItem] ;
}

- (void)setLeftButton:(NSString*)title target:(id)target selector:(SEL)selector{
    NSString *string = [NSString stringWithFormat:@"  %@", title];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStylePlain target:target action:selector];

    
    [leftItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftItem;

}
- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)setRightButtonImage:(NSString*)imageName target:(id)target selector:(SEL)selector{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:target action:selector];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setRightButton:(NSString *)title target:(id)target selector:(SEL)selector{
    title = [title stringByAppendingString:@"  "];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
