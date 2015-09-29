//
//  GoodsOrderPayFeeTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsOrderBaseTableViewCell.h"

@interface GoodsOrderPayFeeTableViewCell : GoodsOrderBaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbSummery;
@property (strong, nonatomic) IBOutlet UILabel *lbDisAmount;
@property (strong, nonatomic) IBOutlet UILabel *lbFee;

@end
