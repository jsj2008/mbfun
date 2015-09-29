//
//  SMyTopicPicCollectionViewCell.h
//  Wefafa
//
//  Created by wave on 15/7/22.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMyTopicPicModel;
@interface SMyTopicPicCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) UIViewController *collectionView;
@property (nonatomic, strong) SMyTopicPicModel *model;

@end
