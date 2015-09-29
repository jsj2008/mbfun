//
//  OrderDetailVC.m
//  Designer
//
//  Created by Juvid on 15/1/15.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "OrderDetailVC.h"
#import "MyOrderVCCell.h"
#import "GeneralVCCell.h"
#import "AppraiseViewController.h"
#import "UITableViewCell+OrderDetail.h"
#import "LogisticsTrackingController.h"
@interface OrderDetailVC ()<UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIView *vieTableFoot;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;

@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
- (IBAction)PressStatus:(UIButton *)sender;

@end

@implementation OrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"订单详情";
    [self SetBtnStaus];
//    self.tableView.tableFooterView=self.vieTableFoot;
    // Do any additional setup after loading the view from its nib.
}

-(void)SetBtnStaus{
    switch (self.orderStatus) {
        case 0:
            
            break;
        case 1:
           [self.btnLeft setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.btnRight setTitle:@"去付款" forState:UIControlStateNormal];
            break;
        case 2:
            self.vieTableFoot.hidden=YES;
            self.tableView.tableFooterView=nil;
            break;
        case 3:
            [self.btnLeft setTitle:@"查看物流" forState:UIControlStateNormal];
            [self.btnRight setTitle:@"确认收货" forState:UIControlStateNormal];
            break;
        case 4:
            [self.btnLeft setTitle:@"查看物流" forState:UIControlStateNormal];
            [self.btnRight setTitle:@"评价订单" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 2;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell setStartUI];
        return cell;
        
    }
    else if(indexPath.section==1) {
        static NSString *CellIdentifier=@"GeneralVCCell";
        GeneralVCCell *cell = (GeneralVCCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[GeneralVCCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row==0) {
            [cell SetLeftTitle:self.orderStatus];
            cell.labRight.text=@"订单时间：2015.01.01";
        }
        else{
            cell.labLeft.text=@"卖家：此号很拽";
            cell.labRight.text=@"共2件";
        }
        return cell;
    }
    else{
        static NSString *CellIdentifier=@"MyOrderVCCell";
        MyOrderVCCell *cell = (MyOrderVCCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MyOrderVCCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 102;
    }
    if (indexPath.section==1) {
        return 30;
    }
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppraiseViewController *appraiseVc=[[AppraiseViewController alloc]init];
    [self.navigationController pushViewController:appraiseVc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)PressStatus:(UIButton *)sender{
    if ([sender.currentTitle isEqualToString:@"去付款"]) {
        UIActionSheet *actionSheet=[DetectionSystem PayForView:self.view];
        actionSheet.delegate=self;
    }
    if ([sender.currentTitle isEqualToString:@"查看物流"]) {
        LogisticsTrackingController *logisticsTrack=[[LogisticsTrackingController alloc]init];
        [self.navigationController pushViewController:logisticsTrack animated:YES];
    }
    if ([sender.currentTitle isEqualToString:@"评价订单"]) {
        AppraiseViewController *appraiseVc=[[AppraiseViewController alloc]init];
        [self.navigationController pushViewController:appraiseVc animated:YES];
    }
    if ([sender.currentTitle isEqualToString:@"确认收货"]) {
        
    }

}
#pragma mark 付款方式选择
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //支付宝
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1) {
        //        微信支付
        
    }else if(buttonIndex == 2) {
        //        取消
        
    }
    
}
@end
