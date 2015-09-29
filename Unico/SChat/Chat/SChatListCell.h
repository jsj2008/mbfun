//
//  SChatListCell.h
//  UUChatTableView
//
//  Created by Ryan on 15/6/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SChatListModel.h"
@interface SChatListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *msg;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (nonatomic, strong) SChatListModel *model;

@end
