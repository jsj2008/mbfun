//
//  SNewPavilionCellView.h
//  Wefafa
//
//  Created by metesbonweios on 15/8/19.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDiscoveryFlexibleModel;
@class SBrandPavilionModel;

@interface SNewPavilionCellView : UIView

@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) SBrandPavilionModel *contentModel;

@end
