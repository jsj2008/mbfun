//
//  SActivityDiscountTableViewCell.h
//  Wefafa
//
//  Created by unico_0 on 6/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SActivityListModel, MBCollocationInfoModel, MBGoodsDetailsModel, SActivityPromPlatModel;
@class SActivityProductListModel;
@protocol SActivityDiscountTableViewCellDelegate <NSObject>

//- (void)activityGoodsBuyNow:(UIButton*)button model:(MBGoodsDetailsModel*)model;
//- (void)activityGoodsTouchContentImage:(UIImageView*)imageView model:(MBGoodsDetailsModel*)model;

- (void)activityGoodsBuyNow:(UIButton*)button model:(SActivityProductListModel*)model;
- (void)activityGoodsTouchContentImage:(UIImageView*)imageView model:(SActivityProductListModel*)model;


- (void)activityCollocationBuyNow:(UIButton*)button model:(MBCollocationInfoModel*)model;
- (void)activityCollocationTouchContentImage:(UIImageView*)imageView model:(MBCollocationInfoModel*)model;

@end

@interface SActivityDiscountTableViewCell : UITableViewCell

@property (nonatomic, assign) id<SActivityDiscountTableViewCellDelegate> delegate;
@property (nonatomic, strong) MBGoodsDetailsModel *goodsModel;
@property (nonatomic, strong) MBCollocationInfoModel *collocationModel;

@property (nonatomic, strong) SActivityPromPlatModel *promPlatModel;
@property (nonatomic, strong) SActivityProductListModel *productListModel;

@property (nonatomic, assign) BOOL isActivityEnd;

@end
