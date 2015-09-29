//
//  SMenuBottomModel.m
//  Wefafa
//
//  Created by Funwear on 15/8/30.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMenuBottomModel.h"

@implementation SMenuBottomModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}

- (void)setButton_config:(NSString *)button_config{
    NSData *data = [button_config dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    _button_config = [[SMenuLayoutButtonConfigModel alloc]initWithDictionary:dictionary];
}

@end

@implementation SMenuLayoutButtonConfigModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end