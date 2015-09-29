//
//  BuyButtonTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-11-5.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "UrlImageTableViewCell.h"
#import "WeFaFaGet.h"

@interface BuyButtonTableViewCell : UrlImageTableViewCell
{
    NSDictionary *_data;
    NSCondition *download_lock;
    SNSStaffFull *designerStaffFull;
    UIImageView *imageSeparator;
}

@property (strong, nonatomic) UILabel *lbDesigner;
@property (strong, nonatomic) UIButton *btnSetAtten;

+(int)getCellHeight:(id)data1;

@property (strong, nonatomic) UIButton *addshoppingTrolleyBtn;
@property (strong, nonatomic) UIButton *directBuyBtn;

@property (strong, nonatomic) id retainViewController;
@end
