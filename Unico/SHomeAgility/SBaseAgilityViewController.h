//
//  SBaseAgilityViewController.h
//  Wefafa
//
//  Created by Mr_J on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"
#import "WaterFLayout.h"
@class SMenuBottomModel, ShoppIngBagShowButton;

@interface SBaseAgilityViewController : SBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, WaterFLayoutDelegate>

@property (nonatomic, strong) UIView *navigationTitleView;
@property (strong, nonatomic) UICollectionView *contentCollectionView;
@property (nonatomic, strong) WaterFLayout *contentCollectionLayout;
@property (nonatomic, strong) NSMutableArray *contentHeaderModelArray;
@property (nonatomic, copy) NSString *titleViewUrl;
@property (nonatomic, copy) NSString *requestActionName;
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) SMenuBottomModel *layoutModel;

- (void)initSubViews;
- (void)scrollToTop;
- (void)requestData;

@end
