//
//  GoodsOrderAddressTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsOrderBaseTableViewCell.h"

@interface GoodsOrderAddressTableViewCell : GoodsOrderBaseTableViewCell
{
    NSDictionary *_data;
}
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UILabel *lbAddress;
@property (strong, nonatomic) IBOutlet UILabel *lbMobile;
@property (weak, nonatomic) IBOutlet UILabel *nLable;


@end
