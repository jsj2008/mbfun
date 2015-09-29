//
//  GoodsOrderSimpleTableViewCell.h
//  Wefafa
//
//  Created by Miaoz on 14/12/12.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundHeadImageView.h"
@interface GoodsOrderSimpleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet UIImageView *rightimage;
@property (weak, nonatomic) IBOutlet RoundHeadImageView *cuspImgView;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

+(int)getCellHeight:(id)data1;

@end
