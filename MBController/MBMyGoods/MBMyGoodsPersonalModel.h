//
//  MBMyGoodsPersonalModel.h
//  Wefafa
//
//  Created by Jiang on 4/2/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBMyGoodsContentModel.h"
#import "MBUserStatisticsFilterList.h"

@interface MBMyGoodsPersonalModel : MBMyGoodsContentModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pictureUrl;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *clsPicUrl;
@property (nonatomic, copy) NSString *sale_price;

@property (nonatomic, strong) NSNumber *favoritCount;
@property (nonatomic, strong) NSNumber *isFavorite;
@property (nonatomic, strong) NSNumber *sharedCount;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, strong) NSString *productClsID;
@property (nonatomic, strong) NSString *shareUserID;
@property (nonatomic, strong) MBUserStatisticsFilterList *commonCountTotal;
+ (NSMutableArray *)modelArrayWithDataArray:(NSArray *)dataArray;
@end
