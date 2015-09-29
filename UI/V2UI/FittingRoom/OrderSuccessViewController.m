//
//  OrderSuccessViewController.m
//  Wefafa
//
//  Created by yintengxiang on 15/3/19.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "OrderSuccessViewController.h"
#import "NavigationTitleView.h"
#import "CreatQR.h"

@interface OrderSuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRImage;

@end

@implementation OrderSuccessViewController
-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    CGRect rect = [UIApplication sharedApplication].keyWindow.bounds;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationController.navigationBarHidden = NO;
    self.title = @"提交预约单";
//    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
//    [view createTitleView:CGRectMake(0, 0, rect.size.width, 64) delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
//    view.lbTitle.text =@"提交预约单";
//    [self.view addSubview:view];
    
    self.orderLabel.text = [NSString stringWithFormat:@"您的预约单号为：%@",self.resultDic[@"appointmentNo"]];
    self.QRImage.image = [CreatQR creatOR:[NSString stringWithFormat:@"%@",self.resultDic[@"appointmentNo"]]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
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
