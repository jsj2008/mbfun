//
//  UIStepperNumberField.m
//  Wefafa
//
//  Created by mac on 14-8-26.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "UIStepperNumberField.h"
#import "Globle.h"
@implementation UIStepperNumberField
@synthesize leftButton;
@synthesize rightButton;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitWithFrame:frame];
    }
    return self;
}

-(void)awakeFromNib
{
    [self innerInitWithFrame:self.frame];
}

-(void)innerInitWithFrame:(CGRect)frame
{
   // old
//    _viewBorderColor=[UIColor grayColor];
//    _stepperButtonColor=[UIColor grayColor];
    self.backgroundColor = [UIColor whiteColor];
    _viewBorderColor=[UIColor colorWithHexString:@"#e2e2e2"];
    _stepperButtonColor=[UIColor colorWithHexString:@"#e2e2e2"];
//    return;
    _minValue=1;
    _maxValue=2147483647;
    self.textAlignment = NSTextAlignmentCenter; //水平左对齐
    self.text=[NSString stringWithFormat:@"%d",_minValue];
    self.keyboardType=UIKeyboardTypeNumberPad;
    if (leftButton == nil) {
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(textFieldChangedCheck:)
//                                                     name:UITextFieldTextDidChangeNotification
//                                                   object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
    }
//    leftButton.frame=self.bounds;
    [leftButton setTitleColor:_stepperButtonColor forState:UIControlStateNormal];
    leftButton.titleLabel.font=[UIFont boldSystemFontOfSize:20];
    if ([UIImage imageNamed: @"btn_add_minus@2x.png"]==nil)//btn_minus_pressed@3x.png
        [leftButton setTitle:@"-" forState:UIControlStateNormal];
    else
    {//btn_minus_pressed@3x.png
        [leftButton setImage:[UIImage imageNamed: @"btn_add_minus@2x.png"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed: @"btn_minus_normal@3x.png"] forState:UIControlStateDisabled];
    }
    leftButton.layer.borderColor = _viewBorderColor.CGColor;
    leftButton.layer.borderWidth =0.5;
   
    
    [leftButton addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    self.leftView=leftButton;
    self.leftViewMode = UITextFieldViewModeAlways;
    leftButton.enabled=NO;

    if (rightButton == nil) {
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
    }
//    rightButton.frame=CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    [rightButton setTitleColor:_stepperButtonColor forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont boldSystemFontOfSize:20];
    if ([UIImage imageNamed: @"btn_add@2x.png"]==nil)//btn_plus_normal@3x
        [rightButton setTitle:@"+" forState:UIControlStateNormal];
    else
    {//btn_plus_normal@3x
        [rightButton setImage:[UIImage imageNamed: @"btn_add@2x.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed: @"btn_plus_pressed@3x.png"] forState:UIControlStateDisabled];
    }
    rightButton.layer.borderColor = _viewBorderColor.CGColor;
    rightButton.layer.borderWidth =0.5;
   
    [rightButton addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    self.rightView=rightButton;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    self.layer.borderWidth=0.5;
    self.layer.borderColor = _viewBorderColor.CGColor;
    self.layer.cornerRadius = 1;
    self.layer.masksToBounds = YES;
    self.borderStyle=UITextBorderStyleNone;
}

-(void)textFieldEndEditing:(NSNotification *)obj
{
    UITextField *txt=(UITextField *)obj.object;
    if (txt.text.length==0)
    {
        txt.text=[NSString stringWithFormat:@"%d",_minValue];
    }
    
    int val=[txt.text intValue];
    if (val<=_minValue)
    {
        txt.text=[NSString stringWithFormat:@"%d",_minValue];
        leftButton.enabled=NO;
    }
    else
        leftButton.enabled=YES;
    
    if (val>=_maxValue)
    {
        txt.text=[NSString stringWithFormat:@"%d",_maxValue];
        rightButton.enabled=NO;
    }
    else
        rightButton.enabled=YES;
    
    //数值改变时调用调用valueChanged事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
//-(void)textFieldChangedCheck:(NSNotification *)obj
//{
//    UITextField *txt=(UITextField *)obj.object;
//    if (txt.text.length==0)
//    {
//        txt.text=[NSString stringWithFormat:@"%d",_minValue];
//    }
//    
//    int val=[txt.text intValue];
//    if (val<=_minValue)
//    {
//        txt.text=[NSString stringWithFormat:@"%d",_minValue];
//        leftButton.enabled=NO;
//    }
//    else
//        leftButton.enabled=YES;
//    
//    if (val>=_maxValue)
//    {
//        txt.text=[NSString stringWithFormat:@"%d",_maxValue];
//        rightButton.enabled=NO;
//    }
//    else
//        rightButton.enabled=YES;
//    
//    //数值改变时调用调用valueChanged事件
//    [self sendActionsForControlEvents:UIControlEventValueChanged];
//}

-(void)setText:(NSString *)text
{
    [super setText:text];

    int val=[text intValue];
    if (val<=_minValue)
    {
        leftButton.enabled=NO;
    }
    else
        leftButton.enabled=YES;
    
    if (val>=_maxValue)
    {
        rightButton.enabled=NO;
    }
    else
        rightButton.enabled=YES;
}
-(void)stepperValueChanged:(id)sender
{
    int val=[self.text intValue];
    if (sender== leftButton)
    {
        val=(--val)>_minValue?val:_minValue;
        self.text=[NSString stringWithFormat:@"%d",val];
    }
    if (sender== rightButton)
    {
        val=(++val)<_maxValue?val:_maxValue;
        self.text=[NSString stringWithFormat:@"%d",val];
    }
    /////
    if (val<=_minValue)
    {
        leftButton.enabled=NO;
    }
    else
    {
        leftButton.enabled=YES;
    }
    if (val>=_maxValue)
    {
        
        if(self.isComeFromOrder==YES)
        {
            rightButton.enabled=NO;//NO
//            if (val>_maxValue) {
//            
//                [Toast makeToast:@"不能超过最大数量!" duration:2 position:@"center"];
//            }
   
        }
        else
        {
            rightButton.enabled=YES;//NO
            if(_maxValue!=20)
            {
                [Toast makeToast:@"商品的库存不足!" duration:2 position:@"center"];
            }
            else
            {
                
                [Toast makeToast:@"不能超过最大购买数!" duration:2 position:@"center"];
                
            }
        }

    }
    else
    {
        rightButton.enabled=YES;
    }
    //数值改变时调用调用valueChanged事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)setMaxValue:(int)maxValue
{
    _maxValue=maxValue;
    
    int val=[self.text intValue];
    if (val>=_maxValue)
    {
        rightButton.enabled=YES;//no
    }
    else
    {
        rightButton.enabled=YES;
    }
}
@end
