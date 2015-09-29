//
//  SDesignerShowCollectionView.h
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDiscoveryFlexibleModel;

@interface SDesignerShowCollectionView : UIView

@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) SDiscoveryFlexibleModel *contentModel;

@end
