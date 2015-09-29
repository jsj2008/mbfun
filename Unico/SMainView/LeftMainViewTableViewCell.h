//
//  LeftMainViewTableViewCell.h
//  Wefafa
//
//  Created by wave on 15/8/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLeftMainViewModel;
static NSString *leftMainViewTableViewCellIdentifier = @"leftMainViewTableViewCellIdentifier";

typedef void (^JumpBlock)(SLeftMainViewModel*model);

@interface LeftMainViewTableViewCell : UITableViewCell
@property (nonatomic, strong) SLeftMainViewModel *model;
@property (nonatomic, strong) JumpBlock jumpBlock;
@end
