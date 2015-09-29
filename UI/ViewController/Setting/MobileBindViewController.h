//
//  MobileBindViewController.h
//  Wefafa
//
//  Created by fafa  on 13-9-13.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileBindViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *sections; //title, cells, title, cells,...
}

@property (assign, nonatomic) id preViewController; //用于刷新前一个界面


@property (strong, nonatomic) IBOutlet UIView *viewHead;



@property (strong, nonatomic) IBOutlet UITableViewCell *mobileTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *vaildcodeTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *bindTableViewCell;

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtMobile;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnGetVaildCode;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *tipGetVaildCode;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtVaildCode;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *viewMsg;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblMsg;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnBind;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *tipBind;

@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tvBindMobile;

- (IBAction)btnGetVaildCode_OnClick:(id)sender;
- (IBAction)btnBind_OnClick:(id)sender;

@end
