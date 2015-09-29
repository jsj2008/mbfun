//
//  DateWeekView.m
//  Wefafa
//
//  Created by mac on 14-7-1.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "DateWeekView.h"
#import "NSDateAdditions.h"

@implementation DateWeekView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self innerInit];
}

-(void)innerInit
{
    //self.frame=CGRectMake(self.frame.origin.x,self.frame.origin.y,202,30);
    _txtDate=[[UITextField alloc] initWithFrame:CGRectMake(10,0,250,30)];
    _txtDate.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    _txtDate.delegate=self;
    [_txtDate addTarget:self action:@selector(txtDateEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self addSubview:_txtDate];
    
    _lbWeek=[[UITextField alloc] initWithFrame:CGRectMake(150, 5, 55, 19)];
    _lbWeek.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    _lbWeek.delegate=self;
    [_lbWeek addTarget:self action:@selector(txtDateEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self addSubview:_lbWeek];
    
    [self setCurrentDate:[NSDate date]];
    
//    _lbWeek.userInteractionEnabled=YES;
//    UITapGestureRecognizer *singleTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(txtDateEditingDidBegin:)];
////    singleTouch.cancelsTouchesInView=NO;
//    [_lbWeek addGestureRecognizer:singleTouch];
}

- (IBAction)txtDateEditingDidBegin:(id)sender {
    
 
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(choiceDateClicked:)])
    {
        [_delegate choiceDateClicked:self];
    }
}

-(void)setCurrentDate:(NSDate*)currdate
{
    //"yyyy-MM-dd"
    _currentDate=[NSDate parse:[currdate toString:@"yyyy-MM-dd"] format:@"yyyy-MM-dd"];
    [self setTextValue:currdate];
}

-(NSDate*)currentDate
{
    return _currentDate;
}

-(void)setTextValue:(NSDate *)currdate
{
    NSInteger unitFlags = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSWeekdayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    
    NSDateComponents *conponent= [cal components:unitFlags fromDate:currdate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *nsDateString= [NSString  stringWithFormat:@"%4d年%0.2d月%0.2d日",year,month,day];
    NSUInteger weekday = [conponent weekday];
    self.txtDate.text=nsDateString;
    
    if(weekday==1)
    {
        self.lbWeek.text=@"星期日";
    }else if(weekday==2){
        self.lbWeek.text=@"星期一";
    }else if(weekday==3){
        self.lbWeek.text=@"星期二";
    }else if(weekday==4){
        self.lbWeek.text=@"星期三";
    }else if(weekday==5){
        self.lbWeek.text=@"星期四";
    }else if(weekday==6){
        self.lbWeek.text=@"星期五";
    }else if(weekday==7){
        self.lbWeek.text=@"星期六";
    }
}

-(void)setInputView:(UIView*)view;
{
    self.txtDate.inputView=view;
    self.lbWeek.inputView = view;
}

-(void)setInputAccessoryView:(UIView*)view;
{
    self.txtDate.inputAccessoryView=view;
    self.lbWeek.inputAccessoryView = view;
}

-(BOOL)endEditing:(BOOL)force
{
    [self.txtDate endEditing:force];
    [self.lbWeek endEditing:force];
    return [super endEditing:force];
}

@end
