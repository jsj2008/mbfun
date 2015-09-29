//
//  EditAddressVController.h
//  BanggoPhone
//
//  Created by Samuel on 14-7-13.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "BaseViewController.h"
@interface EditAddressVController :BaseViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViews;

@property (assign)BOOL isAddControl;//添加新地址

@property (retain,nonatomic)NSMutableArray *addressCodeArray;

- (IBAction)setDefaultAddress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *setDefaultAddress;
@property (weak, nonatomic) IBOutlet UIButton *delectAddress;

- (IBAction)delectAddress:(id)sender;

@property (nonatomic,strong)id toShowData;//用于修改地址所传过来了数据

@end
