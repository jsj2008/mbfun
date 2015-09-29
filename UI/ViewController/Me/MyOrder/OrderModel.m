//
//  OrderModel.m
//  Wefafa
//
//  Created by fafatime on 15-1-28.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "OrderModel.h"
#import "Utils.h"

@implementation OrderModelPromListInfo

- (id)initWithInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        
        OrderModelPromListInfo *model = [[OrderModelPromListInfo alloc]initWithInfo:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation OrderModelProdListInfo

- (id)initWithInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        
        OrderModelProdListInfo *model = [[OrderModelProdListInfo alloc]initWithInfo:dict];
        [array addObject:model];
        
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

@implementation OrderModelReturnInfoListInfo
- (id)initWithInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        OrderModelReturnInfoListInfo *model = [[OrderModelReturnInfoListInfo alloc]initWithInfo:dict];
        [array addObject:model];
    }
    return array;
}
-(void)setProdList:(NSArray *)prodList
{
    _prodList = [OrderModelProdListInfo modelArrayForDataArray:prodList];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.idStr = value;
    }
//    if ([key isEqualToString:@"prodList"]) {
//
//        self.prodList = [NSArray arrayWithArray:[OrderModelProdListInfo modelArrayForDataArray:value]];
//    }
}
@end

@implementation OrderModelRefundProdDtlListInfo
- (id)initWithInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        OrderModelRefundProdDtlListInfo *model = [[OrderModelRefundProdDtlListInfo alloc]initWithInfo:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation OrderModelRefundAppInfoListInfo
//@synthesize statusName,status,stateName,state;

- (id)initWithInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
//        self.state = [NSString stringWithFormat:@"%@",dict[@"state"]];
//        self.stateName=[NSString stringWithFormat:@"%@",dict[@"stateName"]];
//        self.status= [NSString stringWithFormat:@"%@",dict[@"status"]];
//        self.statusName= [NSString stringWithFormat:@"%@",dict[@"statusName"]];
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        OrderModelRefundAppInfoListInfo *model = [[OrderModelRefundAppInfoListInfo alloc]initWithInfo:dict];
        [array addObject:model];
    }
    return array;
}
-(void)setRefundProdDtlList:(NSArray *)refundProdDtlList
{
    _refundProdDtlList = [OrderModelRefundProdDtlListInfo modelArrayForDataArray:refundProdDtlList];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.idStr = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.descriptionStr = value;
    }
//    if ([key isEqualToString:@"state"]) {
//       
//    }
}
@end

@implementation OrderModelPaymentListInfo

- (id)initWithInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        OrderModelPaymentListInfo *model = [[OrderModelPaymentListInfo alloc]initWithInfo:dict];
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

@implementation OrderModelOperationInfo
- (id)initWithInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        OrderModelOperationInfo *model = [[OrderModelOperationInfo alloc]initWithInfo:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation OrderModelProductInfo
- (id)initWithInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        OrderModelProductInfo *model = [[OrderModelProductInfo alloc]initWithInfo:dict];
        [array addObject:model];
    }
    return array;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.idStr = value;
    }
    if ([key isEqualToString:@"description"]) {
        //        self.descriptionStr = value;
    }
}
@end

@implementation OrderModelProductListInfo

- (id)initWithInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}
-(void)setProductInfo:(NSDictionary *)productInfo
{
    _productInfo = [[OrderModelProductInfo alloc]initWithInfo:productInfo];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
@end

@implementation OrderModelDetailInfo
- (id)initWithInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        OrderModelDetailInfo *model = [[OrderModelDetailInfo alloc]initWithInfo:dict];
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

@implementation OrderModelDetailListInfo

- (id)initWithInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        OrderModelDetailListInfo *model = [[OrderModelDetailListInfo alloc]initWithInfo:dict];
        [array addObject:model];
    }
    return array;
}
-(void)setProudctList:(NSDictionary *)proudctList
{
    _proudctList =[[OrderModelProductListInfo alloc]initWithInfo:proudctList];
}
-(void)setDetailInfo:(NSDictionary *)detailInfo
{
    _detailInfo =  [[OrderModelDetailInfo alloc]initWithInfo:detailInfo];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
@end

@implementation OrderModel

-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
    
}

+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        OrderModel *model = [[OrderModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setDetailList:(NSArray *)detailList{
    _detailList = [OrderModelDetailListInfo modelArrayForDataArray:detailList];
}

- (void)setOperationInfoList:(NSArray *)operationInfoList{
    _operationInfoList= [OrderModelOperationInfo modelArrayForDataArray:operationInfoList];
}
-(void)setPaymentList:(NSArray *)paymentList
{
    _paymentList= [OrderModelPaymentListInfo modelArrayForDataArray:paymentList];
}
-(void)setRefundAppInfoList:(NSArray *)refundAppInfoList
{
    _refundAppInfoList = [OrderModelRefundAppInfoListInfo modelArrayForDataArray:refundAppInfoList];
}
-(void)setReturnInfoList:(NSArray *)returnInfoList
{
    _returnInfoList = [OrderModelReturnInfoListInfo modelArrayForDataArray:returnInfoList];
}
-(void)setPromList:(NSArray *)promList
{
    _promList =  [OrderModelPromListInfo modelArrayForDataArray:promList];
}
-(void)setProdList:(NSArray *)prodList
{
      _prodList = [OrderModelProdListInfo modelArrayForDataArray:prodList];
}
-(void)setRefundProdDtlList:(NSArray *)refundProdDtlList
{
    _refundProdDtlList=[OrderModelRefundProdDtlListInfo modelArrayForDataArray:refundProdDtlList];
    
}
//找不到的时候  纠错
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.idStr = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.descriptionStr=value;
    }
//    if ([key isEqualToString:@"detailList"]) {
//        
//    }
//    if ([key isEqualToString:@"operationInfoList"]) {
//        
//    }
//    if ([key isEqualToString:@"paymentList"]) {
//        self.paymentList=[NSArray arrayWithArray:[OrderModelPaymentListInfo modelArrayForDataArray:value]];
//    }
//    if ([key isEqualToString:@"refundAppInfoList"]) {
//        self.refundAppInfoList = [NSArray arrayWithArray:[OrderModelRefundAppInfoListInfo modelArrayForDataArray:value]];
//    }
//    if ([key isEqualToString:@"returnInfoList"]) {
//        self.returnInfoList =  [NSArray arrayWithArray:[OrderModelReturnInfoListInfo modelArrayForDataArray:value]];
//    }
//    if ([key isEqualToString:@"promList"]) {
//        self.promList =  [NSArray arrayWithArray:[OrderModelPromListInfo modelArrayForDataArray:value]];
//    }

}
@end
