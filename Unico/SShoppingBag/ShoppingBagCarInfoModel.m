//
//  ShoppingBagCarInfoModel.m
//  Wefafa
//
//  Created by unico_0 on 15/5/25.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "ShoppingBagCarInfoModel.h"

@implementation ShoppingBagCarInfoModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
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

@end
