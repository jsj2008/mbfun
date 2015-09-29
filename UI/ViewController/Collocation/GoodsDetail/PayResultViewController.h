//
//  PayResultViewController.h
//  Wefafa
//
//  Created by mac on 14-12-16.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayResultViewController : SBaseViewController
@property (weak, nonatomic) IBOutlet UIView *viewHead;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewShowComplete;

@property (weak, nonatomic) IBOutlet UILabel *lbComplete;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail;

@property (strong, nonatomic) NSString *orderCode;

- (IBAction)btnContinueClicked:(id)sender;
- (IBAction)btnDetailClicked:(id)sender;

@end
