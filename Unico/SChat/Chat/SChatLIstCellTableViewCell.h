//
//  SChatLIstCellTableViewCell.h
//  Wefafa
//
//  Created by wave on 15/7/9.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SChatListModel.h"
@interface SChatLIstCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *msg;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *head_v_view;

@property (nonatomic, strong) SChatListModel *model;

@end
