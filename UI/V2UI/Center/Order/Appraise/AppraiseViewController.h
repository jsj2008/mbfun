//
//  AppraiseViewController.h
//  BanggoPhone
//
//  Created by Juvid on 14-7-14.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface AppraiseViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
  
}
@property (strong, nonatomic)NSString *strOrderSn;//订单号
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)PressSend:(UIButton *)sender;//评论事件
@property (nonatomic, strong)NSMutableArray *arrList;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnSend;//评论按钮

@end
