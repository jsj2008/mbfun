//
//  SActivityReceiveBatchModel.m
//  Wefafa
//
//  Created by unico_0 on 6/9/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SActivityReceiveBatchModel.h"

@implementation SActivityReceiveBatchModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SActivityReceiveBatchModel *model = [[SActivityReceiveBatchModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setCouponBatchBasicInfo:(NSDictionary *)couponBatchBasicInfo{
    _couponBatchBasicInfo = [[SActivityReceiveBatchInfoModel alloc]initWithDictionary:couponBatchBasicInfo];
}

- (void)setCouponRuleInfo:(NSDictionary *)couponRuleInfo{
    _couponRuleInfo = [[SActivityReceiveRuleInfoModel alloc]initWithDictionary:couponRuleInfo];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation SActivityReceiveRuleInfoModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SActivityReceiveRuleInfoModel *model = [[SActivityReceiveRuleInfoModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setCouponRuleDtlFilterList:(NSArray *)couponRuleDtlFilterList{
    _couponRuleDtlFilterList = couponRuleDtlFilterList;
}

- (void)setCouponRuleFilterList:(NSDictionary *)couponRuleFilterList{
    _couponRuleFilterList = [[SActivityReceiveRuleRuleFilterModel alloc]initWithDictionary:couponRuleFilterList];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end

@implementation SActivityReceiveRuleRuleFilterModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SActivityReceiveRuleRuleFilterModel *model = [[SActivityReceiveRuleRuleFilterModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }else if([key isEqualToString:@"description"]){
        self.aDescription = value;
    }
}

@end