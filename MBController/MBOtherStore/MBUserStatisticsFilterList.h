//
//  MBUserStatisticsFilterList.h
//  Wefafa
//
//  Created by Jiang on 4/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBUserStatisticsFilterList : NSObject

@property (nonatomic, strong) NSNumber *browserCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSNumber *favoritCount;
@property (nonatomic, strong) NSNumber *sharedCount;
@property (nonatomic, strong) NSNumber *sourceID;
@property (nonatomic, strong) NSNumber *avgComment;
@property (nonatomic, strong) NSNumber *saleQty;
/** 相似单品 */
@property (nonatomic, strong) NSNumber *procodeCount;
/** 相关搭配 */
@property (nonatomic, strong) NSNumber *collocationCount;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
