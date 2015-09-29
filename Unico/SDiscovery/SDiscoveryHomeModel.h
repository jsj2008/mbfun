//
//  SDiscoveryHomeModel.h
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDiscoveryBannerModel.h"
#import "StopicListModel.h"
#import "SDiscoveryUserModel.h"
#import "SBrandStoryDetailModel.h"
#import "SDiscoveryProductModel.h"
#import "SHeaderTitleModel.h"
#import "LNGood.h"

@interface SDiscoveryHomeModel : NSObject

@property (nonatomic, strong) NSArray *advertisement;
@property (nonatomic, strong) NSArray *recommendContent;
@property (nonatomic, strong) NSArray *bannerList;
@property (nonatomic, strong) NSArray *topic;
@property (nonatomic, strong) NSArray *todayCollocation;
@property (nonatomic, strong) NSArray *recommendDesigner;
@property (nonatomic, strong) NSArray *recommendBrand;
@property (nonatomic, strong) NSArray *recommendProduct;
@property (nonatomic, strong) NSArray *catagoryTitle;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
