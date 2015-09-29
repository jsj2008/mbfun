//
//  SDiscoveryHeaderMoudleTool.m
//  Wefafa
//
//  Created by Mr_J on 15/8/20.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SDiscoveryHeaderMoudleTool.h"
#import "SDiscoveryFlexibleModel.h"
#import "SDiscoveryShowTopicView.h"
#import "SDiscoveryTodayFanView.h"
#import "SDesignerShowCollectionView.h"
#import "SDiscoveryBrandCollectionView.h"
#import "SDiscoveryProductCollectionView.h"
#import "SHeaderTitleView.h"
#import "SDiscoveryShowTitleView.h"
#import "SDiscoveryMenuCollectionView.h"
#import "SDiscoveryActiovityView.h"
#import "SDiscoveryFlashSaleView.h"
#import "SDiscoveryActivityShowProductView.h"
#import "SDiscoveryBrandZoneCollectionView.h"
#import "SDiscoverShowBigPicAndTitleView.h"//自由
#import "SDiscoveryShowConfigPicAndTextView.h"
#import "SDiscoveryShowBannerTableView.h"
#import "SDiscoveryFashionInsider.h"
#import "SDiscoveryFunFashionView.h"
#import "SDiscoveryPlayerAgilityView.h"
#import "SDiscoveryHotTopicView.h"
#import "SDiscoveryOccasionView.h"
#import "SDiscoveryCollocationCategoryView.h"
#import "SDiscoveryShowTitleBarView.h"
#import "SDiscoveryShowLineTitleView.h"

@implementation SDiscoveryHeaderMoudleTool

+ (CGFloat)getHeaderCellHeightWithModel:(SDiscoveryFlexibleModel*)model{
    int type = [model.type intValue];
    CGFloat cellHeight = 0.0;
    CGFloat scale = UI_SCREEN_WIDTH/ 375.0;
    switch (type) {
        case discoveryNone:
            
            break;
        case discoveryTopic:
            cellHeight = UI_SCREEN_WIDTH;
            break;
        case discoveryToday:
            cellHeight = 40 + [SDiscoveryHeaderMoudleTool getBannerAndContentHeight:240 model:model];
            break;
        case discoveryDesigner:
            cellHeight = 135;
            break;
        case discoveryBrand:
        case discoveryCategoryBrand:
            cellHeight = 40 + [SDiscoveryHeaderMoudleTool getBannerAndContentHeight:150 model:model];
            break;
        case discoveryProduct:
            cellHeight = 40 + [SDiscoveryHeaderMoudleTool getBannerAndContentHeight:(int)((model.config.count + 1)/ 2) * 60 model:model];
            break;
        case discoveryTitleTag:
        case discoveryTitleCategory:
            cellHeight = 44;
            break;
        case discoveryJump:
            cellHeight += (int)((model.config.count + 4)/ 5) * 65 * SCALE_UI_SCREEN + 10;
            break;
        case discoveryBanner:
        {
            cellHeight = -5.0;
            for (SDiscoveryBannerModel *bannerModel in model.config) {
                cellHeight += bannerModel.img_height.floatValue * UI_SCREEN_WIDTH/ bannerModel.img_width.floatValue;
            }
        }
            break;
        case discoveryPlayerBanner:
            cellHeight = 170 * scale;
            break;
        case discoveryActivity:
            cellHeight = 80 + [self getBannerAndContentHeight:234.0 model:model];
            break;
        case discoveryActivity_01:
            cellHeight = 70 + 150 + [self getBannerAndContentHeight:0 model:model];
            break;
        case discoveryActivity_02:
            cellHeight = 85 + 150 + [self getBannerAndContentHeight:0 model:model];
            break;
        case discoveryBrandZone://品牌专区
            cellHeight = 180;
            break;
        case discoveryFashionInsider:
        {
            CGFloat height = 0;
            height = 377*UI_SCREEN_WIDTH / 375;
            cellHeight = height * model.config.count;
            cellHeight -= model.config.count > 0? 5: 0;
            cellHeight += [self getBannerAndContentHeight:0 model:model] + 40;
        }
            break;
        case discoveryHotTopic:
        {
            cellHeight = 40 + [self getBannerAndContentHeight:0 model:model] + model.config.count * (43 + 92 * SCALE_UI_SCREEN);
            cellHeight -= model.config.count > 0? 5: 0;
        }
            break;
        case discoveryCollectionBanner:
        {
            cellHeight = 35;
            if (model.config.count > 0) {
                SDiscoveryBannerModel *bannerModel = model.config[0];
                cellHeight += bannerModel.img_height.floatValue / 2.0 + 10;
            }
        }
            break;
        case discoveryAgilityWithBanner:
            cellHeight = 40 + [self getBannerAndContentHeight:0 model:model];
            break;
        case discoveryBrandConfigFreeType :
        {
            SHomeAgilityModel *homeAgilitymodel = [model.config firstObject];
            CGFloat height= [homeAgilitymodel.height floatValue];
            if (height!=0) {
                cellHeight = height * UI_SCREEN_WIDTH/[homeAgilitymodel.width floatValue];//高度有问题 需要取model里的
            }
        }break;
        case discoveryBrandConfigSportType://运动系列
            cellHeight = 40 + 235 + [self getBannerAndContentHeight:0 model:model];
            break;
        case discoveryBrandConfigWomenType:
            cellHeight = 40 + 235 + [self getBannerAndContentHeight:0 model:model];
            break;
        case discoveryCategoryHot:
        {
            int count = ((int)model.config.count + 2)/ 3;
            if (count <= 0) break;
            cellHeight = 40 + [self getBannerAndContentHeight:0 model:model] + ((UI_SCREEN_WIDTH - 15)/ 3.0 + 20) * count + 2.5 * (count - 1);
        }
            break;
        case discoveryCategorySituation:
        {
            int count = ((int)model.config.count + 3)/ 4;
            if (count <= 0) break;
            cellHeight = 60 + [self getBannerAndContentHeight:0 model:model] + ((UI_SCREEN_WIDTH - 30)/ 4.0 + 5) * count + (count - 1) * 10;
        }
            break;
        case discoveryTransitionSituation:
        {
            int count = ((int)model.config.count + 2)/ 3;
            if (count <= 0) break;
            cellHeight += ((UI_SCREEN_WIDTH - 80)/ 3.0 + 10) * MIN(count, 1);
            if (count > 1) {
                cellHeight += (count - 1) * 30;
            }
            cellHeight += (count - 1) * 10 + 60 + [self getBannerAndContentHeight:0 model:model];
        }
            break;
        case discoveryShowTitleBar:
        {
            if (model.config.count > 0) {
                SDiscoveryBannerModel *bannerModel = model.config[0];
                cellHeight += bannerModel.height.floatValue/ 2.0;
            }
        }
            break;
        case discoverySpaceLine:
        {
            SAgilitySpaceModel *spaceModel = [model.config firstObject];
            cellHeight = spaceModel.img_height.floatValue * UI_SCREEN_WIDTH/ spaceModel.img_width.floatValue;
        }
            break;
        case discoveryListDsicriptionTitle:
            cellHeight = 40.0;
            break;
        default:
            break;
    }
    cellHeight = isnan(cellHeight)? 0: cellHeight;
    return cellHeight;
}

