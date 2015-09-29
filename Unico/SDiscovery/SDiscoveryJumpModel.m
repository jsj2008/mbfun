//
//  SDiscoveryJumpModel.m
//  Wefafa
//
//  Created by unico_0 on 7/9/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryJumpModel.h"

@implementation SDiscoveryJumpModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _dict = dict;
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
        SDiscoveryJumpModel *model = [[SDiscoveryJumpModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

@end
