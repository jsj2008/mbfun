//
//  SBannerViewCell.h
//  Wefafa
//
//  Created by 凯 张 on 15/5/27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBaseTableViewCell.h"
#import "SMainViewController.h"
#import "SMDataModel.h"

@interface SBannerViewCell : SBaseTableViewCell
@property (nonatomic) NSDictionary *cellData;
@property (nonatomic) BOOL noImage;
-(void)updateCellUI;
-(void)updateCellUIWithModel:(SMBannerModle *)model;
@end
