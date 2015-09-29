//
//  SDiscoveryHeaderReusableView.m
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryHeaderReusableView.h"
#import "SDiscoveryHomeModel.h"
#import "ShowAdvertisementView.h"
#import "SRecommendCollocationCollectionView.h"
#import "SDiscoveryShowBannerTableView.h"
#import "SDiscoveryShowTopicView.h"
#import "SDiscoveryTodayFanView.h"
#import "SDesignerShowCollectionView.h"
#import "SDiscoveryBrandCollectionView.h"
#import "SDiscoveryProductCollectionView.h"
#import "SHeaderTitleView.h"
#import "SDiscoveryShowTitleView.h"
#import "SDiscoverShowBigPicAndTitleView.h"

@interface SDiscoveryHeaderReusableView ()

@property (weak, nonatomic) IBOutlet ShowAdvertisementView *showAdvertisementView;
@property (weak, nonatomic) IBOutlet UIView *jumpToSubModulesView;
@property (weak, nonatomic) IBOutlet SRecommendCollocationCollectionView *recommendCollocationCollectionView;
@property (weak, nonatomic) IBOutlet SDiscoveryShowBannerTableView *showBannerView;
@property (weak, nonatomic) IBOutlet SDiscoveryShowTopicView *showTopicView;
@property (weak, nonatomic) IBOutlet SDiscoveryTodayFanView *showTodayFanView;
@property (weak, nonatomic) IBOutlet SDesignerShowCollectionView *showDesignerView;
@property (weak, nonatomic) IBOutlet SDiscoveryBrandCollectionView *showBrandListView;
@property (weak, nonatomic) IBOutlet SDiscoveryProductCollectionView *showProductView;
@property (weak, nonatomic) IBOutlet SHeaderTitleView *titleSelectedView;
@property (weak, nonatomic) IBOutlet SDiscoveryShowTitleView *showTopicTitleView;

//跳转按钮---------------
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *jumpButton;
- (IBAction)jumpButtonAction:(UIButton *)sender;

//---------------

@end

@implementation SDiscoveryHeaderReusableView

- (void)awakeFromNib {
    [_showTopicTitleView initSubViews];
    [_showTopicTitleView setTitleString:@"晒出你的范"];
}

- (void)setContentModel:(SDiscoveryHomeModel *)contentModel{
    _contentModel = contentModel;
    _showAdvertisementView.contentModelArray = contentModel.advertisement;
    _recommendCollocationCollectionView.contentArray = contentModel.recommendContent;
    _showBannerView.contentArray = contentModel.bannerList;
    _showTopicView.contentArray = contentModel.topic;
    _showTodayFanView.contentArray = contentModel.todayCollocation;
    _showDesignerView.contentArray = contentModel.recommendDesigner;
    _showBrandListView.contentArray = contentModel.recommendBrand;
    _showProductView.contentArray = contentModel.recommendProduct;
}

- (void)setDelegate:(id<SDiscoveryHeaderReusableViewDelegate>)delegate{
    _delegate = delegate;
    _target = (UIViewController*)delegate;
    _showAdvertisementView.target = _target;
    _recommendCollocationCollectionView.target = _target;
    _showBannerView.target = _target;
    _showTopicView.target = _target;
    _showTodayFanView.target = _target;
    _showDesignerView.target = _target;
    _showBrandListView.target = _target;
    _showProductView.target = _target;
}

- (IBAction)jumpButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(discoveryHeaderJumpToController:)]) {
        [self.delegate discoveryHeaderJumpToController:sender.tag - 120];
    }
}
@end
