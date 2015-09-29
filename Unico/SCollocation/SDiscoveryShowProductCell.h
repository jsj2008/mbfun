//
//  SDiscoveryShowProductCell.h
//  Wefafa
//
//  Created by unico_0 on 7/8/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDiscoveryProductModel;

@interface SDiscoveryShowProductCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *describeLable;

@property (nonatomic, strong) SDiscoveryProductModel *contentModel;

@end
