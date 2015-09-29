//
//  SCollocationProductCollectionView.h
//  Wefafa
//
//  Created by Mr_J on 15/8/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCollocationProductCollectionView : UIView

@property (nonatomic, strong) SCollocationDetailModel *contentModel;
@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) NSArray *contentArray;;

@end
