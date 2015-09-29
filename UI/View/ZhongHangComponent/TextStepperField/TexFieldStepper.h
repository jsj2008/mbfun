//
//  TexFieldStepper.h
//  Wefafa
//
//  Created by fafatime on 14-7-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TextStepperFieldChangeKindNegative = -1, // event means one step down
    TextStepperFieldChangeKindPositive = 1 // event means one step up
} TextStepperFieldChangeKind;

@interface TexFieldStepper : UIControl


@property (nonatomic, assign, readonly) TextStepperFieldChangeKind TypeChange;

//curren value
@property (nonatomic,assign) float Current;

//number of decimals places to display
@property (nonatomic,assign) int NumDecimals;

// increase when using + or -
@property (nonatomic,assign) float Step;

// maximum value
@property (nonatomic,assign) float Maximum;

// minimum value
@property (nonatomic,assign) float Minimum;

// set editable TextField
@property (nonatomic,assign) BOOL IsEditableTextField;


@property (nonatomic, retain, readonly) UIButton *plusButton;
@property (nonatomic, retain, readonly) UIButton *minusButton;
@property (nonatomic, retain, readonly) UIImageView *middleImage;
@property (nonatomic, retain, readonly) UITextField  *textField;


@end
