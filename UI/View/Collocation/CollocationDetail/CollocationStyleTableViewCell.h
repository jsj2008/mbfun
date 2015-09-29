//
//  CollocationStyleTableViewCell.h
//  Wefafa
//
//  Created by zhangjiwen on 15/1/23.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageTableViewCell.h"

@interface CollocationStyleButton: UIButton
@property (nonatomic,strong) NSDictionary *sourceDict;
@end


@interface CollocationStyleTableViewCell : UrlImageTableViewCell
{
    NSArray *_data;
}
//@property (strong, nonatomic) UILabel *lbName;
//@property (strong, nonatomic) UILabel *lbPrice;
@property (nonatomic,strong) NSArray *styleArray;
+(int)getCellHeight:(id)data1;
@end
