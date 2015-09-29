//
//  BasicTableVC.h
//  Designer
//
//  Created by Juvid on 15/1/15.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "BaseViewController.h"

@interface BasicTableVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic ,strong) NSMutableArray *mlArrList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