+ (CGFloat)getBannerAndContentHeight:(CGFloat)height model:(SDiscoveryFlexibleModel*)model{
    height *= SCALE_UI_SCREEN;
    if (model.banner_list.count > 0) {
        SDiscoveryBannerModel *bannerModel = model.banner_list[0];
        height += bannerModel.img_height.floatValue * UI_SCREEN_WIDTH/ bannerModel.img_width.floatValue;
        
    }
    return height;
}

+ (UIView*)cellContentViewWithModel:(SDiscoveryFlexibleModel *)model{
    int type = [model.type intValue];
    UIView *view = nil;
    switch (type) {
        case discoveryNone:
            
            break;
        case discoveryTopic:
            view = [[SDiscoveryShowTopicView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH)];
            break;
        case discoveryToday:
            view = [[SDiscoveryTodayFanView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 240.0)];
            break;
        case discoveryDesigner:
            view = [[SDesignerShowCollectionView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 135)];
            break;
        case discoveryBrand:
        case discoveryCategoryBrand:
            view = [[SDiscoveryBrandCollectionView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 150 * SCALE_UI_SCREEN)];
            break;
        case discoveryProduct:
            view = [[SDiscoveryProductCollectionView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 192)];
            break;
        case discoveryTitleTag:
        case discoveryTitleCategory:
            //            view = [[SHeaderTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
            break;
        case discoveryJump:
            view = [[SDiscoveryMenuCollectionView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 65 * SCALE_UI_SCREEN)];
            break;
        case discoveryBanner:
            view = [[SDiscoveryShowBannerTableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 5 + 80 * SCALE_UI_SCREEN)];
            break;
        case discoveryPlayerBanner:
            view = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 170)];
            break;
#warning 活动在这里
        case discoveryActivity:
            view = [[SDiscoveryActiovityView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 80 + 170 * SCALE_UI_SCREEN)];
            break;
        case discoveryActivity_01:
            view = [[SDiscoveryActivityShowProductView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 75 + 150)];
            break;
        case discoveryActivity_02:
            view = [[SDiscoveryFlashSaleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 90)];
            break;
        case discoveryBrandZone:
            view = [[SDiscoveryBrandZoneCollectionView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 180)];
            break;
        case discoveryFashionInsider:
            view = [[SDiscoveryFashionInsider alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 180)];
            break;
        case discoveryHotTopic:
            view = [[SDiscoveryHotTopicView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 155)];
            break;
        case discoveryCollectionBanner:
            view = [[SDiscoveryFunFashionView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50)];
            break;
        case discoveryAgilityWithBanner:
            view = [[SDiscoveryPlayerAgilityView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 155)];
            break;
        case discoveryShowTitleBar:
            view = [[SDiscoveryShowTitleBarView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 20)];
            break;
        case discoveryBrandConfigFreeType:
            view = [[SDiscoverShowBigPicAndTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 10)];
            break;
        case discoveryBrandConfigSportType://运动系列
        case discoveryBrandConfigWomenType: // 淑女系列
            view =  [[SDiscoveryShowConfigPicAndTextView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 451 + 10-172)];
            break;
        case discoveryCategoryHot:
            view = [[SDiscoveryCollocationCategoryView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 155)];
            break;
        case discoveryCategorySituation:
        case discoveryTransitionSituation:
            view = [[SDiscoveryOccasionView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 155)];
            break;
        case discoverySpaceLine:
        {
            view = [[UIView alloc]init];
            view.backgroundColor = UIColorFromRGB(0xf2f2f2);
        }
            break;
        case discoveryListDsicriptionTitle:
            view = [[SDiscoveryShowLineTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40)];
            break;
        default:
            break;
    }
//    view.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    view.tag = 666;
    view.layer.masksToBounds = YES;
    return view;
}

@end
