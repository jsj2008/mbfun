//
//  SHomeAgilityModel.m
//  Wefafa
//
//  Created by unico_0 on 7/9/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SHomeAgilityModel.h"

@implementation SHomeAgilityModel

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
        SHomeAgilityModel *model = [[SHomeAgilityModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setConfig:(NSMutableArray *)config{
    _config = [SHomeAgilityConfigModel modelArrayForDataArray:config];
}

@end

@implementation SHomeAgilityConfigModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SHomeAgilityConfigModel *model = [[SHomeAgilityConfigModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setJump:(NSDictionary *)jump{
    _jump = [[SHomeAgilityJumpModel alloc]initWithDictionary:jump];
}

@end

@implementation SHomeAgilityJumpModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.dict = dict;
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}

@end
