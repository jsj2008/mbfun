//
//  SHeaderTitleCollectionView.h
//  Wefafa
//
//  Created by unico_0 on 6/3/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHeaderTitleModel, SDiscoveryFlexibleModel;

@protocol SHeaderTitleCollectionViewDelegate <NSObject>

@optional
- (void)headerTitleCollectionView:(UICollectionView*)collectionView selectedIndex:(NSIndexPath*)indexPath;
- (void)headerTitleCollectionView:(UICollectionView*)collectionView contentModel:(SHeaderTitleModel*)contenModel;

@end

@interface SHeaderTitleView : UIView

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, assign) id<SHeaderTitleCollectionViewDelegate> headerTitleDelegate;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) NSArray *contentModelArray;
@property (nonatomic, strong) NSMutableArray *pramsViewArray;//需要选中ID的View，model放进来
@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) SDiscoveryFlexibleModel *contentModel;
@property (nonatomic, strong) CALayer *lineLayer;

- (void)setOriginOffset:(CGFloat)offset;

@end

@interface SHeaderTitleCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end