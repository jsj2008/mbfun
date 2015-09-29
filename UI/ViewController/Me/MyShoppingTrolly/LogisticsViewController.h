//
//  LogisticsViewController.h
//  Wefafa
//
//  Created by fafatime on 14-11-19.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogisticsTableViewCell.h"
@interface LogisticsViewController : SBaseViewController//UIViewController
{
    
}
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orederLabel;
@property (weak, nonatomic) IBOutlet UITableView *showTransTableView;
@property (weak,nonatomic) IBOutlet UITableViewCell *transTableVC;
@property (retain,nonatomic) NSDictionary* messageDic;
//@property (weak, nonatomic) IBOutlet LogisticsTableViewCell *logis;
@property (weak, nonatomic) IBOutlet UIView *showTransView;

- (IBAction)btnBackClick:(id)sender;

@end
