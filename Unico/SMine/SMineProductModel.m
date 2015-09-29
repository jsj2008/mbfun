//
//  SMineProductModel.m
//  Wefafa
//
//  Created by wave on 15/9/10.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMineProductModel.h"

@implementation Subs

- (instancetype)initWithDic:(NSDictionary*)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.aid = value;
    }else if ([key isEqualToString:@"subs"]) {
        NSMutableArray *ary = [NSMutableArray new];
        for (NSDictionary *dic in value) {
            Subs *sub = [[Subs alloc] initWithDic:dic];
            [ary addObject:sub];
        }
        self.subs_array = [ary mutableCopy];
    }
}

@end


@implementation SMineProductModel

- (instancetype)initWithDic:(NSDictionary*)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.aid = value;
    }else if ([key isEqualToString:@"subs"]) {
        NSMutableArray *ary = [NSMutableArray new];
        for (NSDictionary *dic in value) {
            Subs *sub = [[Subs alloc] initWithDic:dic];
            [ary addObject:sub];
        }
        self.subs_array = [ary mutableCopy];
    }
}

@end
