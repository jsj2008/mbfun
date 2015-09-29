//
//  SDiscoverBrandNewCollectionViewCell.h
//  Wefafa
//
//  Created by metesbonweios on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDiscoveryPicAndTextConfigModel;

@interface SDiscoverBrandNewCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (nonatomic, strong) SDiscoveryPicAndTextConfigModel *brandModel;

@end
