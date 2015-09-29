//
//  MBGoodsDetailsModel.m
//  Wefafa
//
//  Created by Jiang on 5/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBGoodsDetailsModel.h"
#import "MBAddShoppingProductInfoModel.h"

@implementation MBGoodsDetailsModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        _goodsNumber = 1;
        _colorSelectedIndex = -1;
        _sizeSelectedId = -1;
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableArray *)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        [array addObject:[[MBGoodsDetailsModel alloc]initWithDictionary:dict]];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setClsInfo:(NSDictionary *)clsInfo{
    _clsInfo = [[MBGoodsDetailsInfoModel alloc]initWithDictionary:clsInfo];
}

- (void)setClsPicUrl:(NSArray *)clsPicUrl{
    _clsPicUrl = [MBGoodsDetailsPictureModel modelArrayForDataArray:clsPicUrl];
}

- (void)setCommonCountTotal:(NSDictionary *)commonCountTotal{
    _commonCountTotal = [[MBUserStatisticsFilterList alloc]initWithDictionary:commonCountTotal];
}

- (void)setColorList:(NSArray *)colorList{
    _colorList = [MBGoodsDetailsColorModel modelArrayForDataArray:colorList];
}

- (void)setSpecList:(NSArray *)specList{
    _specList = [MBGoodsDetailesSpecModel modelArrayForDataArray:specList];
}
//-(void)setActivity:(NSArray *)activity
//{
//    _activity = [MBGoodsDetailesSpecModel modelArrayForDataArray:activity];
//    
//}
- (void)setStockList:(NSArray *)stockList{
    _stockList = stockList;
    for (MBGoodsDetailesSpecModel *sizeModel in _specList) {
        NSMutableArray *array = [NSMutableArray array];
        for (MBAddShoppingProductInfoModel *stockModel in stockList) {
            if (stockModel.speC_ID.intValue == sizeModel.code.intValue) {
                [array addObject:stockModel];
            }
        }
        sizeModel.stockList = array;
    }
    
    for (MBGoodsDetailsColorModel *colorModel in _colorList) {
        NSMutableArray *array = [NSMutableArray array];
        for (MBAddShoppingProductInfoModel *stockModel in stockList) {
            if (stockModel.coloR_ID.intValue == colorModel.code.intValue) {
                [array addObject:stockModel];
            }
        }
        colorModel.stockList = array;
    }
}

@end
