//
//  MyRedPacketModel.m
//  Wefafa
//
//  Created by metesbonweios on 15/6/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MyRedPacketModel.h"

@implementation MyRedPacketModel
- (instancetype)initWitDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        MyRedPacketModel *model = [[MyRedPacketModel alloc]initWitDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
//        self.idValue = value;
    }
    if ([key isEqualToString:@"description"]) {
//        self.descriptionStr = value;
    }
}
@end
