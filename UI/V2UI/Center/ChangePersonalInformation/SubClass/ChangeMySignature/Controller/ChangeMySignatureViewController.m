//
//  ChangeMySignatureViewController.m
//  Designer
//
//  Created by Jiang on 1/20/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "ChangeMySignatureViewController.h"

@interface ChangeMySignatureViewController ()

@property (weak, nonatomic) IBOutlet UITextView *mySignatureTextView;

@end

@implementation ChangeMySignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"个性签名"];
    [self setLeftButton:@"取消" target:self selector:@selector(navigationItemLeftItemAction:)];
    [self setRightButton:@"保存" target:self selector:@selector(navigationItemRightItemAction:)];
    self.mySignatureTextView.text = self.mySignatureText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)navigationItemLeftItemAction:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)navigationItemRightItemAction:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
