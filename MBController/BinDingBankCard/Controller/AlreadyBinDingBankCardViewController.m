//
//  AlreadyBinDingBankCardViewController.m
//  Wefafa
//
//  Created by Jiang on 2/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "AlreadyBinDingBankCardViewController.h"
#import "BinDingBankCardHomeViewController.h"
#import "MBShoppingGuideInterface.h"
//#import "AlreadyBinDingBankCardTableView.h"
#import "NavigationTitleView.h"
#import "MyBankCardModel.h"
#import "HttpRequest.h"
#import "Toast.h"
#import "SUtilityTool.h"
#import "SimpleBinDingBankCardTableView.h"

@interface AlreadyBinDingBankCardViewController ()<SimpleBinDingBankCardTableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet SimpleBinDingBankCardTableView *contentTableView;
@property (nonatomic, strong) MyBankCardModel *model;

@end

@implementation AlreadyBinDingBankCardViewController
{
    UIView * noneDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self initNavigationBar];
    [self requestData];
    self.contentTableView.alreadyTableViewDelegate = self;
    self.contentTableView.tableFooterView = [[UIView alloc]init];
}

- (void)initNavigationBar {
    self.navigationController.navigationBarHidden = NO;
    [self setTitle:@"我的银行卡"];
    [self setRightButton:@"添加" target:self selector:@selector(navigationBarRight)];
//    [self setLeftButton:@"关闭" target:self selector:@selector(navigationBarLeft)];
    [self setLeftButtonImage:@"" target:self selector:@selector(navigationBarLeft)];
}

- (void)requestData {
    [Toast makeToastActivity:@"正在加载数据..." hasMusk:YES];
    __weak typeof(self) p = self;
    
    [HttpRequest collocationGetRequestPath:nil methodName:@"WxSellerCardFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        [p settionContentDataArray:dict[@"results"]];
    } failed:^(NSError *error) {
        [Toast hideToastActivity];
    }];
}

- (void)showSuccessAndRequest {
//    [Toast makeToast:@"添加银行卡信息成功！" duration:2.0 position:@"center"];
    [Toast makeToastSuccess:@"添加银行卡信息成功!" mask:YES];
    [self requestData];
}

- (void)viewDidAppear:(BOOL)animated{
    [self requestData];
}
//显示无数据界面
-(void)layoutNoneDataView
{
    CGFloat originY = self.navigationController.navigationBar.size.height;
    CGRect  noneDataRect = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-originY);
    
    if (!noneDataView) {
        noneDataView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:noneDataRect WithImage:NONE_DATA_ORDER andImgSize:CGSizeMake(39, 50) andTipString:@"尚未绑定银行卡" font:FONT_SIZE(18) textColor:[Utils HexColor:0x999999 Alpha:1.0] andInterval:10.0];

    }
    
    [self.view addSubview:noneDataView];
    
    
}

- (void)settionContentDataArray:(NSArray *)myBankCardArray{
    if (myBankCardArray.count == 0) {
        [self layoutNoneDataView];
        return;
    }
    [noneDataView removeFromSuperview];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in myBankCardArray) {
        MyBankCardModel *model = [[MyBankCardModel alloc] initWithDictionary:dict];
        [array addObject:model];
    }
    self.contentTableView.myBankCardModelArray = array;
}

- (void)setMyBankCardArray:(NSMutableArray *)myBankCardArray{
    _myBankCardArray = myBankCardArray;
    self.contentTableView.myBankCardModelArray = myBankCardArray;
}

- (void)navigationBarRight{
    [self jumbHomeControllerWhitShowLeftButton:YES];
}
- (void)jumbHomeControllerWhitShowLeftButton:(BOOL)isShow{
    BinDingBankCardHomeViewController *controller = [[BinDingBankCardHomeViewController alloc]initWithNibName:@"BinDingBankCardHomeViewController" bundle:nil];
    controller.showBackButton = isShow;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)navigationBarLeft{
    [super dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - tableView delegate

- (void)alreadyTableDeleteCellWithMode:(MyBankCardModel *)model{
    self.model = model;
    
    NSRange range = NSMakeRange(model.carD_NO.length - 4, 4);
    NSString *bankNumberRange = [model.carD_NO substringWithRange:range];
    NSString *alertString = [NSString stringWithFormat:@"正在删除尾号为%@的银行卡!", bankNumberRange];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否删除此银行卡" message:alertString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}
- (void)alreadyTableSettingDefalutCell:(MyBankCardModel *)model{
    NSMutableDictionary *requestBankDic = [NSMutableDictionary dictionary];
    NSMutableString *returnMsg=[NSMutableString string];
    NSDictionary *paramDic=@{@"UserId": sns.ldap_uid, @"Id": model.aID};
    NSString *urlName=@"WxSellerCardUpdateState";
    __weak typeof(self) p = self;
    [Toast makeToastActivity:@"正在更新数据..." hasMusk:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success=[SHOPPING_GUIDE_ITF requestPostUrlName:urlName param:paramDic responseAll:requestBankDic responseMsg:returnMsg];
        [Toast hideToastActivity];
        //银行
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [p requestData];
            }else{
                [Toast makeToast:@"删除失败！" duration:2.0 position:@"center"];
            }
        });
    });
}
#pragma mark alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:{
            [Toast makeToastActivity:@"正在更新数据..." hasMusk:YES];
            NSString *urlName = @"WxSellerCardDelete";
            NSMutableDictionary *requestBankDic = [NSMutableDictionary dictionary];
            NSMutableString *returnMsg=[NSMutableString string];
            NSDictionary *paramDic=@{@"UserId":sns.ldap_uid,@"Ids": self.model.aID};
            __weak typeof(self) p = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                BOOL success = [SHOPPING_GUIDE_ITF requestPostUrlName:urlName param:paramDic responseAll:requestBankDic responseMsg:returnMsg];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    if (success) {
                        [p requestData];
                    }else{
                        [Toast makeToast:@"删除失败！" duration:2.0 position:@"center"];
                    }
                });
            });
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
