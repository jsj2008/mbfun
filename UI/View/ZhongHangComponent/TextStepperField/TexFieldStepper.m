//
//  TexFieldStepper.m
//  Wefafa
//
//  Created by fafatime on 14-7-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "TexFieldStepper.h"

@interface TexFieldStepper ()



- (void)      initializeControl;
- (NSString*) getPlaceholderText;
- (void)      didChangeTextField;
@end


@implementation TexFieldStepper

@synthesize plusButton = _plusButton,
minusButton = _minusButton,
middleImage = _middleImage,
TypeChange = _value,
textField = _textField,
Current,
NumDecimals=_NumDecimals,
Maximum=_Maximum,
Minimum=_Minimum,
Step= _Step,
IsEditableTextField= _IsEditableTextField;

TextStepperFieldChangeKind _longTapLoopValue;
UIEdgeInsets insetMiddleImage={13,4,13,4};
UIEdgeInsets insetButtonImage={13,13,13,13};

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeControl];
    }
    return self;
}

- (void)awakeFromNib {
    [self initializeControl];
}

- (void)initializeControl {
    self.NumDecimals=0;
    self.Step=1;
    self.Maximum = INFINITY;
    self.Minimum = INFINITY*-1;
    self.autoresizesSubviews=YES;
    self.IsEditableTextField = TRUE;
    self.backgroundColor = [UIColor clearColor];
    self.multipleTouchEnabled = NO;
    self.clipsToBounds = YES;
    CGSize BFStepperButton = CGSizeMake(30, self.frame.size.height);
    
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textStepperViewBG.png"]];
    // button minus in to left
    _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.minusButton.frame = CGRectMake(0.0, 0.0, 30, 30);
//    [self.minusButton setBackgroundImage:[[UIImage imageNamed:@"textStepperBG.png"] resizableImageWithCapInsets:insetButtonImage] forState:UIControlStateNormal];
    [self.minusButton setTitle:@"-" forState:UIControlStateNormal];
    self.minusButton.titleLabel.font = [UIFont systemFontOfSize:22];
[self.minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.minusButton addTarget:self action:@selector(didPressMinusButton) forControlEvents:UIControlEventTouchUpInside];
    self.minusButton.autoresizingMask = UIViewAutoresizingNone; // push tu none
    self.minusButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.minusButton];
    
    // button plus in to right
    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.plusButton.frame = CGRectMake(self.frame.size.width - BFStepperButton.width, 0.0, 30, 30);
//    [self.plusButton setBackgroundImage:[[UIImage imageNamed:@"textStepperBG.png"]resizableImageWithCapInsets:insetButtonImage] forState:UIControlStateNormal];
    [self.plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.plusButton setTitle:@"+" forState:UIControlStateNormal];
    self.plusButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [self.plusButton addTarget:self action:@selector(didPressPlusButton) forControlEvents:UIControlEventTouchUpInside];
    self.plusButton.autoresizingMask = UIViewAutoresizingNone; // push to none
    self.plusButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.plusButton];
    
    
    //TextField the number
    _textField = [[UITextField alloc] init];
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.clearButtonMode = UITextFieldViewModeNever;
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.inputView = nil;
    self.textField.text = @"1";
//    self.textField.background = [UIImage imageNamed:@"textStepperBG.png"];
    [self.textField setKeyboardType:UIKeyboardTypeDecimalPad];
    self.textField.frame = CGRectMake(BFStepperButton.width,0,30,30);
    self.textField.textAlignment = NSTextAlignmentCenter;
    [self.textField addTarget:self action:@selector(didChangeTextField) forControlEvents: UIControlEventEditingChanged];
    self.textField.autoresizingMask = UIViewAutoresizingNone; // push to none
    self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.textField];
}


-(float) Current
{
    return [self.textField.text floatValue];
}

-(void) setCurrent:(float)pflValue
{
    self.textField.text = [NSString stringWithFormat:[@"%.Xf" stringByReplacingOccurrencesOfString:@"X" withString:[NSString stringWithFormat:@"%d", self.NumDecimals]], pflValue];
    
    
}
-(void) setIsEditableTextField:(BOOL)pIsEditableTextField
{
    _IsEditableTextField = pIsEditableTextField;
    
    self.textField.enabled = _IsEditableTextField;
}

-(void) setNumDecimals:(int)pNumDecimals
{
    if (_NumDecimals<0) {
        _NumDecimals =0;
    }
    
    _NumDecimals = pNumDecimals;
    
    self.Current = self.Current; // to re-display it correctly
}

-(void) didChangeTextField
{
    
    if ( self.Current < self.Minimum)
        self.Current = self.Minimum;
    
    if ( self.Current > self.Maximum)
        self.Current = self.Maximum;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


-(void) setTypeChange:(TextStepperFieldChangeKind)pTypeChange
{
    _value = pTypeChange;
    
    if (self.TypeChange ==TextStepperFieldChangeKindNegative)
    { // push -
        if ( self.Current > self.Minimum )
            self.Current = self.Current- self.Step;
        else
            self.Current = self.Minimum;
    }
    else
    { // push +
        if ( self.Current < self.Maximum)
            self.Current = self.Current+ self.Step;
        else
            self.Current = self.Maximum;
    }
    
}

#pragma mark Plus Button Events

- (void)didPressPlusButton {
    [self.textField resignFirstResponder];
    self.TypeChange = TextStepperFieldChangeKindPositive;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark Minus Button Events

- (void)didPressMinusButton {
    
    [self.textField resignFirstResponder];
    if (self.Current <= 1) {
        self.Current = 1;
    }
    else
    {
        self.TypeChange = TextStepperFieldChangeKindNegative;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
  
}

@end
