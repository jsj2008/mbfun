//
//  FliterContentCollectionViewCell.h
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilterColorCategoryModel, FilterBrandCategoryModel, FilterPirceRangeModel,FilterSizeCategoryModel;

@interface FliterContentCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) FilterPirceRangeModel *pirceRangeModel;
@property (nonatomic, strong) FilterColorCategoryModel *colorModel;
@property (nonatomic, strong) FilterBrandCategoryModel *brandModel;
@property (nonatomic, strong) FilterSizeCategoryModel *sizeModel;
@end
