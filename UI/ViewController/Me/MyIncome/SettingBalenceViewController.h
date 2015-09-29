//
//  SettingBalenceViewController.h
//  Wefafa
//
//  Created by fafatime on 15-1-26.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingBalenceViewController :SBaseViewController/* UIViewController*/
{
    
}
@property (nonatomic,strong) IBOutlet UIView *headView;
@property (nonatomic,strong) IBOutlet UIView *tableHeadView;

@property (weak, nonatomic) IBOutlet UITableView *setBanlenceTableV;
@property (nonatomic,strong) IBOutlet UIButton *updateBtn;
@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) IBOutlet UILabel *numberLable;
@property (nonatomic,strong) IBOutlet UILabel *stateLabel;
@property (nonatomic,retain) NSDictionary *balenceDic;

-(IBAction)questReturn:(id)sender;


@end
