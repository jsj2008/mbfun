//
//  SDiscoveryHotCategoryCell.h
//  Wefafa
//
//  Created by Mr_J on 15/8/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cellIdentifier = @"SDiscoveryHotCategoryCellIdentifier";
@interface SDiscoveryHotCategoryCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;


@end
