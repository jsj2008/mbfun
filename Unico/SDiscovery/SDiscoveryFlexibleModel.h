//
//  SDiscoveryFlexibleModel.h
//  Wefafa
//
//  Created by unico_0 on 7/8/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryBannerModel.h"
#import "StopicListModel.h"
#import "SDiscoveryUserModel.h"
#import "SBrandStoryDetailModel.h"
#import "SDiscoveryProductModel.h"
#import "SHeaderTitleModel.h"
#import "SDiscoveryJumpModel.h"
#import "SActivityReceiveModel.h"
#import "LNGood.h"
#import "SHomeAgilityModel.h"
#import "SDiscoveryPicAndTextModel.h"
#import "SAgilitySpaceModel.h"
#import "SStarStoreCellModel.h"
#import "SAgilityHotCategoryModel.h"

typedef enum : NSUInteger {
    discoveryNone = 0,
    discoveryTopic,//晒出你的范儿  1
    discoveryToday,//今日搭配  2
    discoveryDesigner,//推荐造型师  3
    discoveryBrand,//推荐品牌  4
    discoveryProduct,//优选单品  5
    discoveryTitleTag,//搭配列表标签  6
    discoveryJump,//跳转图标  7
    discoveryBanner,//广告  8
    discoveryPlayerBanner,//轮播广告  9
    discoveryActivity,//限时折扣  10
    discoveryActivity_01,//活动样式01  11
    discoveryActivity_02,//活动样式02  12
    discoveryBrandZone,//品牌专区  13
    discoveryFashionInsider, //时尚达人  14
    discoveryHotTopic, //热门话题  15
    discoveryCollectionBanner, //滚动广告条  16
    discoveryAgilityWithBanner, //有广告条的自定义布局  17
    discoveryShowTitleBar,
    
    discoveryBrandConfigFreeType = 101,//图片加字//首页中有出现
    discoveryBrandConfigSportType = 201,//运动系列
    discoveryBrandConfigWomenType = 202,//淑女系列
    discoveryCategoryBrand = 301, //品牌分类
    discoveryCategoryHot = 302, //热门分类
    discoveryCategorySituation = 303, //情景分类
    discoveryTransitionSituation = 304, //情景转换
    discoverySpaceLine = 99999, //间隔
    discoveryTitleCategory = 100000, //分类标题
    
    discoveryListDsicriptionTitle = 101010101,
    
} DiscoveryModuleType;

@interface SDiscoveryFlexibleModel : NSObject

@property (nonatomic, strong) NSArray *banner_list;
@property (nonatomic, strong) NSArray *config;

@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *selectedID;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end
