//
//  SProductDetailModel.m
//  Wefafa
//
//  Created by Jiang on 8/2/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SProductDetailModel.h"

@implementation SProductDetailModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.tagArray = [SProductDetailTagModel modelArrayForDataArray:dict[@"tag"]];
//        if ([dict[@"items"] count] > 0) {
//            self.goodsDetailModel = [[MBGoodsDetailsModel alloc]initWithDictionary:dict[@"items"][0]];
//        }else{
//            self.isNoneData = YES;
//        }
        if ([[dict allKeys]containsObject:@"clsInfo"]) {
            self.goodsDetailModel = [[MBGoodsDetailsModel alloc]initWithDictionary:dict];
        }else{
            self.isNoneData = YES;
        }
        
        if ([dict[@"activity"] count] > 0) {
            self.activtiyArray = [SProductDetailActivityModel modelArrayForDataArray:dict[@"activity"]];
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

- (void)setSizeList:(NSArray *)sizeList{
    
    if (!sizeList || sizeList.count == 0) return;
    NSString *string = sizeList[0][@"sizE_JSON"];
    // 判断sizeList[0][@"sizE_JSON"]类型是否NULL
    if ([string isKindOfClass:[NSNull class]]) {
        _sizeList = @[];
        return ;
    }
    if ([sizeList[0][@"sizE_JSON"] isKindOfClass:[NSArray class]]) {
        _sizeList = sizeList[0][@"sizE_JSON"];
        return;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    _sizeList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

@end

@implementation SProductDetailTagModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SProductDetailTagModel *model = [[SProductDetailTagModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

@end

@implementation SProductDetailActivityModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SProductDetailActivityModel *model = [[SProductDetailActivityModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

@end
