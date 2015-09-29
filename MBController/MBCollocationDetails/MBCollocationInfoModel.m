//
//  MBCollocationInfoModel.m
//  Wefafa
//
//  Created by Jiang on 5/6/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBCollocationInfoModel.h"

@implementation MBCollocationInfoModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableArray *)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        [array addObject:[[MBCollocationInfoModel alloc]initWithDictionary:dict]];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.aDescription = value;
    }
}

@end
