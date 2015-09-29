//
//  MBCreateGoodsOrderViewController.h
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBCreateGoodsOrderViewController : SBaseViewController/*UIViewController*/
{
    double amount;
    int count;
    double disamount;
    double summery;

    double originalAmount;
    NSMutableArray *orderInfoArray;
    NSArray *titlearray;
    int invo_index;
}

@property (strong, nonatomic) IBOutlet UIView *viewHead;
@property (strong, nonatomic) IBOutlet UITableView *tvOrder;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;

//以下必须调用者Controller传入
@property (strong, nonatomic) NSMutableArray *goodsArray; //订单商品
@property (strong, nonatomic) NSDictionary *sumInfo; //订单合计信息
@property (weak, nonatomic) IBOutlet UILabel *lbSumAndCount;
@property (strong, nonatomic) NSString *totalMoney;//判断是否隐藏发票一栏。
- (IBAction)btnPayClick:(id)sender;
-(void)payAlimentResult:(id)resultd;

@end
