//
//  MBAddShoppingProductInfoModel.m
//  Wefafa
//
//  Created by su on 15/5/15.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MBAddShoppingProductInfoModel.h"

@implementation MBAddShoppingProductInfoModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        _dictionaryValue = dict;
        [self setValue:[NSNumber numberWithInteger:1] forKey:@"goodnumber"];
        [self setValue:[NSNumber numberWithBool:YES] forKey:@"isSelectedCurrent"];
        [self setValue:@NO forKey:@"isColorSelected"];
        [self setValue:@NO forKey:@"isSizeSelected"];
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableArray *)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        if([[dict allKeys] containsObject:@"productInfo"])
        {
            [array addObject:[[MBAddShoppingProductInfoModel alloc] initWithDictionary:dict[@"productInfo"]]];
        }
        else
        {
             [array addObject:[[MBAddShoppingProductInfoModel alloc]initWithDictionary:dict]];
        }
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}



@end
