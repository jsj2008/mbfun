//
//  SWaterCollectionViewCell.h
//  Wefafa
//
//  Created by unico_0 on 6/16/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LNGood;
@class SMDataModel;
static NSString *waterCellIdentifier = @"SWaterCollectionViewCellIdentifier";
@interface SWaterCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) LNGood *contentGoodsModel;
@property (nonatomic, strong) SMDataModel *model;
@end
