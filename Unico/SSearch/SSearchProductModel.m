//
//  SSearchProductModel.m
//  Wefafa
//
//  Created by unico_0 on 6/6/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SSearchProductModel.h"

@implementation SSearchProductModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        if ([[dict class] isSubclassOfClass:[NSNull class]]) {
            return self;
        }
        [self setValuesForKeysWithDictionary:dict];
        if (dict[@"market_price"]) {
            self.price = dict[@"market_price"];
            self.sale_price = dict[@"price"];
        }
        if ([_price isKindOfClass:[NSString class]]) {
            _price = @([_price floatValue]);
        }
        if ([_sale_price isKindOfClass:[NSString class]]) {
            _sale_price = @([_sale_price floatValue]);
        }
        _sale_price = _sale_price? _sale_price: _price;
        
        if (dict[@"brand_code"]) {
            _brandCode=dict[@"brand_code"];
        }
        if (dict[@"id"]) {
            _ID=dict[@"id"];
        }
    }
    return self;
}

- (void)setProdClsTag:(NSMutableArray *)prodClsTag{
    _prodClsTag = [SSearchProductShowTagModel modelArrayForDataArray:prodClsTag];
}

+ (NSMutableArray *)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        [array addObject:[[SSearchProductModel alloc]initWithDictionary:dict]];
    }
    return array;
}

+ (NSMutableArray *)modelArrayForCategaryDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SSearchProductModel *model = [[SSearchProductModel alloc]initWithDictionary:dict[@"clsInfo"]];
        model.prodClsTag = dict[@"prodClsTag"];
        if (model.aID) {
            [array addObject:model];
        }
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }else if ([key isEqualToString:@"product_url"]){
        self.mainImage = value;
    }else if ([key isEqualToString:@"product_name"]){
        self.name = value;
    }else if ([key isEqualToString:@"product_sys_code"]){
        self.code= value;
    }
}

@end

@implementation SSearchProductShowTagModel

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
        [array addObject:[[SSearchProductShowTagModel alloc]initWithDictionary:dict]];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}

@end
