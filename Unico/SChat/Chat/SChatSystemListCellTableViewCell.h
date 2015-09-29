//
//  SChatSystemListCellTableViewCell.h
//  Wefafa
//
//  Created by wave on 15/6/15.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SChatSystemListModel.h"
@interface SChatSystemListCellTableViewCell : UITableViewCell

//UIImageView *img;
//UILabel *num;
//UILabel *name;
//UILabel *msg;
//UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *msg;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIImageView *detailImg;
@property (weak, nonatomic) IBOutlet UIImageView *head_v_view;

@property (nonatomic, strong) SChatSystemListModel *model;
@end
