//
//  SDiscoveryShowImageCell.h
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *showImageCellIdentifier = @"SDiscoveryShowImageCellIdentifier";
@interface SDiscoveryShowImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *reserveImageView;

@end
