//
//  ChangeNicknameViewController.m
//  Designer
//
//  Created by Jiang on 1/21/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "ChangeNicknameViewController.h"

@interface ChangeNicknameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@end

@implementation ChangeNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"昵称"];
    [self setLeftButton:@"取消" target:self selector:@selector(navigationItemLeftItemAction:)];
    [self setRightButton:@"保存" target:self selector:@selector(navigationItemRightItemAction:)];
    self.nickNameTextField.text = self.nickName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationItemLeftItemAction:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)navigationItemRightItemAction:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
