//
//  SDiscoveryPicAndTextModel.m
//  Wefafa
//
//  Created by metesbonweios on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SDiscoveryPicAndTextModel.h"

@implementation SDiscoveryPicTConfigerModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}
-(void)setConfig:(NSMutableArray *)config
{
    _config = [SDiscoveryPicAndTextModel modelArrayForDataArray:config];
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SDiscoveryPicTConfigerModel *model = [[SDiscoveryPicTConfigerModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

@end

@implementation SDiscoveryPicAndTextModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SDiscoveryPicAndTextConfigModel *model = [[SDiscoveryPicAndTextConfigModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}
@end

@implementation SDiscoveryPicAndTextConfigModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {

        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SDiscoveryPicAndTextConfigModel *model = [[SDiscoveryPicAndTextConfigModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}
@end
