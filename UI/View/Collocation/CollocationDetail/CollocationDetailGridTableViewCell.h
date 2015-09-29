//
//  CollocationDetailGridTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-9-18.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "UrlImageTableViewCell.h"

@interface CollocationDetailGridTableViewCell : UrlImageTableViewCell
{
    NSArray *_data;
    NSMutableArray *uigridArray;
}

@property (strong, nonatomic) UILabel *lbName;
@property (strong, nonatomic) UILabel *lbTime;

+(int)getCellHeight:(id)data1;

@end
