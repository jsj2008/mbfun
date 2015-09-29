//
//  SMBNewActivityListModel.m
//  Wefafa
//
//  Created by metesbonweios on 15/8/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMBNewActivityListModel.h"

@implementation SMBNewActivityListModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableArray *)modelArrayForDataArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SMBNewActivityListModel *model = [[SMBNewActivityListModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.idStr = value;
    }
}
@end
