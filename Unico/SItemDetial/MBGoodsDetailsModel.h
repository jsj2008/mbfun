//
//  MBGoodsDetailsModel.h
//  Wefafa
//
//  Created by Jiang on 5/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBGoodsDetailsInfoModel.h"
#import "MBGoodsDetailsPictureModel.h"
#import "MBGoodsDetailsColorModel.h"
#import "MBGoodsDetailesSpecModel.h"
#import "MBUserStatisticsFilterList.h"
@class MBAddShoppingProductInfoModel;

@interface MBGoodsDetailsModel : NSObject

@property (nonatomic, strong) MBGoodsDetailsInfoModel *clsInfo;
@property (nonatomic, strong) MBUserStatisticsFilterList *commonCountTotal;
@property (nonatomic, strong) NSArray *clsPicUrl;
@property (nonatomic, strong) NSArray *colorList;
@property (nonatomic, strong) NSArray *specList;
@property (nonatomic, strong) NSArray *stockList;
@property (nonatomic, strong) NSArray *activity;
@property (nonatomic, assign) BOOL isFavorite;

@property (nonatomic, assign) int goodsNumber;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL isUserOpration;
@property (nonatomic, assign) NSInteger colorSelectedIndex;
@property (nonatomic, assign) NSInteger sizeSelectedId;
@property (nonatomic, assign) BOOL isSelectedCurrent;
@property (nonatomic, strong) MBAddShoppingProductInfoModel *stockModel;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayForDataArray:(NSArray*)dataArray;

@end
