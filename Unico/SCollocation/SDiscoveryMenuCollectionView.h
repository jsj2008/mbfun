//
//  SDiscoveryMenuCollectionView.h
//  Wefafa
//
//  Created by unico_0 on 7/9/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//  topview buttons

#import <UIKit/UIKit.h>
@class SDiscoveryFlexibleModel;

@interface SDiscoveryMenuCollectionView : UICollectionView

@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) SDiscoveryFlexibleModel *contentModel;

@end
