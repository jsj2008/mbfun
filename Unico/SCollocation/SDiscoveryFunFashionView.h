//
//  SDiscoveryFunFashionView.h
//  Wefafa
//
//  Created by Jiang on 8/17/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDiscoveryFlexibleModel;

@interface SDiscoveryFunFashionView : UIView

@property (nonatomic, strong) SDiscoveryFlexibleModel *contentModel;
@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) NSArray *contentArray;

@end
