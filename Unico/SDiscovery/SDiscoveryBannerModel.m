//
//  SDiscoveryBannerModel.m
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryBannerModel.h"

@implementation SDiscoveryBannerModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _dict = dict;
        [self setValuesForKeysWithDictionary:dict];
        if (dict[@"jump"]) {
            [self setValuesForKeysWithDictionary:dict[@"jump"]];
        }
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
        SDiscoveryBannerModel *model = [[SDiscoveryBannerModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

@end
