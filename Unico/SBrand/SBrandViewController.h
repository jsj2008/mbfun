//
//  SBrandViewController.h
//  Wefafa
//
//  Created by unico on 15/5/17.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBaseTableViewController.h"

@interface SBrandViewController : SBaseTableViewController
@property (nonatomic,assign) BOOL isComeFromTopic;//判断是从话题进入 还是从发现进入
@property (nonatomic,strong) NSString *brandID;

//@property (strong,nonatomic) NSArray *list;
//@property (strong, nonatomic) UITableView *tableView;
//@property (nonatomic, assign) VC_Type controllerType;
@end