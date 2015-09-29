 //
//  SActivityListModel.m
//  Wefafa
//
//  Created by unico_0 on 6/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SActivityListModel.h"

@implementation SActivityListModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        if ([dict isKindOfClass:[NSString class]]) {
            NSLog(@"你大爷的配置错了2");
            
            return self;
        }
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableArray *)modelArrayForDataArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SActivityListModel *model = [[SActivityListModel alloc]initWithDictionary:dict];
        if (model.coupoN_FLAG.boolValue || model.promtionRangeDtlFilterLst.count > 0) {
            [array addObject:model];
        }
    }
    return array;
}

+ (NSMutableArray *)modelArrayForDataUnlimitedArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SActivityListModel *model = [[SActivityListModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setPromPlatComDtlFilterList:(NSArray *)promPlatComDtlFilterList{
    _promPlatComDtlFilterList = [SActivityPromPlatModel modelArrayForDataArray:promPlatComDtlFilterList];
}

- (void)setPromtionRangeDtlFilterLst:(NSArray *)promtionRangeDtlFilterLst{
    _promtionRangeDtlFilterLst = [SActivityPromtionRangeModel modelArrayForDataArray:promtionRangeDtlFilterLst];
}

- (void)setCollLst:(NSArray *)collLst{
    _collLst = [MBGoodsDetailListModel modelArrayForDataArray:collLst];
}

- (void)setProdClsLst:(NSArray *)prodClsLst{
    _prodClsLst = [MBGoodsDetailsModel modelArrayForDataArray:prodClsLst];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }else if([key isEqualToString:@"endTime"]){
        self.enD_TIME = [value copy];
    }
}

@end
