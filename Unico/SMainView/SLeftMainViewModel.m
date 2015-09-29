//
//  SLeftMainViewModel.m
//  Wefafa
//
//  Created by wave on 15/8/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SLeftMainViewModel.h"

@implementation SLeftMainViewModel
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    [super setValue:value forUndefinedKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"iconJump"]) {
        self.iconJump = [[IconJump alloc] initWithDic:value];
        NSLog(@"IconJump value ======= %@", value);
        self.Icon_JumpDic = value;
    }else if ([key isEqualToString:@"jump"]) {
        self.jump = [[Jump alloc] initWithDic:value];
        NSLog(@"CellJump value ======= %@", value);
        self.JumpDic = value;
    }
}

@end


@implementation Jump
- (instancetype)initWithDic:(NSDictionary *)dic {
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

@implementation IconJump
- (instancetype)initWithDic:(NSDictionary *)dic {
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