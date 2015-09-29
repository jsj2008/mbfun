//
//  LogisticsTrackingController.h
//  BanggoPhone
//
//  Created by Juvid on 14-6-30.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MOrderShip.h"
//#import "OrderBox.h"
//#import "BGSever+User.h"
#import "BaseViewController.h"
@interface LogisticsTrackingController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
   
    NSMutableArray *arrList;
    NSMutableArray *arrLineHight;
     int PakeCount;
}
//@property int numPack;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSString *strOrderSn;

@end
