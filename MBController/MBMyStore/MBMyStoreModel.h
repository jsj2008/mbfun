//
//  MBMyStoreModel.h
//  Wefafa
//
//  Created by Jiang on 4/2/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBMyStoreInfoModel.h"

@interface MBMyStoreModel : NSObject

@property (nonatomic, strong) NSNumber *colCount;
@property (nonatomic, strong) NSNumber *concernedCount;
@property (nonatomic, strong) NSNumber *profit;
@property (nonatomic, strong) NSNumber *settledAmount;
@property (nonatomic, strong) MBMyStoreInfoModel *storeInfo;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end
