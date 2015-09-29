//
//  SMyTopicPicModel.m
//  Wefafa
//
//  Created by wave on 15/7/22.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMyTopicPicModel.h"

@implementation SMyTopicPicModel    //照片model
- (instancetype)initWithDic:(NSDictionary*)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.aid = value;
    }
}

@end
