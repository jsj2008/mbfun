//
//  PayResultViewController.m
//  Wefafa
//
//  Created by mac on 14-12-16.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "PayResultViewController.h"
#import "NavigationTitleView.h"
#import "Utils.h"
#import "WeFaFaGet.h"
#import "CommMBBusiness.h"
#import "MBShoppingGuideInterface.h"
#import "Toast.h"
#import "DetailOrderViewController.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "MyOrderViewController.h"
#import "SMineViewController.h"
#import "OrderModel.h"
#import "JSWebViewController.h"

@interface PayResultViewController ()

@end

@implementation PayResultViewController

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
    
//    CGRect headrect=CGRectMake(0,0,self.viewHead.frame.size.width,self.viewHead.frame.size.height);
//    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
//    [view createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:nil];
//    view.lbTitle.text=@"交易结果";
//    [self.viewHead addSubview:view];
    [self setupNavbar];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _lbComplete.textColor=[Utils HexColor:0xf36b55 Alpha:1.0];
//    _btnContinue.backgroundColor=[Utils HexColor:0xf36b55 Alpha:1.0];
    
    _btnDetail.backgroundColor=[UIColor whiteColor];
    _btnDetail.layer.borderColor=[Utils HexColor:0xacacac Alpha:1.0].CGColor;
    _btnDetail.layer.borderWidth=1;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderSuccess"
                                                        object:nil
                                                      userInfo:nil];
    //刷新订单信息
    NSDictionary *postDic=@{@"tag":@[@"0",@"1",@"2"]};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];

}
- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(btnBackClick:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.title=@"交易结果";
   
    
    
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payresultcell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payresultcell"];
        //        [self setCellBackground:cell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row==0)
        [cell.contentView addSubview:_viewShowComplete];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
        return _viewShowComplete.frame.size.height;
    return 0;
}

-(void)btnBackClick:(id)sender
{
    
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
         if([controller isKindOfClass:[MyOrderViewController class]]){
            target = controller;
              break;
        }
    }
    
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
    }else{
        for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
            if ([controller isKindOfClass:[SMineViewController class]]) { //这里判断是否为你想要跳转的页面
                target = controller;
                 break;
            }
        }
        
        if (target) {
            [self.navigationController popToViewController:target animated:YES]; //跳转
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }

    }

   
}

- (IBAction)btnContinueClicked:(id)sender {
    
//    [[AppDelegate rootViewController] popToRootViewControllerAnimated:YES];
    
    [self popToRootAnimated:YES];

}

- (IBAction)btnDetailClicked:(id)sender {
    NSMutableArray *requestList=[[NSMutableArray alloc] init];
    NSMutableString *returnMessage=[[NSMutableString alloc]init];
    
    [Toast makeToastActivity:@"正在获取订单信息,请稍后..." hasMusk:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL rst=[SHOPPING_GUIDE_ITF requestGetUrlName:@"OrderFilter" param:@{@"orderno":_orderCode} responseList:requestList responseMsg:returnMessage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            if (rst && requestList.count>0)
            {
//                [self.navigationController popToRootViewControllerAnimated:NO];
//                
//                RootViewController *rootvc=[AppDelegate rootViewController];
//                [rootvc popToRootViewControllerAnimated:NO];
//
//                DetailOrderViewController *detailOrder=[[DetailOrderViewController alloc]init];
//                detailOrder.transDic = requestList[0];
//                [self.navigationController pushViewController:detailOrder animated:YES];
                //old
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"notif_GotoDetailOrderViewController" object:self userInfo:requestList[0]];
                 //2.10 add by miao
//                detailOrder.transDic = requestList[0];
                NSMutableArray *modelArray = [NSMutableArray arrayWithArray:[OrderModel modelArrayForDataArray:requestList]];
                DetailOrderViewController *detailOrder=[[DetailOrderViewController alloc]init];
                detailOrder.transDicOrderModel = modelArray[0];
                [self.navigationController pushViewController:detailOrder animated:YES];
            }
            else
            {
                [Utils alertMessage:@"获取订单信息失败!"];
            }
        });
    });
}

@end
