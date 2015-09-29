//
//  SActivityReceiveModel.m
//  Wefafa
//
//  Created by unico_0 on 6/9/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SActivityReceiveModel.h"

@implementation SActivityReceiveModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SActivityReceiveModel *model = [[SActivityReceiveModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setBatchInfoList:(NSArray *)batchInfoList{
    _batchInfoList = [SActivityReceiveBatchModel modelArrayForDataArray:batchInfoList];
}

- (void)setPromoInfo:(NSDictionary *)promoInfo{
    _promoInfo = [[SActivityReceivePromoInfoModel alloc]initWithDictionary:promoInfo];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.idStr = value;
    }
}
-(void)setVouchersList:(NSArray *)vouchersList
{
    _vouchersList = [SActivityVouchersListModel modelArrayForDataArray:vouchersList];
    
}
-(void)setProductList:(NSArray *)productList
{
    _productList = [SActivityProductListModel modelArrayForDataArray:productList];
    
}
@end

@implementation SActivityReceivePromoInfoModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SActivityReceivePromoInfoModel *model = [[SActivityReceivePromoInfoModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setBeG_TIME:(NSString *)beG_TIME{
    _beG_TIME = [self getDate:beG_TIME];
    
}

- (void)setEnD_TIME:(NSString *)enD_TIME{
    _enD_TIME = [self getDate:enD_TIME];
}

- (NSString*)getDate:(NSString*)string{
    NSString *dateString = @"";
    if (string.length>1 && [[string substringToIndex:1] isEqualToString:@"/"])
    {
        NSArray *arr=[string componentsSeparatedByString:@"/Date("];
        NSString *s=[arr lastObject];
        arr=[s componentsSeparatedByString:@")/"];
        
        s=[arr firstObject];
        arr=[s componentsSeparatedByString:@"-"];
        s=[arr firstObject];
        NSDate *date =[NSDate dateWithTimeIntervalSince1970:[s longLongValue]/1000];
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy.MM.dd"];
        dateString = [NSString stringWithFormat:@"%@",[format stringFromDate:date]];
        
    }
    return dateString;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}

@end
@implementation SActivityVouchersListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SActivityVouchersListModel *model = [[SActivityVouchersListModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}
@end
@implementation SActivityProductListModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        if ([dict isKindOfClass:[NSString class]]) {
            NSLog(@"你大爷的配置错了3");
            
            return self;
        }
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SActivityProductListModel *model = [[SActivityProductListModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}
@end
