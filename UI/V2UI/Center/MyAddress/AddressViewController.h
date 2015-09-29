//
//  AddressViewController.h
//  BanggoPhone
//
//  Created by issuser on 14-6-24.
//  Copyright (c) 2014年 BG. All rights reserved.
//

//#import "BaseViewController.h"
#import "BaseViewController.h"
@interface AddressViewController : BaseViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViews;
- (void)changeAddress:(NSIndexPath*)indexPath;
- (IBAction)creatNewAddress:(id)sender;
@property BOOL isRight;

@property (weak, nonatomic) IBOutlet UIButton *addNewAddress;

@end
