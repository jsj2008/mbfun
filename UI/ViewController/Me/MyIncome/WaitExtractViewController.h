//
//  WaitExtractViewController.h
//  Wefafa
//
//  Created by fafatime on 14-9-12.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
#import "DateWeekView.h"
@interface WaitExtractViewController :SBaseViewController /*UIViewController*/<UITableViewDataSource,UITableViewDelegate,DateWeekViewDelegate>
{
    
}
@property (nonatomic,retain)NSString *sellerId;
@property (nonatomic,retain)NSString *titleName;
@property (nonatomic,strong)IBOutlet UILabel *titleLabel;
@property (nonatomic,strong)IBOutlet UIView *navView;
@property (nonatomic,strong)IBOutlet UIView *selectCalendarView;
@property (nonatomic,strong)IBOutlet UIView *fromCalendar;
@property (nonatomic,strong)IBOutlet UILabel *fromLabel;
@property (nonatomic,strong)IBOutlet UILabel *toLabel;
@property (nonatomic,strong)IBOutlet UIImageView *fromImagView;
@property (nonatomic,strong)IBOutlet UIImageView *toImagView;
@property (nonatomic,strong)IBOutlet UIView *toCalendar;
@property (nonatomic,assign)BOOL isIncome;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (nonatomic,strong)UITableView *incomeTableView;
@property (nonatomic,strong)UITableView *balanceTableView;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)searchClick:(id)sender;
@end
