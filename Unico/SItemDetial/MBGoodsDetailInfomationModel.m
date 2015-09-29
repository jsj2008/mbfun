//
//  MBGoodsDetailInfomationModel.m
//  Wefafa
//
//  Created by Jiang on 5/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBGoodsDetailInfomationModel.h"

@implementation MBGoodsDetailInfomationModel

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
        [array addObject:[[MBGoodsDetailInfomationModel alloc]initWithDictionary:dict]];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}

@end
