//
//  BrandDetailTemptCollectionViewCell.h
//  Wefafa
//
//  Created by wave on 15/8/19.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SContentOnePageCell.h"
@class SMDataModel;

@interface BrandDetailTemptCollectionViewCell : UICollectionViewCell
@property (nonatomic) UIViewController *parentVc;
@property (nonatomic, assign) id<kMainViewCellDelegate> delegate;
- (void)updateCellUIWithModel:(SMDataModel*)model atIndex:(NSIndexPath*)indexPath;

@property (nonatomic, strong) void(^isLikeBlock)(BOOL isLike); // add(9.28) 相关搭配下的喜欢

@end
