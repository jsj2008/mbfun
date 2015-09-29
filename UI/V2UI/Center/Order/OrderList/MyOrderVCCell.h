//
//  MyOrderVCCell.h
//  Designer
//
//  Created by Juvid on 15/1/15.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderVCCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgGoods;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labGoodsSN;
@property (weak, nonatomic) IBOutlet UILabel *labSize;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (weak, nonatomic) IBOutlet UILabel *labNum;

@end
