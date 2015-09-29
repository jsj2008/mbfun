//
//  SCollocationSubProductMode.m
//  Wefafa
//
//  Created by Mr_J on 15/9/8.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SCollocationSubProductModel.h"
#import "SSearchProductModel.h"

@implementation SCollocationSubProductModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SCollocationSubProductModel *model = [[SCollocationSubProductModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setIsSelected:(BOOL)isSelected{
    if (self.product.stock_num.intValue <= 0 || self.product.status.intValue != 2) {
        return;
    }
    if (_product_code.length && _product_code.length > 0) {
        _isSelected = isSelected;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}

- (void)setProduct:(NSDictionary*)product{
    _product = [[SCollocationSubProductInfoModel alloc]initWithDictionary:product];
}

@end

@implementation SCollocationSubProductInfoModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SCollocationSubProductInfoModel *model = [[SCollocationSubProductInfoModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setProdClsTag:(NSMutableArray *)prodClsTag{
    _prodClsTag = [SSearchProductShowTagModel modelArrayForDataArray:prodClsTag];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

@end