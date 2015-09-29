//
//  SMyTopicHeadModel.m
//  Wefafa
//
//  Created by wave on 15/7/22.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMyTopicHeadModel.h"

@implementation UserInfo

- (instancetype)initWithDic:(NSDictionary*)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation SMyTopicHeadModel

- (instancetype)initWithDic:(NSDictionary*)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"userInfo"]) {
        _userinfo = [[UserInfo alloc]initWithDic:value];
    }
}

@end
