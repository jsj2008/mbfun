//
//  BinDingBankCardViewController.m
//  Wefafa
//
//  Created by Jiang on 2/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "BinDingBankCardFinishViewController.h"

@interface BinDingBankCardFinishViewController ()
@property (weak, nonatomic) IBOutlet UIButton *succeedReturnButton;
- (IBAction)succeedReturnButtonAction:(UIButton *)sender;

@end

@implementation BinDingBankCardFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButtonImage:@"btn_profile_backarrow.png" target:self selector:@selector(navigationBarLeftButton)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationBarLeftButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)succeedReturnButtonAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
