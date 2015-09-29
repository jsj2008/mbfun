//
//  SAgilitySpaceModel.m
//  Wefafa
//
//  Created by Mr_J on 15/8/30.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SAgilitySpaceModel.h"

@implementation SAgilitySpaceModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SAgilitySpaceModel *model = [[SAgilitySpaceModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

@end
