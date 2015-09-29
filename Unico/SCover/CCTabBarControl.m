//
//  CCTabBarControl.m
//  Wefafa
//
//  Created by chen cheng on 15/7/7.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CCTabBarControl.h"
#import "SUtilityTool.h"

@implementation CCTabBarControl

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    
    if (_titles == nil)
    {
        return;
    }
    
    NSUInteger buttonCount = [_titles count];
    
    if (buttonCount == 0)
    {
        return;
    }
    
    if (_titlesButtonArray != nil)
    {
        for (UIButton *button in _titlesButtonArray)
        {
            [button removeFromSuperview];
        }
    }
    
    
    NSMutableArray *buttonMutableArray = [[NSMutableArray alloc] init];
    for (int i=0; i<buttonCount; i++)
    {
        NSString *title = [titles objectAtIndex:i];
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        
        [button setTitleColor:COLOR_C3 forState:UIControlStateNormal];
        button.titleLabel.font = FONT_T2;
        [button setTitle:title forState:UIControlStateNormal];
        
        [buttonMutableArray addObject:button];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
    
    _titlesButtonArray = [buttonMutableArray copy];
    
    [self layoutSubviews];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

/*- (void)setSelectedIndex:(NSUInteger )selectedIndex animated:(BOOL)animated
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
}*/


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
    
    UIButton  *currentButton = [_titlesButtonArray objectAtIndex:selectedIndex];
    
    if (animated)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _selectedBottomLineView.center = CGPointMake(currentButton.center.x, _selectedBottomLineView.center.y);
            _selectedBottomBgView.center = CGPointMake(currentButton.center.x, _selectedBottomBgView.center.y);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        _selectedBottomLineView.center = CGPointMake(currentButton.center.x, _selectedBottomLineView.center.y);
        _selectedBottomBgView.center = CGPointMake(currentButton.center.x, _selectedBottomBgView.center.y);
    }
}

- (void)buttonClick:(UIButton *)button
{
    if (button.tag == _selectedIndex)
    {
        return;
    }
    
    self.preSelectedIndex = _selectedIndex;
    
    if (button.tag < [_titles count])
    {
        [self setSelectedIndex:button.tag animated:YES];
    }
    
    _selectedIndex = button.tag;
    
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

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _selectedBottomBgView = [[UIView alloc] init];
        _selectedBottomBgView.backgroundColor = COLOR_C5;
        [self addSubview:_selectedBottomBgView];
        
        _selectedBottomLineView = [[UIView alloc] init];
        _selectedBottomLineView.backgroundColor = COLOR_C1;
        _selectedBottomLineView.layer.transform = CATransform3DMakeTranslation(0, 0, 100);
        [self addSubview:_selectedBottomLineView];
        
        _targetMutableArray = [[NSMutableArray alloc] init];
        _actionMutableArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        _selectedBottomBgView = [[UIView alloc] init];
        _selectedBottomBgView.backgroundColor = COLOR_C5;
        [self addSubview:_selectedBottomBgView];
        
        _selectedBottomLineView = [[UIView alloc] init];
        _selectedBottomLineView.backgroundColor = COLOR_C1;
        _selectedBottomLineView.layer.transform = CATransform3DMakeTranslation(0, 0, 100);
        [self addSubview:_selectedBottomLineView];
        
        
        
        _targetMutableArray = [[NSMutableArray alloc] init];
        _actionMutableArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithTitles:(NSArray *)titles
{
    self = [super init];
    if (self != nil)
    {
        self.titles = titles;
        
        _selectedBottomBgView = [[UIView alloc] init];
        _selectedBottomBgView.backgroundColor = COLOR_C5;
        [self addSubview:_selectedBottomBgView];
        
        _selectedBottomLineView = [[UIView alloc] init];
        _selectedBottomLineView.backgroundColor = COLOR_C1;
        _selectedBottomLineView.layer.transform = CATransform3DMakeTranslation(0, 0, 100);
        [self addSubview:_selectedBottomLineView];
        
        
        
        
        
        _targetMutableArray = [[NSMutableArray alloc] init];
        _actionMutableArray = [[NSMutableArray alloc] init];
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
    
    float buttonWidth = self.bounds.size.width/buttonCount;
    float buttonHeight = self.bounds.size.height;
    
    for (int i=0; i<buttonCount; i++)
    {
        UIButton *button = [_titlesButtonArray objectAtIndex:i];
        
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, buttonHeight);
        
        if (i != _selectedIndex)
        {
            [button setTitleColor:COLOR_C7 forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:COLOR_C3 forState:UIControlStateNormal];
        }
        
        
        
        button.titleLabel.font = FONT_T2;
        //[button setBackgroundColor:COLOR_C2];
        [button setBackgroundColor:[UIColor colorWithRed:0x3b/255.0 green:0x3b/255.0 blue:0x3b/255.0 alpha:0.5]];
    }
    
    
    _selectedBottomBgView.frame = CGRectMake(0, 0, buttonWidth, self.bounds.size.height);
    _selectedBottomLineView.frame = CGRectMake(0, self.bounds.size.height-6, buttonWidth, 6);
    
    UIButton *currentButton = [_titlesButtonArray objectAtIndex:_selectedIndex];
    
    _selectedBottomLineView.center = CGPointMake(currentButton.center.x, _selectedBottomLineView.center.y);
    _selectedBottomBgView.center = CGPointMake(currentButton.center.x, _selectedBottomBgView.center.y);
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (controlEvents & UIControlEventValueChanged)
    {
        [super addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    }
}

@end

