//
//  CustomNormalListViewCell.h
//  Wefafa
//
//  Created by mac on 14-8-20.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CustomListViewCellHeight 48

@interface CustomNormalListViewCell : UITableViewCell

@property (retain, nonatomic)UIImageView *imageHead;
@property (retain,nonatomic)UILabel *lbTitle;
//@property (retain,nonatomic)UILabel *timeLabel;
@property (retain,nonatomic)UILabel *lbDetail;

@end
