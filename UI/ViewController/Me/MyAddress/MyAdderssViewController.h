//
//  MyAdderssViewController.h
//  Wefafa
//
//  Created by fafatime on 14-9-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEventHandler.h"

@interface MyAdderssViewController :SBaseViewController/* UIViewController*/<UITableViewDelegate,UITableViewDataSource>
{
    
}

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong ,nonatomic) IBOutlet UITableView *listTableView;
@property (strong ,nonatomic) IBOutlet UITableViewCell *tableCell;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;

@property (strong, nonatomic) CommonEventHandler *onSelectedRow;

-(IBAction)addNewAddress:(id)sender;
-(void)NewAddressViewController_onRefreshRow:(id)sender eventData:(NSDictionary*)param;
-(void) setDefaultAddress:(NSString *)addrId isDefault:(BOOL)isDefault;

@end
