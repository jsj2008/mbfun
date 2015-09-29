//
//  ProductModel.m
//  Wefafa
//
//  Created by wave on 15/8/5.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "ProductModel.h"

@implementation clsInfo

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _aid = value;
    }
}

@end

@implementation colorList

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"picUrls"]) {
        [_picUrls_Array addObject:value];
    }
}

@end


@implementation prodClsTag

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _aid = value;
    }
}

@end

@implementation ProductModel
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self == [super init]) {
        _colorList_array = [NSMutableArray new];
        _prodClsTag_array = [NSMutableArray new];
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"clsInfo"]) {
        _cls_info = [[clsInfo alloc] initWithDic:value];
    }else if ([key isEqualToString:@"colorList"]) {
        for (NSDictionary *dictionary in value) {
            colorList *model = [[colorList alloc] initWithDic:dictionary];
            [_colorList_array addObject:model];
        }
    }else if ([key isEqualToString:@"prodClsTag"]) {
        for (NSDictionary *dictionary in value) {
            prodClsTag *model = [[prodClsTag alloc]initWithDic:dictionary];
            [_prodClsTag_array addObject:model];
        }
    }
}

@end
