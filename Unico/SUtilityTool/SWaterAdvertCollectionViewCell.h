//
//  SWaterAdvertCollectionViewCell.h
//  Wefafa
//
//  Created by unico_0 on 6/17/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LNGood;

static NSString *waterAdvertCellIdentifier = @"SWaterAdvertCollectionViewCellIdentifier";
@interface SWaterAdvertCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) LNGood *contentGoodsModel;

@end
