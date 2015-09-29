//
//  DateWeekView.h
//  Wefafa
//
//  Created by mac on 14-7-1.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateWeekViewDelegate <NSObject>

@optional
-(void)choiceDateClicked:(id)sender;

@end


@interface DateWeekView : UIView<UITextFieldDelegate>
{
    NSDate *_currentDate;
}
@property (nonatomic, assign)id<DateWeekViewDelegate>   delegate;
@property (strong, nonatomic) IBOutlet UITextField *txtDate;
@property (strong, nonatomic) IBOutlet UITextField *lbWeek;



-(void)innerInit;
-(void)setCurrentDate:(NSDate*)currdate;
-(NSDate*)currentDate;

- (IBAction)txtDateEditingDidBegin:(id)sender;

-(void)setInputView:(UIView*)view;
-(void)setInputAccessoryView:(UIView*)view;

@end
