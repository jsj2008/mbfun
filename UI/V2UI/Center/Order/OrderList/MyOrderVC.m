//
//  MyOrderVC.m
//  Designer
//
//  Created by Juvid on 15/1/15.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "MyOrderVC.h"
#import "MyOrderVCCell.h"
#import "GeneralVCCell.h"
#import "OrderDetailVC.h"
#import "MyOrderLastCell.h"
#import "LogisticsTrackingController.h"
#import "AppraiseViewController.h"
@interface MyOrderVC ()<MyOrderLastDelegate,UIActionSheetDelegate>{
    UIView *vieLine;
}

@end

@implementation MyOrderVC
@synthesize orderStatus;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的订单";
    [self SetLineSelect];
//    self.tableView.estimatedRowHeight=90;
//    [arrMl exchangeObjectAtIndex:3 withObjectAtIndex:1];
    
    ;
    // Do any additional setup after loading the view from its nib.
}
-(void)SetLineSelect{
    vieLine=[[UIView alloc]initWithFrame:CGRectMake(orderStatus*(WINDOWW/5), self.vieHead.frame.size.height-3, WINDOWW/5, 3)];
    vieLine.backgroundColor=DEFAULTCOLOR;
    [self.vieHead addSubview:vieLine];
//    竖线
    for (int i=1; i<5; i++) {
        UIView *verticalLine=[[UIView alloc]initWithFrame:CGRectMake(i*(WINDOWW/5), (self.vieHead.frame.size.height-15)/2, 1, 15)];
        verticalLine.backgroundColor=[UIColor lightGrayColor];
        [self.vieHead addSubview:verticalLine];
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        static NSString *CellIdentifier=@"MyOrderVCCell";
        MyOrderVCCell *cell = (MyOrderVCCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MyOrderVCCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
        
    }
    else if(indexPath.row==0){
        static NSString *CellIdentifier=@"GeneralVCCell";
        GeneralVCCell *cell = (GeneralVCCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[GeneralVCCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
       
        [cell OrderStatus:self.orderStatus];
        return cell;
    }
    else {
        static NSString *CellIdentifier=@"MyOrderLastCell";
        MyOrderLastCell *cell = (MyOrderLastCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MyOrderLastCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate=self;
        }
        if(indexPath.row==2){
            cell.labLeft.text=@"共一件商品  实付：￥50";
        }
        else{
            
        }
        [cell OrderStatus:self.orderStatus];
      
        return cell;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        return 90;
    }
    return 32;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row== 1){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        OrderDetailVC *orderDetail=[[OrderDetailVC alloc]init];
        orderDetail.orderStatus=self.orderStatus;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//订单状态变化，下划线位置发生相应变化
- (IBAction)PressStatus:(UIButton *)sender {
    vieLine.frame=CGRectMake(CGRectGetMinX(sender.frame), vieLine.frame.origin.y, vieLine.frame.size.width, vieLine.frame.size.height);
    self.orderStatus=sender.tag;
    [self.tableView reloadData];
}


-(void)PressBtnTitle:(NSString *)str{
    if ([str isEqualToString:@"去付款"]) {
        UIActionSheet *actionSheet=[DetectionSystem PayForView:self.view];
        actionSheet.delegate=self;
    }
    if ([str isEqualToString:@"查看物流"]) {
        LogisticsTrackingController *logisticsTrack=[[LogisticsTrackingController alloc]init];
        [self.navigationController pushViewController:logisticsTrack animated:YES];
    }
    if ([str isEqualToString:@"评价订单"]) {
        AppraiseViewController *appraiseVc=[[AppraiseViewController alloc]init];
        [self.navigationController pushViewController:appraiseVc animated:YES];
    }
    if ([str isEqualToString:@"确认收货"]) {
        
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
