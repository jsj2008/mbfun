//
//  CustomCell.h
//  One
//
//  Created by fafatime on 14-3-28.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
{
    UILabel *titleLabel;
    UILabel *numberLabel;
    UILabel *loginOutLabel;
    
}
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic,retain)UILabel *numberLabel;
@property (nonatomic,retain)UILabel *loginOutLabel;


@end
