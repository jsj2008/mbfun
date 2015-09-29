//
//  SSortBrandByLetterModel.m
//  Wefafa
//
//  Created by lizhaoxiang on 15/6/9.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SSortBrandByLetterModel.h"

@implementation SSortBrandByLetterModel
- (instancetype)initWithDic:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"brandInfo"]) {
        NSMutableArray * temArr = [[NSMutableArray alloc]init];
        [((NSArray*)value) enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SSortBrandByLetterSubModel *model = [[SSortBrandByLetterSubModel alloc]sortBrandWithDic:(NSDictionary*)obj];
            [temArr addObject:model];
        }];
        self.brandInfo_array = temArr ;
    }
}
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SSortBrandByLetterModel *model = [[SSortBrandByLetterModel alloc]initWithDic:dict];
        [array addObject:model];
    }
    return array;
}
@end



@implementation SSortBrandByLetterSubModel
- (instancetype)sortBrandWithDic:(NSDictionary*)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"id"]){
        self.idStr = value;
    }
}
@end

@implementation SNewSortBrandByLetterSubModel

- (instancetype)sortBrandWithDic:(NSDictionary*)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"id"]){
        self.aId = value;
    }
    if([key isEqualToString:@"description"]){
        self.aDescription = value;
    }

}
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SNewSortBrandByLetterSubModel *model = [[SNewSortBrandByLetterSubModel alloc]sortBrandWithDic:dict];
        [array addObject:model];
    }
    return array;
}
@end