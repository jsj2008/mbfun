//
//  PlatFormBasicInfo.m
//  Wefafa
//
//  Created by Miaoz on 15/6/5.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "PlatFormBasicInfo.h"
#import "OrderActivityProductListModel.h"

@implementation PlatFormBasicInfo
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+(NSArray *)modelDataArrayWithArray:(NSArray *)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        PlatFormBasicInfo *model = [[PlatFormBasicInfo alloc]initWithDic:dict];
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
- (void)setProductList:(NSArray *)productList{
    _productList = [OrderActivityProductListModel modelDataWithArray:productList];
    
}
@end

@implementation ProductListModel

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
        ProductListModel *model = [[ProductListModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

@end

@implementation ActivityOrderModel

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
        ActivityOrderModel *model = [[ActivityOrderModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.idStr = value;
    }

}
@end
