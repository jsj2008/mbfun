//
//  SDiscoveryBrandZoneCollectionView.h
//  Wefafa
//
//  Created by metesbonweios on 15/7/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDiscoveryFlexibleModel;

@interface SDiscoveryBrandZoneCollectionView : UIView
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) SDiscoveryFlexibleModel *contentModel;
@end
