//
//  DatePickerViewController.h
//  selector
//
//  Created by mac on 12-12-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSMutableArray *dayArray;
    NSMutableArray *hourArray;
    NSMutableArray *minuteArray;
    NSMutableArray *pickerArray;

    int currentYear; //固定
    int year;
    int month;  
    int day;  
    int hour;
    int min;  
    int week;    
    int sec;
}

@property (retain, nonatomic) IBOutlet UIPickerView *dateTimePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil date:(NSDate *)startDate;
-(NSString *)getDateString;
-(NSDate *)getDate;
-(void)setPickDateTime:(NSDate *)curr_date;

@end
