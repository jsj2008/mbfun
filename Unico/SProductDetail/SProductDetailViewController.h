//
//  SProductDetailViewController.h
//  Wefafa
//
//  Created by unico_0 on 7/21/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

/**
    单品详情
 */
#import "SBaseViewController.h"
@class SActivityPromPlatModel;
@class SProductDetailModel;

@interface SProductDetailViewController : SBaseViewController



@property (nonatomic, copy) NSString *productID; //其实要为code
@property (nonatomic, strong) NSString *promotion_ID;
@property (nonatomic, strong) SActivityPromPlatModel *promPlatModel;
@property (strong, nonatomic) UICollectionView *contentCollectionView;
@property (nonatomic, copy) NSString *fromControllerName;

@property (nonatomic, assign) BOOL isHide; // 隐藏导航条

@end
