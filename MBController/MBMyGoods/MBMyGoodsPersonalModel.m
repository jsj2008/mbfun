//
//  MBMyGoodsPersonalModel.m
//  Wefafa
//
//  Created by Jiang on 4/2/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBMyGoodsPersonalModel.h"

@implementation MBMyGoodsPersonalModel

+ (NSMutableArray *)modelArrayWithDataArray:(NSArray *)dataArray{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        MBMyGoodsPersonalModel *model = [[MBMyGoodsPersonalModel alloc]initWithDictionary:dict];
        [modelArray addObject:model];
        
    }
    return modelArray;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    [super setValue:value forUndefinedKey:key];
    
    if ([key isEqualToString:@"favoriteCount"]) {
        self.favoritCount = value;
    }
    //喜欢的搭配。
    if ([key isEqualToString:@"collectionList"]) {
        NSArray *array = value;
        if (array.count == 0) {
            return;
        }
        NSDictionary *dictMain = [array firstObject];
        NSDictionary *collocationInfo = dictMain[@"collocationInfo"];
        NSArray *statisticsFilterList = dictMain[@"statisticsFilterList"];
        if ([statisticsFilterList count]>0 )
        {
            NSDictionary *statisticsFilterDic = dictMain[@"statisticsFilterList"][0];
            [self setValuesForKeysWithDictionary:statisticsFilterDic];
        }
        if ([[collocationInfo allKeys]count]>0) {
            self.pictureUrl = collocationInfo[@"pictureUrl"];
            self.isFavorite = collocationInfo[@"isFavorite"];
        }
    }
}

- (void)setCommonCountTotal:(NSDictionary *)commonCountTotal{
    _commonCountTotal = [[MBUserStatisticsFilterList alloc]initWithDictionary:commonCountTotal];
}

@end
