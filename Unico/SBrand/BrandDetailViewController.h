//
//  BrandDetailViewController.h
//  Wefafa
//
//  Created by wave on 15/8/3.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"

static NSString *brandproductCellIdentifier = @"brandproductCellIdentifier";

typedef void(^clickBlock)(NSString *aid);
typedef void(^reloadItemsAtIndexPaths) (UICollectionViewCell*cell);

@interface BrandDetailViewController : SBaseViewController
@property (nonatomic, strong) clickBlock block;
@property (nonatomic, strong) reloadItemsAtIndexPaths reloadBlock;
@property (nonatomic, strong) NSString *brandId;
@end
