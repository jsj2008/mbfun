//
//  GoodsDetailCommentTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-9-4.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "snsdataclass.h"

@interface GoodsDetailCommentTableViewCell : UITableViewCell
{
    NSDictionary *_data;
    NSCondition *download_lock;
    SNSStaffFull *staffFull;
    UIImageView *imageSeparator;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageHead;
@property (strong, nonatomic) IBOutlet UILabel *lbUserName;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UILabel *lbComment;

@property (strong, nonatomic) id data;

+(int)getCellHeight:(id)data1;

@end
