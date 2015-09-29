//
//  OrderRedPacketModel.m
//  Wefafa
//
//  Created by metesbonweios on 15/6/6.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "OrderRedPacketModel.h"

@implementation OrderRedPacketModel
-(instancetype)initWitDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
    
}
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        OrderRedPacketModel *model = [[OrderRedPacketModel alloc]initWitDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setCouponuserFilterList:(NSDictionary *)couponuserFilterList{
    _couponuserFilterList = [[MyRedPacketModel alloc]initWitDictionary:couponuserFilterList];
 
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.idStr = value;
    }
}

//- (void)setCouponuserFilterList:(NSDictionary *)couponuserFilterList{
//    
//    [self setValuesForKeysWithDictionary:couponuserFilterList];
//}


@end
