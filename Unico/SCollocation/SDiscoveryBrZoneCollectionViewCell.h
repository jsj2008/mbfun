//
//  SDiscoveryBrZoneCollectionViewCell.h
//  Wefafa
//
//  Created by metesbonweios on 15/8/3.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SBrandStoryDetailModel;
static NSString *brandZoneVCellIdentifier = @"SDiscoveryBrandZoneCVCellIdentifier";
@interface SDiscoveryBrZoneCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *brandLogo;
@property (weak, nonatomic) IBOutlet UILabel *brandName;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabe;
@property (weak, nonatomic) SBrandStoryDetailModel *contentDataModel;
@end
