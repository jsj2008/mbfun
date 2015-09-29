//
//  LogisticsViewControlle2.m
//  Wefafa
//
//  Created by wave on 15/5/19.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "LogisticsViewControlle2.h"
#import "NavigationTitleView.h"
#import "LogisticsTableViewCell.h"
#import "CommMBBusiness.h"
#import "HttpRequest.h"
#import "Toast.h"
#import "MBCustomClassifyModelView.h"
#import "Utils.h"
#import "LogisticsTableView.h"
#import "AttendCustomButton.h"
#import "OrderModel.h"
#import "SUtilityTool.h"

typedef void(^simpleBlock)(NSDictionary*);
@interface LogisticsViewControlle2 ()<UIScrollViewDelegate, MBCustomClassifyModelViewDelegate>
{
    NSMutableArray *requestList;
    MBCustomClassifyModelView *customClassifyModelV;
    NSMutableArray *_arrayTableView;
    simpleBlock _block;
}
@property (nonatomic, strong) UIScrollView *homeView;
@end

@implementation LogisticsViewControlle2

- (void)viewDidLoad {
    self.view.backgroundColor = TITLE_BG;
    NavigationTitleView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [titleView createTitleView:CGRectMake(0, 0, UI_SCREEN_WIDTH, 64) delegate:self selectorBack:@selector(backHome) selectorOk:nil selectorMenu:nil];
    titleView.lbTitle.text=@"订单跟踪";
//    [self.view addSubview:titleView];
    [self setupNavbar];
    if (self.messageDic) {
        self.messageDicOrderModel = [[OrderModel alloc]initWithDictionary:self.messageDic];
        
    }
    self.homeView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64 + 40,UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64 - 40)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.homeView setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
    self.homeView.pagingEnabled = YES;
    self.homeView.bounces = NO;
    self.homeView.delegate = self;
    [self.view addSubview:self.homeView];
    [self request];
    
    requestList = [NSMutableArray new];
    _arrayTableView = [NSMutableArray new];

    _block = ^(NSDictionary *dic){
        
    };
}
- (void)setupNavbar {
    [super setupNavbar];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.title=@"订单跟踪";
    
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)request {
    /*
    NSString *orderID=[NSString stringWithFormat:@"%@",self.messageDic[@"id"]];
    */
     NSString *orderID=[NSString stringWithFormat:@"%@",self.messageDicOrderModel.idStr];
    //    NSString *orderNo=[NSString stringWithFormat:@"%@",self.messageDic[@"orderno"]];
//    NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
//    NSDictionary *param = @{@"userId":userId,@"doc_id":orderID};
//    NSDictionary *param2 = @{@"ORDER_ID" : @73465};
    NSDictionary *param2 = @{@"orderId":orderID};
    [HttpRequest getRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"InvoiceFilterByOrderId" params:param2 success:^(NSDictionary *dict) {
        NSLog(@"InvoiceFilterByOrderId dict ---- %@", dict);
        NSArray *arayResults = dict[@"results"];
        [self reloadView:arayResults];
    } failed:^(NSError *error) {
        [Toast makeToast:kNoneInternetTitle];
    }];
}

- (BOOL)checkNoneData:(NSArray *)array{
    if (!array || array.count <= 0) {
        UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = 210;
        [self.view addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_logistics"]];
        imageView.size = CGSizeMake(80, 80);
        imageView.center = CGPointMake(view.centerX, view.centerY - 45);
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.center = CGPointMake(view.centerX, view.centerY + 15);
        label.textColor = UIColorFromRGB(0x999999);
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"  暂无物流信息！";
        [view addSubview:label];
        
        return YES;
    }
    UIView *view = [self.view viewWithTag:210];
    if (view) {
        [view removeFromSuperview];
    }
    return NO;
}

- (void)reloadView:(NSArray*)array {
    if ([self checkNoneData:array]){
        return;
    }
    
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:array.count];
    //分包按钮
    for (NSDictionary *dic in array)
    {
        [titleArray addObject:[NSString stringWithFormat:@"包裹%d", (int)[array indexOfObject:dic] + 1]];
    }
    customClassifyModelV=[[MBCustomClassifyModelView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, 40) WithTitleArray:titleArray useScroll:NO WithPicAndText:NO WithPicArray:nil WithSelectPicArray:nil WithShowRightBtnLine:YES WithShowBottomBtnLine:YES];
    customClassifyModelV.backgroundColor=[UIColor whiteColor];
    customClassifyModelV.delegate = self;
    [customClassifyModelV setFont: FONT_T4];
    [customClassifyModelV setTextColor:[Utils HexColor:0x999999 Alpha:1.0]];
    [customClassifyModelV setSelectedTextColor:[Utils HexColor:0x3b3b3b Alpha:1.0]];
    [customClassifyModelV buttonClickedOfIndex:0];
    
    [self.view addSubview:customClassifyModelV];
    //设置ScrollView
    [self.homeView setContentSize:CGSizeMake(UI_SCREEN_WIDTH* array.count, self.homeView.height)];
    [self.homeView setContentOffset:CGPointMake(0, 0)];
    //初始化tableView
    for (NSDictionary *dic in array) {
        LogisticsTableView *tableView = [[LogisticsTableView alloc]initWithFrame:CGRectMake([array indexOfObject:dic] * UI_SCREEN_WIDTH,20, UI_SCREEN_WIDTH,UI_SCREEN_HEIGHT - 60 - 40-20) style:UITableViewStyleGrouped withDic:dic];
        tableView.clickCellBlock = _block;
        tableView.autoresizesSubviews = NO;
        [self.homeView addSubview:tableView];
        [_arrayTableView addObject:tableView];
    }
}

#pragma mark -
#pragma mark - MBCustomClassifyModelViewDelegate
-(void)TabItemClick:(id)sender button:(id)param {
    [UIView animateWithDuration:.2 delay:0 options:0 animations:^{
        [_homeView setContentOffset:CGPointMake(((UIButton*)param).tag * self.view.width, 0)];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    [customClassifyModelV buttonClickedOfIndex:point.x / self.view.width];
}

- (void)backHome {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
