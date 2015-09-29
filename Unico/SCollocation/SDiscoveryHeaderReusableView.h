//
//  SDiscoveryHeaderReusableView.h
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDiscoveryHomeModel;

@protocol SDiscoveryHeaderReusableViewDelegate <NSObject>

- (void)discoveryHeaderJumpToController:(NSInteger)index;

@end

@interface SDiscoveryHeaderReusableView : UICollectionReusableView

@property (nonatomic, assign) id<SDiscoveryHeaderReusableViewDelegate> delegate;
@property (nonatomic, strong) SDiscoveryHomeModel *contentModel;
@property (nonatomic, assign) UIViewController *target;

@end
