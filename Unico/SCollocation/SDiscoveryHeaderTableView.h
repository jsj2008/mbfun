//
//  SDiscoveryHeaderTableView.h
//  Wefafa
//
//  Created by Jiang on 8/13/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDiscoveryFlexibleModel, SDiscoveryHeaderTableView;

@protocol SDiscoveryHeaderTableViewDelegate <NSObject>

- (void)tableScrollViewDidScroll:(SDiscoveryHeaderTableView *)tableView;
- (void)tableBeginScroll:(SDiscoveryHeaderTableView *)tableView;

@end

@interface SDiscoveryHeaderTableView : UITableView

@property (nonatomic, assign) id<SDiscoveryHeaderTableViewDelegate> tableDelegate;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, assign) UIViewController *target;

@end
