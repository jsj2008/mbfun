//
//  NewAddressViewController.h
//  Wefafa
//
//  Created by fafatime on 14-9-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditAddressViewController.h"
#import "MyAdderssViewController.h"

@protocol NewAddressViewControllerDelegate <NSObject>

@optional

-(void)callBackNewAddressViewControllerDelegateWithDeleteAddressByrow:(int)sender;

@end

@interface NewAddressViewController :SBaseViewController /*UIViewController*/<UITableViewDataSource,UITableViewDelegate,EditAddressViewControllerDelegate>
{
    UIControl *currentEditControl;
}
@property (assign,nonatomic) int row;
@property (strong,nonatomic) NSString *defaultAddrID;
@property (retain,nonatomic) NSMutableDictionary *showDic;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *myCountryCell;
@property(strong, nonatomic) IBOutlet UITableViewCell *myDetailCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (strong,nonatomic)IBOutlet UITableViewCell *mobileCell;
@property (strong,nonatomic)IBOutlet UITableViewCell *telCell;
@property (strong,nonatomic)IBOutlet UITableViewCell *emailCell;
@property (strong,nonatomic)IBOutlet UITableViewCell *chooseCell;
@property (strong,nonatomic)IBOutlet UITableViewCell *youbianCell;
@property (weak, nonatomic) IBOutlet UISwitch *swcDefault;

@property (strong, nonatomic) IBOutlet UITableViewCell *newcountryCell;

@property (strong, nonatomic) IBOutlet UITableViewCell *detailStreetCell;

@property (weak,nonatomic)id <NewAddressViewControllerDelegate> delegate;

- (IBAction)swcDefaultValueChanged:(id)sender;

@property (assign,nonatomic) MyAdderssViewController *mainview;
@end
