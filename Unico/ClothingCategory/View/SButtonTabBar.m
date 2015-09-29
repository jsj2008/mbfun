//
//  SButtonTabBar.m
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SButtonTabBar.h"



@interface SButtonTabBar ()
{
    NSArray *_titlesButtonArray;
    UIView  *_selectedBottomLineView;
    
    int _selectedIndex;
}

@end



@implementation SButtonTabBar


@synthesize buttons = _titlesButtonArray;

- (void)setButtons:(NSArray *)buttons
{
    if (_titlesButtonArray != nil)
    {
        for (UIButton *button in _titlesButtonArray)
        {
            [button removeFromSuperview];
        }
    }
    
    _titlesButtonArray = buttons;
    
    for (int i=0; i<[_titlesButtonArray count]; i++)
    {
        UIButton *button = [_titlesButtonArray objectAtIndex:i];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
    
    [self layoutSubviews];
    
    [self setSelectedIndex:0];
}

- (void)setSelectedIndex:(int)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger )selectedIndex animated:(BOOL)animated
{
    _selectedIndex = 0;
    
    if (_titlesButtonArray == nil)
    {
        return;
    }
    
    NSUInteger buttonCount = [_titlesButtonArray count];
    
    if (buttonCount == 0)
    {
        return;
    }
    
    _selectedIndex = (int)selectedIndex;
    
    for (int i=0; i<[_titlesButtonArray count]; i++)
    {
        UIButton *button = [_titlesButtonArray objectAtIndex:i];
        
        if (i == _selectedIndex)
        {
            [button setTitleColor:[UIColor colorWithRed:0x3b/255.0 green:0x3b/255.0 blue:0x3b/255.0 alpha:1] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor colorWithRed:0xbb/255.0 green:0xbb/255.0 blue:0xbb/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }
    
    UIButton  *currentButton = [_titlesButtonArray objectAtIndex:selectedIndex];
    if (animated)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _selectedBottomLineView.center = CGPointMake(currentButton.center.x, _selectedBottomLineView.center.y);
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        _selectedBottomLineView.center = CGPointMake(currentButton.center.x, _selectedBottomLineView.center.y);
    }
}

- (void)buttonClick:(UIButton *)button
{
    
    if (button.tag < [_titlesButtonArray count])
    {
        [self setSelectedIndex:button.tag animated:YES];
    }
    
    _selectedIndex = (int)button.tag;
    
    NSUInteger allTargetsCount = [[self.allTargets allObjects] count];
    
    for (int i=0; i<allTargetsCount; i++)
    {
        id target = [[self.allTargets allObjects] objectAtIndex:i];
        NSArray *actions = [self actionsForTarget:target forControlEvent:UIControlEventValueChanged];
        
        for (NSString *actionString in actions)
        {
            SEL action = NSSelectorFromString(actionString);
            
            if ([target respondsToSelector:action])
            {
                [target performSelector:action withObject:self];
            }
        }
    }
}

- (void)initSubviews
{
    self.autoLayoutButtons = YES;
    
    _selectedBottomLineView = [[UIView alloc] init];
    _selectedBottomLineView.backgroundColor = [UIColor colorWithRed:0xfe/255.0 green:0xdc/255.0 blue:0x32/255.0 alpha:1];
    _selectedBottomLineView.layer.transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addSubview:_selectedBottomLineView];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [self initSubviews];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        [self initSubviews];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_titlesButtonArray == nil)
    {
        return;
    }
    
    NSUInteger buttonCount = [_titlesButtonArray count];
    
    if (buttonCount == 0)
    {
        return;
    }
    
    if (self.autoLayoutButtons)//自动布局button
    {
        float buttonWidth = self.width/buttonCount;
        float buttonHeight = self.height;
        
        for (int i=0; i<buttonCount; i++)
        {
            UIButton *button = [_titlesButtonArray objectAtIndex:i];
            button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, buttonHeight);
            
            //button.layer.borderColor = [UIColor redColor].CGColor;
            //button.layer.borderWidth = 2;
        }
    }
    
    float k = UI_SCREEN_WIDTH/750.0; //UI尺寸调整系数
    
    _selectedBottomLineView.frame = CGRectMake(0, self.bounds.size.height-6*k, 80 * k, 6*k);
    UIButton *currentButton = [_titlesButtonArray objectAtIndex:_selectedIndex];
    _selectedBottomLineView.center = CGPointMake(currentButton.center.x, _selectedBottomLineView.center.y);
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (controlEvents & UIControlEventValueChanged)
    {
        [super addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    }
}

@end

