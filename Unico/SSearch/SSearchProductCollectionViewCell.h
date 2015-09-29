//
//  SSearchProductCollectionViewCell.h
//  Wefafa
//
//  Created by unico_0 on 5/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SSearchProductModel, SActivityBrandListModel, SCollocationSubProductInfoModel;

@interface SSearchProductCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isShowPrice;
@property (nonatomic, strong) SSearchProductModel *contentModel;
@property (nonatomic, strong) SActivityBrandListModel *brandContentModel;
@property (nonatomic, strong) SCollocationSubProductInfoModel *productInfoModel;

@property(strong, readonly, nonatomic)UIImage *productImage;

@end
