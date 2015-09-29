//
//  BindCardViewController.m
//  Designer
//
//  Created by Charles on 15/1/20.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "BindCardViewController.h"
#import "VerifyViewController.h"

@interface BindCardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cardNumTxtFld;

@end

@implementation BindCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.cardNumTxtFld.rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"canmer"]];
//    self.cardNumTxtFld.rightViewMode = UITextFieldViewModeAlways;
//    [self setRightButton:@"下一步" action:@selector(next)];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(next)];
    bar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = bar;
    self.title = @"绑定银行卡";
}

-(void)next
{
    VerifyViewController *verify = [[VerifyViewController alloc]init];
    [self.navigationController pushViewController:verify animated:YES];
}

- (IBAction)takePicture:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
