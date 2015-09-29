//
//  MyLikeBrandTableViewCell.h
//  Wefafa
//
//  Created by metesbonweios on 15/7/22.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SBrandStoryDetailModel;
@class SBrandListContentModel;
@interface MyLikeBrandTableViewCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *brandHeadImgV;
@property (weak, nonatomic) IBOutlet UILabel *brandName;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoNumLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@property (nonatomic, strong) SBrandStoryDetailModel * model;

@property (nonatomic, weak) UIViewController *parentVc;
@end

@interface SBrandListShowImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) SBrandListContentModel *contentModel;

@end
