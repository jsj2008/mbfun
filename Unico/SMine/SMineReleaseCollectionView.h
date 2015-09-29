//
//  SMineReleaseCollectionView.h
//  Wefafa
//
//  Created by Funwear on 15/8/25.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSearchCollocationCollectionView.h"
#import "SMineViewController.h"
@interface SMineReleaseCollectionView : UICollectionView
@property (nonatomic, assign) id<SSearchCollocationCollectionViewDelegate> collectionViewDelegate;
@property (nonatomic, assign) SMineViewController *parentVc;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, copy) void (^opration)(NSIndexPath *indexPath, NSArray *array);
@property (nonatomic, strong) NSNumber *isAbandonRefresh;
@end
