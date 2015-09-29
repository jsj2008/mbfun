//
//  MyFittingRoomListViewController.m
//  Wefafa
//
//  Created by yintengxiang on 15/3/19.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MyFittingRoomListViewController.h"
#import "FittingRoomSecondCell.h"
#import "BGUtilUI.h"
#import "NavigationTitleView.h"
#import "JSONKit.h"
#import "NetManager.h"
#import "FittingRoomViewController.h"
#import "WeFaFaGet.h"
#import "UIColor+BGHexColor.h"
#import "UIColor+extend.h"
#import "HttpRequest.h"

@interface MyFittingRoomListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabbleView;
@property (weak, nonatomic) IBOutlet UIView *NoDataView;

@property (nonatomic, strong) NSArray *dataList;

@end

@implementation MyFittingRoomListViewController
- (void)loadView
{
    [super loadView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationController.navigationBarHidden = NO;
    self.title = @"我的试衣间";
    self.tabbleView.backgroundColor = [UIColor colorWithHex:0xf2f2f2 alpha:1];
    self.dataList = @[];
    
//    NSDictionary *postDic = @{@"ActionName":@"APP_GetBillAppointment",@"Pars":@{@"UserID":sns.ldap_uid}};
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDic options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [HttpRequest productPostRequestPath:nil methodName:@"APP_GetBillAppointment" params:@{@"userID":sns.ldap_uid} success:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        self.dataList = dict[@"appointmentInfos"];
        if (self.dataList.count > 0) {
            self.NoDataView.hidden = YES;
        }else {
            self.NoDataView.hidden = NO;
        }
        [self.tabbleView reloadData];
    } failed:^(NSError *error) {
        self.NoDataView.hidden = NO;
    }];
    
//    [[NetManager sharedManager] postRequestWithUrlString:DomainUrl postParamDic:@{@"InData" : json} success:^(id responseDic) {
//        NSLog(@"%@",responseDic);
//        self.dataList = responseDic[@"appointmentInfos"];
//        if (self.dataList.count > 0) {
//            self.NoDataView.hidden = YES;
//        }else {
//            self.NoDataView.hidden = NO;
//        }
//        [self.tabbleView reloadData];
//    } failure:^(id errorString) {
//        self.NoDataView.hidden = NO;
//    }];
    
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
- (void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        NSString *cellString = @"FittingRoomSecondCell";
        FittingRoomSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
        if (!cell) {
            NSArray *arrayXib = [[NSBundle mainBundle] loadNibNamed:@"FittingRoomSecondCell" owner:[FittingRoomSecondCell class] options:nil];
            cell = [arrayXib objectAt:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selsectButton.hidden = YES;
        }
        
        [cell configWithData:[self.dataList objectAt:indexPath.section] isFromAPI:YES];
        
        return cell;

}



#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 90;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 52;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 32)];
    [BGUtilUI drawLabelInView:view Frame:CGRectMake(15, 0, self.view.frame.size.width, 32) Font:[UIFont systemFontOfSize:14.0] Text:[self.dataList objectAt:section][@"shopName"] IsCenter:NO Color:[UIColor colorWithHex:333333 alpha:1]];
    
    [BGUtilUI drawLabelInView:view Frame:CGRectMake(490/2, 0, self.view.frame.size.width, 32) Font:[UIFont systemFontOfSize:14.0] Text:[NSString stringWithFormat:@"单号:%@",[self.dataList objectAt:section][@"appointmentNo"]] IsCenter:NO Color:[UIColor colorWithHex:0x919191 alpha:1]];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 52)];
    [BGUtilUI drawLabelInView:view Frame:CGRectMake(20, 0, 200, 32) Font:[UIFont systemFontOfSize:14.0] Text:[self.dataList objectAt:section][@"createDate"] IsCenter:NO Color:[UIColor colorWithHex:333333 alpha:1]];
    UILabel *label = [BGUtilUI drawLabelInView:view Frame:CGRectMake(0, 0, self.view.frame.size.width-15, 32) Font:[UIFont systemFontOfSize:14.0] Text:[NSString stringWithFormat:@"共%@件商品",[self.dataList objectAt:section][@"clothesCount"]] IsCenter:NO Color:[UIColor colorWithHex:333333 alpha:1]];
    label.textAlignment = 2;
    view.backgroundColor = [UIColor whiteColor];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 32, self.view.frame.size.width, 20)];
    view1.backgroundColor = [UIColor colorWithHex:0xf2f2f2 alpha:1];
    [view addSubview:view1];
    return view;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row == [self.ContentdataArrm count] - 2) {
    //        if ([self.fansData[@"pageInfo"][@"total"] integerValue] > [self.ContentdataArrm count]) {
    //            self.pageNumber ++;
    //            [self request:self.pageNumber];
    //        }
    //    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FittingRoomViewController *controller = [[FittingRoomViewController alloc] initWithNibName:@"FittingRoomViewController" bundle:nil];
    controller.appointmentID = [self.dataList objectAt:indexPath.section][@"appointmentID"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
