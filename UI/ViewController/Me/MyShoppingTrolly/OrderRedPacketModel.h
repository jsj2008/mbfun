//
//  OrderRedPacketModel.h
//  Wefafa
//
//  Created by metesbonweios on 15/6/6.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MyRedPacketModel.h"

@interface OrderRedPacketModel : MyRedPacketModel
@property (nonatomic,assign) BOOL canUse;
@property (nonatomic,strong) NSArray *prodLst;
//@property (nonatomic, strong) NSDictionary *couponuserFilterList;
@property (nonatomic,strong)MyRedPacketModel *couponuserFilterList;
@end
