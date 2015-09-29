//
//  DetailOrderViewController.h
//  Wefafa
//
//  Created by fafatime on 14-8-22.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"
@class OrderModel;
@interface DetailOrderViewController : SBaseViewController/*UIViewController*/<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,CustomAlertViewDelegate>
{
    UIView *headShowView;
    UIView *bottVw;
    BOOL canModifyOrder;
}
@property(nonatomic,retain)NSDictionary *transDic;

@property (nonatomic,strong)OrderModel *transDicOrderModel;

@property (strong, nonatomic) IBOutlet UIView *headView;

@end
