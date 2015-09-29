//
//  SItemDetailViewController.h
//  Wefafa
//
//  Created by unico on 15/5/15.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBaseDetailViewController.h"
@class SActivityPromPlatModel;

typedef enum : NSUInteger {
    itemSucceed = 0,
    itemFailure,
    itemCancel,
} ShareItemStatus;

@interface SItemDetailViewController : SBaseDetailViewController

@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, strong) NSNumber * promotion_ID;
@property (nonatomic, strong) SActivityPromPlatModel *promPlatModel;

@end
