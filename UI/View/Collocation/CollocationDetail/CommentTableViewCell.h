//
//  CommentTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "UrlImageTableViewCell.h"
#import "WeFaFaGet.h"

@interface CommentTableViewCell : UrlImageTableViewCell
{
    NSDictionary *_data;
    NSCondition *download_lock;
    SNSStaffFull *staffFull;
    UIImageView *imageSeparator;
}

@property (strong, nonatomic) UILabel *lbUserName;
@property (strong, nonatomic) UILabel *lbDate;
@property (strong, nonatomic) UILabel *lbComment;
@property (strong, nonatomic) UIButton *btnLevel;

+(int)getCellHeight:(id)data1;

@end
