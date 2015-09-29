//
//  SMessageBannerModel.m
//  Wefafa
//
//  Created by wave on 15/7/30.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMessageBannerModel.h"

@implementation SMessageBannerModel

- (instancetype) initWithDic:(NSDictionary*)dic {
    if (self == [super init]) {
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
