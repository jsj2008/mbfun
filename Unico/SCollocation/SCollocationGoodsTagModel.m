//
//  SCollocationGoodsTagModel.m
//  Wefafa
//
//  Created by unico_0 on 6/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SCollocationGoodsTagModel.h"

@implementation SCollocationGoodsTagModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        self.dict = dict;
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
//打开去重
        SCollocationGoodsTagModel *model = [[SCollocationGoodsTagModel alloc]initWithDictionary:dict];
//        int count = 0;
//        if (!model.attributes.code || model.attributes.code.length <=0){
//            [array addObject:model];
//            continue;
//        }
//        for (SCollocationGoodsTagModel *tagModel in array) {
//            if ([tagModel.attributes.code isEqualToString:model.attributes.code]) {
//                count ++;
//            }
//        }
//        if (count == 0) {
            [array addObject:model];
//        }
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setAttributes:(NSDictionary *)attributes{
    _attributes = [[SCollocationTagAttribute alloc]initWithDictionary:attributes];
}

@end

@implementation SCollocationTagAttribute

- (instancetype)initWithDictionary:(NSDictionary*)dict
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

@end