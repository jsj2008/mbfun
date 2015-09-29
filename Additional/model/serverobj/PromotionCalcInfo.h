//
//  PromotionFeeCalcInfo.h
//  Wefafa
//
//  Created by Miaoz on 15/3/5.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PromotionGoodsInfo.h"
/*运费优惠
{
    "total" : 1,
    "results" : [
                 {
                     "promotioN_NAME" : "2.满99元免邮",
                     "diS_AMOUNT" : 6,
                     "promotioN_ID" : 72347,
                     "fee" : 0
                 }
                 ],
    "message" : "",
    "isSuccess" : true
}
 */
/*价格优惠
{
    "total" : 1,
    "results" : [
                 {
                     "promotioN_NAME" : "4.2件8折",
                     "diS_AMOUNT" : 1992,
                     "proD_LIST" : [
                                    {
                                        "diS_AMOUNT" : 1196,
                                        "collocatioN_ID" : 73465,
                                        "proD_ID" : 99903,
                                        "amount" : 4784
                                    },
                                    {
                                        "diS_AMOUNT" : 796,
                                        "collocatioN_ID" : 73465,
                                        "proD_ID" : 94099,
                                        "amount" : 3184
                                    }
                                    ],
                     "promotioN_ID" : 72349,
                     "amount" : 7968
                 }
                 ],
    "message" : "",
    "isSuccess" : true
}
*/
@interface PromotionCalcInfo : NSObject
@property(nonatomic,strong)NSString *promotioN_NAME;
//优惠额度
@property(nonatomic,strong)NSString *diS_AMOUNT;
@property(nonatomic,strong)NSString *promotioN_ID;
//运费优惠后
@property(nonatomic,strong)NSString *fee;
//价格优惠后
@property(nonatomic,strong)NSString *amount;
//价格优惠商品信息
@property(nonatomic,strong)NSMutableArray *promotionGoodsInfoList;

//字典里的值直接传给创建订单orderCreat参数 分两种1.运费优惠2.价格优惠
@property(nonatomic,strong)NSDictionary *postdic;

@end
