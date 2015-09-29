//
//  CustomListTableViewCell.h
//  One
//
//  Created by fafatime on 14-3-30.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomListTableViewCell : UITableViewCell
{
    UIImageView *headImgView;
    UILabel *titleLabel;
    UILabel *timeLabel;
//    UILabel *detailLabel;
    UITextView *detailTextView;
    
    
}
@property (retain, nonatomic)UIImageView *headImgView;
@property (retain,nonatomic)UILabel *titleLabel;
@property (retain,nonatomic)UILabel *timeLabel;
@property (retain,nonatomic)UILabel *detailLabel;
@property (retain,nonatomic)UITextView *detailTextView;
@property (retain,nonatomic)UIImageView *arrowImage;
@end
