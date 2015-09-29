//
//  CommunityHotTableView.h
//  Wefafa
//
//  Created by wave on 15/8/17.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *lastcellID = @"lastcellID";

@interface Lastcell : UITableViewCell

@end

@interface CommunityHotTableView : UITableView
@property (nonatomic) UIViewController *parentVC;
@end
