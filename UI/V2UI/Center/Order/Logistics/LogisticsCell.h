//
//  LogisticsCell.h
//  BanggoPhone
//
//  Created by Juvid on 14-7-14.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogisticsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgRedPoint;//物流状态点
@property (weak, nonatomic) IBOutlet UIView *lineVertical;//竖线

@property (weak, nonatomic) IBOutlet UIView *cellLine;//下划线
@property (weak, nonatomic) IBOutlet UILabel *labTitle;//物流点
@property (weak, nonatomic) IBOutlet UILabel *labTime;//时间

@end
