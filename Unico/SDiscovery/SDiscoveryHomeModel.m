//
//  SDiscoveryHomeModel.m
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryHomeModel.h"

@implementation SDiscoveryHomeModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict[@"banner"]) {
            if (dict[@"banner"][@"1001"]) {
                _advertisement = [SDiscoveryBannerModel modelArrayForDataArray:dict[@"banner"][@"1001"]];
            }
            if (dict[@"banner"][@"1002"]) {
                _recommendContent = [SDiscoveryBannerModel modelArrayForDataArray:dict[@"banner"][@"1002"]];
            }
            if (dict[@"banner"][@"1003"]) {
                _bannerList = [SDiscoveryBannerModel modelArrayForDataArray:dict[@"banner"][@"1003"]];
            }
        }
        if (dict[@"pos_1"]) {
            _topic = [StopicListModel modelArrayForDataArray:dict[@"pos_1"][@"config"]];
        }
        if (dict[@"pos_2"]) {
            _todayCollocation = [LNGood modelArrayForDataArray:dict[@"pos_2"][@"config"]];
        }
        if (dict[@"pos_3"]) {
            _recommendDesigner = [SDiscoveryUserModel modelArrayForDataArray:dict[@"pos_3"][@"config"]];
        }
        if (dict[@"pos_4"]) {
            _recommendBrand = [SBrandStoryDetailModel modelArrayForDataArray:dict[@"pos_4"][@"config"]];
        }
        if (dict[@"pos_5"]) {
            _recommendProduct = [SDiscoveryProductModel modelArrayForDataArray:dict[@"pos_5"][@"config"]];
        }
        if (dict[@"pos_6"]) {
            _catagoryTitle = [SHeaderTitleModel modelArrayForDataArray:dict[@"pos_6"][@"config"]];
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
