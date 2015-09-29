//
//  CollocationTopicNormalTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUrlImageView.h"

@interface CollocationTopicNormalTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIUrlImageView *imageTopic;
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIImageView *imgVert;
@property (weak, nonatomic) IBOutlet UIImageView *imgTopVert;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgPoint;

@property (assign, nonatomic) int row;
@property (strong, nonatomic) id data;

@end
