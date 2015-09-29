//
//  MBCollocationDetailsCollectionHeaderView.h
//  Wefafa
//
//  Created by Jiang on 5/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBCollocationDetailsCollectionHeaderView, MBCollocationInfoModel, MBCollocationUserPublicModel;

@protocol MBCollocationDetailsCollectionHeaderDelegate <NSObject>

@optional

- (void)collocationDetailsUserContentTouchTap:(MBCollocationDetailsCollectionHeaderView*)headerView;
- (void)collocationDetails:(MBCollocationDetailsCollectionHeaderView*)headerView AttentionButton:(UIButton*)attentionButton;
- (void)collocationDetails:(MBCollocationDetailsCollectionHeaderView*)headerView BuyNowButton:(UIButton*)buyNowButton;
- (void)collocationDetails:(MBCollocationDetailsCollectionHeaderView*)headerView ShoppingBagButton:(UIButton*)shoppingBagButton;
- (void)collocationDetails:(MBCollocationDetailsCollectionHeaderView*)headerView TagIndex:(NSInteger)tagIndex;

@end

@interface MBCollocationDetailsCollectionHeaderView : UICollectionReusableView

@property (nonatomic, assign) id<MBCollocationDetailsCollectionHeaderDelegate> headerDelegate;

@property (nonatomic, strong) MBCollocationInfoModel *contentInfoModel;
@property (nonatomic, assign) BOOL isConcerned;
@property (nonatomic, strong) MBCollocationUserPublicModel *contentUserModel;
@property (nonatomic, strong) NSArray *contentTagModel;
@property (nonatomic, strong) UIImageView *headerImageView;

@end
