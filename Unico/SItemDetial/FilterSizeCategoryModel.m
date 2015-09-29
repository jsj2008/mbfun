//
//  FilterSizeCategoryModel.m
//  Wefafa
//
//  Created by Funwear on 15/9/8.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "FilterSizeCategoryModel.h"

@implementation FilterSizeCategoryModel
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (NSArray *)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        FilterSizeCategoryModel *model = [[FilterSizeCategoryModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
