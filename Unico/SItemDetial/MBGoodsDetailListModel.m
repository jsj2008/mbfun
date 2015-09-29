//
//  MBGoodsDetailListModel.m
//  Wefafa
//
//  Created by Jiang on 5/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBGoodsDetailListModel.h"
#import "MBGoodsDetailsModel.h"

@implementation MBGoodsDetailListModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSArray *)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        if (dict[@"proudctList"]) {
            [array addObject:[[MBGoodsDetailListModel alloc]initWithDictionary:dict]];
        }
    }
    return array;
}

- (void)setDetailInfo:(NSDictionary *)detailInfo{
    _detailInfo = [[MBGoodsDetailInfomationModel alloc]initWithDictionary:detailInfo];
}

- (void)setProudctList:(NSDictionary *)proudctList{
    _proudctList = [[MBGoodsDetailsModel alloc]initWithDictionary:proudctList];
}

@end
