//
//  SAgilityHotCategoryModel.m
//  Wefafa
//
//  Created by Mr_J on 15/8/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SAgilityHotCategoryModel.h"

@implementation SAgilityHotCategoryModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
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

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SAgilityHotCategoryModel *model = [[SAgilityHotCategoryModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

@end
