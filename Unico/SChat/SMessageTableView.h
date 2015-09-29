//
//  SMessageTableView.h
//  Wefafa
//
//  Created by wave on 15/7/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMessageTableView : UITableView
@property (nonatomic, weak) UIViewController *target;
@property (nonatomic) NSMutableArray *contentArray;
+ (instancetype)instance;
- (void)reloadData_;
@end
