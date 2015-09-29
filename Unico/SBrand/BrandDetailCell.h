//
//  BrandDetailCell.h
//  Wefafa
//
//  Created by wave on 15/8/5.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@class LNGood;

typedef void(^simpleBlock)();

@interface BrandDetailCell : UICollectionViewCell

@property (nonatomic, strong) simpleBlock likeBlock;
@property (nonatomic) LNGood *model;
@property (nonatomic, weak) UIViewController *parentVc;

@end
