//
//  DetailEarnTableViewCell.h
//  Wefafa
//
//  Created by fafatime on 14-9-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailEarnTableViewCell : UITableViewCell
{
    UILabel *inLabel;
    UILabel *inMoneyLabel;
    UILabel *timeLabel;
    UILabel *detailWhere;
}
@property (nonatomic,retain) UILabel *inMoneyLabel;
@property (nonatomic,retain) UILabel *timeLabel;
@property (nonatomic,retain) UILabel *detailWhere;
@property (nonatomic,retain) UILabel *inLabel;
@end
