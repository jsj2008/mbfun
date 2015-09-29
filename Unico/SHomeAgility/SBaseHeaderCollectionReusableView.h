//
//  SBaseHeaderCollectionReusableView.h
//  Wefafa
//
//  Created by Mr_J on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDiscoveryFlexibleModel;

@interface SBaseHeaderCollectionReusableView : UICollectionReusableView

- (UIView*)getContentViewWithModel:(SDiscoveryFlexibleModel*)model;

@end
