//
//  SDiscoveryHeaderCollectionCell.h
//  Wefafa
//
//  Created by unico_0 on 7/9/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cellIdentifier = @"SDiscoveryHeaderCollectionCellIdentifier";
@interface SDiscoveryHeaderCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerTypeImageView;

@end
