//
//  DetailEarningViewController.h
//  Wefafa
//
//  Created by fafatime on 14-9-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailEarningViewController : SBaseViewController/*UIViewController*/<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (retain,nonatomic) NSString *chooseTime;
@property (retain,nonatomic) NSDictionary *paramDic;

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UILabel *headNameLabel;
@property (strong, nonatomic) IBOutlet UIView *showAllView;
@property (strong, nonatomic) IBOutlet UILabel *allAmountLabel;
@property (strong, nonatomic) IBOutlet UITableView *productTableView;
@property (strong, nonatomic) IBOutlet UIView *transView;
@property (strong, nonatomic) IBOutlet UIView *orderView;
//@property (strong, nonatomic) IBOutlet UIView *transDetailLabel;
@property (strong, nonatomic) IBOutlet UILabel *buyerLabel;
@property (strong, nonatomic) IBOutlet UILabel *dutyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *shareNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *payStyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *transDetailLabel;


- (IBAction)btnBackClick:(id)sender;
@end
