//
//  MyShoppingTrollyViewController.h
//  Wefafa
//
//  Created by mac on 14-9-2.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShoppingTrollyGoodsTableViewCell.h"
#import "MyShoppingTrollyGoodsTableHeaderView.h"

@interface MyShoppingTrollyViewController : SBaseViewController/*UIViewController*/<MyShoppingTrollyGoodsClickDelegate,MyShoppingTrollyGoodsTableHeaderViewDelegate>
{
    int cellheight;
   
    int VIEWHEIGHT;
    int TABLE_HEADER_HEIGHT;

    BOOL isShowEditButton;
}
@property (weak, nonatomic)     IBOutlet UIView *bottom_showView;           //controller下方 统计购物信息的view
@property (strong, nonatomic)   IBOutlet UIButton *btnPay;                  //立即购买
@property (strong, nonatomic)   IBOutlet UITableView *tvShoppingTrolly;     //物品列表
@property (weak, nonatomic)     IBOutlet UILabel *SelectLb;                 //全选
@property (strong, nonatomic)   IBOutlet UILabel *lbSum;                    //商品合计金额
@property (strong, nonatomic)   IBOutlet UIButton *btnSelectedAll;          //全选btn
@property (weak, nonatomic)     IBOutlet UILabel *lbTrans;                  //不含运费

@property (weak, nonatomic)     IBOutlet UIView *shoppingTrollyNilView;         //购物篮为空时显示用view
@property (weak, nonatomic)     IBOutlet UIImageView *shoppimgTrollyNil;        //购物
@property  (strong,nonatomic)   MyShoppingTrollyGoodsData *shTrGoodsData;       //每个商品的cell
@property (strong,nonatomic)    NSMutableArray *goodsArray;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnPayClick:(id)sender;
- (IBAction)btnSelectedAll:(id)sender;

/** 
    关于数据
 */
//放NSNumber类型的数组
@property (nonatomic, strong) NSArray *itemAry;
@property (nonatomic, strong) NSMutableArray *contentModelArray;

@end
