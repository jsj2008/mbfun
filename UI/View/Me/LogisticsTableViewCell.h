//
//  LogisticsTableViewCell.h
//  Wefafa
//
//  Created by fafatime on 14-12-24.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogisticsTableViewCell : UITableViewCell

@property (nonatomic,weak)IBOutlet UILabel *stateName;
@property (nonatomic,weak)IBOutlet UILabel *timeLabel;
@property (nonatomic,weak)IBOutlet UIImageView *pointImgView;
@property (nonatomic,weak)IBOutlet UIImageView *lineImgView;
@property (nonatomic,weak)IBOutlet UIImageView *topImgView;

@end
