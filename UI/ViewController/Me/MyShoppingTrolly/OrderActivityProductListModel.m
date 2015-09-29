//
//  OrderActivityProductListModel.m
//  Wefafa
//
//  Created by metesbonweios on 15/9/1.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "OrderActivityProductListModel.h"

@implementation OrderActivityProductListModel

-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+(NSArray *)modelDataWithArray:(NSArray *)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        OrderActivityProductListModel *model = [[OrderActivityProductListModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
