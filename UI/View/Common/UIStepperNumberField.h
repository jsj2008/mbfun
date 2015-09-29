//
//  UIStepperNumberField.h
//  Wefafa
//
//  Created by mac on 14-8-26.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIStepperNumberField : UITextField
{
//    UIButton *leftButton;
//    UIButton *rightButton;
}

@property (strong, nonatomic) UIColor *stepperButtonColor;
@property (strong, nonatomic) UIColor *viewBorderColor;
@property (assign, nonatomic) int minValue;
@property (assign, nonatomic) int maxValue;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (assign, nonatomic) BOOL isComeFromOrder;//来自退款退货。
-(void)setText:(NSString *)text;

//数值改变时调用调用valueChanged事件

@end
