//
//  MyOrderViewController.h
//  Wefafa
//
//  Created by mac on 14-8-2.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "MBTabsView.h"
#import "OrderStausCell.h"
#import "CustomAlertView.h"

@interface MyOrderViewController : SBaseViewController/*UIViewController*/<MBCustomClassifyModelViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,CustomAlertViewDelegate>
{
  
}
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (assign, nonatomic) OrderStatus status;
@end
