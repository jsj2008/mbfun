//
//  SDiscoveryFlexibleModel.m
//  Wefafa
//
//  Created by unico_0 on 7/8/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryFlexibleModel.h"

@implementation SDiscoveryFlexibleModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSString class]]) {
            NSLog(@"你大爷的配置错了1 ");
            
            return self;
        }
        self.type = dict[@"type"];
        self.name = dict[@"name"];
        self.title = dict[@"title"];
        self.banner_list = [SDiscoveryBannerModel modelArrayForDataArray:dict[@"banner_list"]];
        [self setConfig:dict[@"config"] type:[_type intValue]];
    }
    return self;
}


//discoveryNone = 0,
//discoveryTopic,//晒出你的范儿
//discoveryToday,//今日搭配
//discoveryDesigner,//推荐造型师
//discoveryBrand,//推荐品牌
//discoveryProduct,//优选单品
//discoveryTitleTag,//搭配列表标签
//discoveryJump,//跳转图标
//discoveryBanner//广告
- (void)setConfig:(NSArray *)config type:(int)type{
    if (config.count <= 0) return;
    switch (type) {
        case discoveryNone:
            _config = config;
            break;
        case discoveryTopic:
            _config = [StopicListModel modelArrayForDataArray:config];
            break;
        case discoveryToday:
            _config = [LNGood modelArrayForDataArray:config];
            break;
        case discoveryDesigner:
            _config = [SDiscoveryUserModel modelArrayForDataArray:config];
            break;
        case discoveryBrand:
        case discoveryBrandZone:
        case discoveryCategoryBrand:
            _config = [SBrandStoryDetailModel modelArrayForDataArray:config];
            break;
        case discoveryProduct:
        case discoveryCategorySituation:
        case discoveryTransitionSituation:
            _config = [SDiscoveryProductModel modelArrayForDataArray:config];
            break;
        case discoveryTitleTag:
        case discoveryTitleCategory:
            _config = [SHeaderTitleModel modelArrayForDataArray:config];
            break;
        case discoveryJump:
            _config = [SDiscoveryJumpModel modelArrayForDataArray:config];
            break;
        case discoveryBanner:
        case discoveryPlayerBanner:
        case discoveryCollectionBanner:
        case discoveryAgilityWithBanner:
        case discoveryShowTitleBar:
            _config = [SDiscoveryBannerModel modelArrayForDataArray:config];
            break;
        case discoveryActivity:
        case discoveryActivity_01:
        case discoveryActivity_02:
            _config = [SActivityReceiveModel modelArrayForDataArray:config];
            break;
        case discoveryFashionInsider:
            _config = [SStarStoreCellModel modelArrayForDataArray:config];
            break;
        case discoveryHotTopic:
            _config = [StopicListModel modelArrayForDataArray:config];
            break;
        case discoveryBrandConfigFreeType:
            _config = [SHomeAgilityModel modelArrayForDataArray:config];
            break;
        case discoveryBrandConfigSportType :
            _config = [SDiscoveryPicTConfigerModel modelArrayForDataArray:config];
            break;
        case discoveryBrandConfigWomenType:
             _config = [SDiscoveryPicTConfigerModel modelArrayForDataArray:config];
            break;
        case discoveryCategoryHot:
            _config = [SAgilityHotCategoryModel modelArrayForDataArray:config];
            break;
        case discoverySpaceLine:
            _config = [SAgilitySpaceModel modelArrayForDataArray:config];
            break;
        default:
            break;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SDiscoveryFlexibleModel *model = [[SDiscoveryFlexibleModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

@end
