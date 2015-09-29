//
//  MBCollocationDetailModel.h
//  Wefafa
//
//  Created by Jiang on 5/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBCollocationInfoModel.h"
#import "MBCollocationUserPublicModel.h"
#import "MBCollocationDetailListModel.h"
#import "MBCollocationTagMappingModel.h"

@interface MBCollocationDetailModel : NSObject

@property (nonatomic, strong) MBCollocationInfoModel *collocationInfo;
@property (nonatomic, strong) NSArray *detailList;
@property (nonatomic, strong) NSNumber *isConcerned;
@property (nonatomic, strong) NSNumber *isFavorite;
@property (nonatomic, strong) NSArray *tagMapping;
@property (nonatomic, strong) NSArray *customTagColMapping;
@property (nonatomic, strong) MBCollocationUserPublicModel *userPublicEntity;

@property (nonatomic, strong) NSMutableArray *tagModelArray;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
