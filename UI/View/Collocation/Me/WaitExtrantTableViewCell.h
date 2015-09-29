//
//  WaitExtrantTableViewCell.h
//  Wefafa
//
//  Created by fafatime on 14-9-12.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitExtrantTableViewCell : UITableViewCell
{
    UILabel *timeLabel;
    UILabel *statesLabel;
    UILabel *cardNumberLabel;
    UILabel *priceLabel;
    UILabel *bankLabel;
}
@property(nonatomic,retain)UILabel *timeLabel;
@property(nonatomic,retain)UILabel *statesLabel;
@property(nonatomic,retain)UILabel *cardNumberLabel;
@property(nonatomic,retain)UILabel *priceLabel;
@property(nonatomic,retain)UILabel *bankLabel;
@property(nonatomic,retain)UILabel *buyNameLabel;
@property(nonatomic,retain)UILabel *buyLabel;
@end
