//
//  SBaseTableViewController.h
//  Wefafa
//
//  Created by unico on 15/5/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"

@interface  SBaseTableViewController : SBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray *list;
@property (nonatomic) NSInteger lastPageIndex;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic) float cellNowHeight;
-(void)updateData;
@end