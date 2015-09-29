//
//  GoodsOrderAmountTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsOrderBaseTableViewCell.h"

@interface GoodsOrderAmountTableViewCell : GoodsOrderBaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbAmount;
@property (strong, nonatomic) IBOutlet UILabel *lbCount;
@property (weak, nonatomic) IBOutlet UILabel *lbTransFee;

@end
