//
//  BinDingBankCardViewController.m
//  Wefafa
//
//  Created by Jiang on 2/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "BinDingBankCardFinishViewController.h"
#import "NavigationTitleView.h"

@interface BinDingBankCardFinishViewController ()
@property (weak, nonatomic) IBOutlet UIButton *succeedReturnButton;
@property (weak, nonatomic) IBOutlet UILabel *bindingIsSucceedLabel;
@property (weak, nonatomic) IBOutlet UILabel *bindingErrorContent;

- (IBAction)succeedReturnButtonAction:(UIButton *)sender;

@end

@implementation BinDingBankCardFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initSubView];
}

- (void)initNavigationBar{
    [self setTitle:@"绑定银行卡"];
    [self setLeftButton:@"关闭" target:self selector:@selector(navigationBarRightButtonTag)];
}
-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubView{
    NSString *bindingIsSucceedString = nil;
    NSString *succeedReturnString = nil;
    self.bindingErrorContent.hidden = self.bindingSucceed;
    if (self.bindingSucceed) {
        bindingIsSucceedString = @"银行卡绑定成功";
        succeedReturnString = @"继续绑定";
    }else{
        bindingIsSucceedString = @"银行卡绑定失败";
        succeedReturnString = @"重新绑定";
        NSString *errorContent = [NSString stringWithFormat:@"错误信息:%@", self.errorContent];
        self.bindingErrorContent.text = errorContent;
    }
    self.bindingIsSucceedLabel.text = bindingIsSucceedString;
    [self.succeedReturnButton setTitle:succeedReturnString forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationBarRightButtonTag{
    [super dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)succeedReturnButtonAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
