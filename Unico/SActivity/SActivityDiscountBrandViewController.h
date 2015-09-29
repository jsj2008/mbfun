
//
//  SActivityDiscountBrandViewController.h
//  Wefafa
//
//  Created by unico_0 on 6/11/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SActivityDiscountHeaderView, SActivityListModel;

@interface SActivityDiscountBrandViewController : SBaseViewController

@property (nonatomic, strong) SActivityListModel *contentModel;

@end

@interface SActivityBrandHeader : UICollectionReusableView

@property (nonatomic, strong) SActivityDiscountHeaderView *contentView;

@end