//
//  MBBrandViewController.h
//  Wefafa
//
//  Created by fafatime on 15-4-2.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageWaterView.h"
#import "SVPullToRefresh.h"

@class GoodsListCollectionView;

@interface MBBrandViewController : SBaseViewController
{
}
@property (strong, nonatomic) NSString *brandId;//品牌id
@property (strong, nonatomic) GoodsListCollectionView *brandWaterView;
@property (strong, nonatomic) NSString *brandName;
@property (strong,nonatomic)NSString *categaryID;//分类id
@property (nonatomic, strong) NSDictionary *searchDictionary;

@end
