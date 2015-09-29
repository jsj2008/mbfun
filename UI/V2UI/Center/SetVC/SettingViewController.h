//
//  SettingViewController.h
//  BanggoPhone
//
//  Created by ISSUser on 14-6-30.
//  Copyright (c) 2014年 BG. All rights reserved.
//

//#import "BaseViewController.h"
#import "BaseViewController.h"
@interface SettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *vieFoot;
- (IBAction)PressExit:(UIButton *)sender;
@property (strong, nonatomic)NSArray *dataAry;
@end
