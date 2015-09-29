//
//  SDiscoveryTitleCollectionViewCell.h
//  Wefafa
//
//  Created by unico_0 on 6/20/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cellIdentifier = @"SDiscoveryTitleCollectionViewCellIdentifier";
@interface SDiscoveryTitleCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
