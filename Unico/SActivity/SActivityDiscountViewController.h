//
//  SActivityDiscountViewController.h
//  Wefafa
//
//  Created by unico_0 on 6/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SActivityListModel;
@class SMBNewActivityListModel;
typedef enum : NSUInteger {
    activityGoods = 0,
    activityCollocation,
    activityBrand
} ActivityDetailType;

@interface SActivityDiscountViewController : SBaseViewController

//@property (nonatomic, strong) SActivityListModel *contentModel;
@property (nonatomic, strong) SMBNewActivityListModel *contentModel;
@property (nonatomic, strong) NSString *activityID;

@end
