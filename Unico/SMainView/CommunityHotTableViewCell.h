//
//  CommunityHotTableViewCell.h
//  Wefafa
//  时尚达人
//  Created by wave on 15/8/20.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SStarStoreCellModel;

static NSString *communityHotTableViewCellID = @"communityHotTableViewCellID";

@interface CommunityHotTableViewCell : UITableViewCell
@property (nonatomic, strong) SStarStoreCellModel *model;
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UIViewController *parentVC;
- (void)model:(SStarStoreCellModel*)model parentVC:(UIViewController*)target indexPath:(NSIndexPath*)indexPath;
@end
