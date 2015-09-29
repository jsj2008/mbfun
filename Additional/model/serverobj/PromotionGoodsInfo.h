//
//  PromotionGoodsInfo.h
//  Wefafa
//
//  Created by Miaoz on 15/3/6.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
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
               ]
 */
@interface PromotionGoodsInfo : NSObject
//优惠价格
@property(nonatomic,strong)NSString *diS_AMOUNT;
@property(nonatomic,strong)NSString *collocatioN_ID;
@property(nonatomic,strong)NSString *proD_ID;
@property (nonatomic,strong)NSString *promName;
@property (nonatomic,strong)NSString *promotionId;

//优惠后价格
@property(nonatomic,strong)NSString *amount;
@end
