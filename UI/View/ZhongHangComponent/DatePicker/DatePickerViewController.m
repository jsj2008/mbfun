//
//  DateTimePickerViewController.m
//  selector
//
//  Created by mac on 12-12-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initPickerArray:[NSDate date]];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil date:(NSDate *)startDate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initPickerArray:startDate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setDateTimePicker:nil];
    [super viewDidUnload];
}

#if ! __has_feature(objc_arc)
- (void)dealloc {
    [yearArray release];
    [monthArray release];
    [dayArray release];
    [hourArray release];
    [minuteArray release];
    [pickerArray release];

    [dateTimePicker release];    
    [super dealloc];
}
#endif


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(int) getMonthOfDayNum:(int)year1 Month:(int)month1
{
    int days1;
    if (month1 != 2) {
        if (month1 == 4 || month1 == 6 || month1 == 9 || month1 == 11) {
            days1 = 30;
        } else {
            days1 = 31;
        }
    } else {
        if (((year1 % 4) == 0 && (year1 % 100) != 0) || (year1 % 400) == 0) {
            days1 = 29;
        } else {
            days1 = 28;
        }
    }
    return days1;
}

-(void)setPickDateTime:(NSDate *)curr_date
{
    [self initPickerArray:curr_date];
    [_dateTimePicker reloadAllComponents];
}

-(void)initPickerArray:(NSDate *)curr_date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; 
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |  
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit; 
    NSDateComponents *comps = [calendar components:unitFlags fromDate:curr_date];
    currentYear=year=(int)[comps year];
    month = (int)[comps month];
    day = (int)[comps day];
    hour = (int)[comps hour];
    min = (int)[comps minute];
    week = (int)[comps weekday];
    sec = (int)[comps second];
#if ! __has_feature(objc_arc)
    [calendar release];
#endif

    yearArray=[[NSMutableArray alloc] init];
    for (int i=0;i<3;i++)
    {
        NSString *str=[[NSString alloc] initWithFormat:@"%d年",currentYear+i];
        [yearArray addObject:str];
#if ! __has_feature(objc_arc)
        [str release];
#endif
    }
    monthArray=[[NSMutableArray alloc] init];
    for (int i=0;i<12;i++)
    {
        NSString *str=[[NSString alloc] initWithFormat:@"%0.2d月",i+1];
        [monthArray addObject:str];
#if ! __has_feature(objc_arc)
        [str release];
#endif
    }
    dayArray=[[NSMutableArray alloc] init];
    [self setPickDaysArray];

    pickerArray=[[NSMutableArray alloc] initWithObjects:yearArray, monthArray, dayArray, nil];
    
    [((UIPickerView *)self.view) selectRow:month-1 inComponent:1 animated:NO];
    [((UIPickerView *)self.view) selectRow:day-1 inComponent:2 animated:NO];
}

-(void)setPickDaysArray
{
    if ([dayArray count]>0)
        [dayArray removeAllObjects];
    for (int i=0;i<[self getMonthOfDayNum:year Month:month];i++)
    {
        NSString *str=[[NSString alloc] initWithFormat:@"%0.2d日",i+1];
        [dayArray addObject:str];
#if ! __has_feature(objc_arc)
        [str release];
#endif
    }
}
/////////////////////////////////////////////////
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //这个picker里的组键数
    return [pickerArray count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSMutableArray *arr=[pickerArray objectAtIndex:component];
    return [arr count];  //数组个数
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    UILabel *myView = nil;
    float myViewWidth=0;
    switch (component) {
        case 0:
        {
            myViewWidth=65;
            
            break;
        }
        case 1:
        {
            myViewWidth=45;
            break;
        }
        case 2:
        {
            myViewWidth=45;
            break;
        }
        default:
            break;  
    }
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, myViewWidth, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    
    NSMutableArray *arr=[pickerArray objectAtIndex:component];
    myView.text = [arr objectAtIndex:row];
    
    myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
    
    myView.backgroundColor = [UIColor clearColor];

    return myView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component

{
    
    CGFloat componentWidth = 0.0;
    
    switch (component) {
        case 0:
        {
            componentWidth = 65;
            
            break;
        }
        case 1:
        {
            componentWidth = 45;
            
            break;
        }
        case 2:
        {
            componentWidth = 45;
            
            break;
        }
        default:
            break;  
    }
    
    
    return componentWidth;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

-(void)setAllPickerData
{
    year = (int)[_dateTimePicker selectedRowInComponent:0]+currentYear;
    month = (int)[_dateTimePicker selectedRowInComponent:1]+1;
    day = (int)[_dateTimePicker selectedRowInComponent:2]+1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    NSString *result = [pickerView pickerView:pickerView titleForRow:row forComponent:component];
    [self setAllPickerData];
    if (component==0) //年
    {
        year=(int)row+currentYear;
    }
    if (component==1) //月
    {
        month=(int)row+1;
    }
    if (component==2) //日
    {
        day=(int)row+1;
    }
    [self setPickDaysArray];
    [pickerView reloadAllComponents];
}

-(NSString *)getDateString
{
    NSString *ret=[[NSString alloc] initWithFormat:@"%0.4d-%0.2d-%0.2d %0.2d:%0.2d:00",year,month,day,hour,min];
    return ret;
}

-(NSDate *)getDate
{
    NSString* datestring = [NSString stringWithFormat:@"%4d%0.2d%0.2d",year,month,day];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyyMMdd"];
    return [inputFormatter dateFromString:datestring];
}

@end
