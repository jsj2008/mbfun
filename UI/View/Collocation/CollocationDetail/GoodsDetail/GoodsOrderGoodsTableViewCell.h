//
//  GoodsOrderGoodsTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsOrderBaseTableViewCell.h"
#import "UIUrlImageView.h"
#import "MyShoppingTrollyGoodsTableViewCell.h"

@interface GoodsOrderGoodsTableViewCell : GoodsOrderBaseTableViewCell
{
    MyShoppingTrollyGoodsData *_data;
}
@property (strong, nonatomic) IBOutlet UIUrlImageView *imageGoods;
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UILabel *lbPrice;
@property (strong, nonatomic) IBOutlet UILabel *lbNumber;
@property (strong, nonatomic) IBOutlet UILabel *lbAmount;
@property (strong, nonatomic) IBOutlet UILabel *lbColor;
@property (weak, nonatomic) IBOutlet UILabel *lbProductCode;
@property (weak, nonatomic) IBOutlet UILabel *preferentialLab;
@property (weak, nonatomic) IBOutlet UILabel *onlyPayLabel;

@end
