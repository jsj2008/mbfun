//
//  CollocationDetailTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-8-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageTableViewCell.h"

@interface CollocationDetailTableViewCell : UrlImageTableViewCell
{
    NSDictionary *_data;
}

@property (strong, nonatomic) UILabel *lbName;
@property (strong, nonatomic) UILabel *lbPrice;

+(int)getCellHeight:(id)data1;

@end
