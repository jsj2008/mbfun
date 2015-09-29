//
//  SCollocationCollectionViewCell.h
//  Wefafa
//
//  Created by unico on 15/5/14.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LNGood;
@interface SCollocationCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) LNGood *good;
-(void) initWaterFallFlowCell;
@end
