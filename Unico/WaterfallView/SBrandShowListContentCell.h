//
//  SBrandShowListContentCell.h
//  Wefafa
//
//  Created by lizhaoxiang on 15/5/24.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilterBrandCategoryModel;
@interface SBrandShowListContentCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (nonatomic, strong) FilterBrandCategoryModel *brandModel;

@end
