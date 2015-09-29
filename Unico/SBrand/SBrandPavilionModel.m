//
//  SBrandPavilionModel.m
//  Wefafa
//
//  Created by metesbonweios on 15/8/19.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBrandPavilionModel.h"

@implementation SBrandPavilionModel
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (NSArray *)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        [array addObject:[[SBrandPavilionModel alloc]initWithDic:dict]];
    }
    return array;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _idStr = value;
    }
}
-(void)setBrand_list:(NSArray *)brand_list
{
    _brand_list = [BrandListModel modelArrayForDataArray:brand_list];
    
}
-(void)setBanner:(NSArray *)banner
{
    _banner = [BrandListModel modelArrayForDataArray:banner];
}

-(void)setFixed_list:(NSArray *)fixed_list
{
    _fixed_list= [BrandListModel modelArrayForDataArray:fixed_list];
    
}
@end
@implementation BrandListModel
-(instancetype)initWithDic:(NSDictionary *)dic
{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (NSArray *)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        [array addObject:[[BrandListModel alloc]initWithDic:dict]];
    }
    return array;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _idStr = value;
    }
}
@end
