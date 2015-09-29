//
//  SVerticalScrollButtonTabBar.m
//  Wefafa
//
//  Created by chencheng on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SVerticalScrollButtonTabBar.h"
#import "SUtilityTool.h"

@interface SVerticalScrollButtonTabBar()
{
    UIScrollView  *_buttonScrollView;
    
    NSMutableArray *_titlesButtonArray;
    UIView  *_selectedLeftLineView;
    
    int _selectedIndex;
    
    float _originY;
    float _spacing;
}

@end

@implementation SVerticalScrollButtonTabBar

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
    
    _titlesButtonArray = [buttons mutableCopy];
    
    for (int i=0; i<[_titlesButtonArray count]; i++)
    {
        UIButton *button = [_titlesButtonArray objectAtIndex:i];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_buttonScrollView addSubview:button];
    }
    
    [self layoutSubviews];
    
    [self setSelectedIndex:0];
}

- (void)setTitles:(NSArray *)titles
{
    if (_titlesButtonArray != nil)
    {
        for (UIButton *button in _titlesButtonArray)
        {
            [button removeFromSuperview];
        }
    }
    else
    {
        _titlesButtonArray = [[NSMutableArray alloc] init];
    }
    
    [_titlesButtonArray removeAllObjects];
    
    self.autoLayoutButtons = YES;//如果是直接设置title，则必须是自动布局
    
    
    for (int i=0; i<[titles count]; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_titlesButtonArray addObject:button];
        [_buttonScrollView addSubview:button];
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
        
        [button setTitleColor:COLOR_C2 forState:UIControlStateNormal];
        button.titleLabel.font = FONT_t5;
        
        if (i == _selectedIndex)
        {
            [button setBackgroundColor:[UIColor whiteColor]];
        }
        else
        {
            [button setBackgroundColor:[UIColor colorWithRed:0xf2/255.0 green:0xf2/255.0 blue:0xf2/255.0 alpha:1.0]];
        }
    }
    
    UIButton  *currentButton = [_titlesButtonArray objectAtIndex:selectedIndex];
    
    float _selectedLeftLineHeight = currentButton.frame.size.height;
    CGPoint center = currentButton.center;
    
    float sizeK = UI_SCREEN_WIDTH/750.0;
    
    if (animated)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _selectedLeftLineView.frame = CGRectMake(_selectedLeftLineView.frame.origin.x, center.y - _selectedLeftLineHeight/2.0, sizeK * 6, _selectedLeftLineHeight);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        _selectedLeftLineView.frame = CGRectMake(_selectedLeftLineView.frame.origin.x, center.y - _selectedLeftLineHeight/2.0, sizeK * 6, _selectedLeftLineHeight);
    }
}

- (void)buttonClick:(UIButton *)button
{
    if (button.tag < [_titlesButtonArray count])
    {
        [self setSelectedIndex:button.tag animated:NO];
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
    
    _buttonScrollView = [[UIScrollView alloc] init];
    _buttonScrollView.backgroundColor = [UIColor whiteColor];
    _buttonScrollView.showsVerticalScrollIndicator = NO;
    
    _buttonScrollView.backgroundColor = [UIColor colorWithRed:0xf2/255.0 green:0xf2/255.0 blue:0xf2/255.0 alpha:1.0];
    
    [self addSubview:_buttonScrollView];
    
    _selectedLeftLineView = [[UIView alloc] init];
    _selectedLeftLineView.backgroundColor = [UIColor colorWithRed:0xfe/255.0 green:0xdc/255.0 blue:0x32/255.0 alpha:1];
    _selectedLeftLineView.layer.transform = CATransform3DMakeTranslation(0, 0, 100);
   // [_buttonScrollView addSubview:_selectedLeftLineView];
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
        
        float sizeK = UI_SCREEN_WIDTH/750.0;
        
        _originY = 0;
        _spacing = 0;
        
        float offsetY = _originY;
        
        for (int i=0; i<buttonCount; i++)
        {
            UIButton *button = [_titlesButtonArray objectAtIndex:i];
            [button setTitleColor:COLOR_C2 forState:UIControlStateNormal];
            button.titleLabel.font = FONT_t5;
            
            if (i == _selectedIndex)
            {
                [button setBackgroundColor:[UIColor whiteColor]];
            }
            else
            {
                [button setBackgroundColor:[UIColor colorWithRed:0xf2/255.0 green:0xf2/255.0 blue:0xf2/255.0 alpha:1.0]];
            }
            
            
            
            float buttonWidth = 164 * sizeK;
            float buttonHeight = 100 * sizeK;
            
            button.frame = CGRectMake(0, offsetY, buttonWidth, buttonHeight);
            
            offsetY += buttonHeight + _spacing;
        }
        
        _buttonScrollView.contentSize = CGSizeMake(self.width, offsetY + _originY - _spacing);
    }
    else
    {
        UIButton *lastButton = [_titlesButtonArray lastObject];
        _buttonScrollView.contentSize = CGSizeMake(lastButton.frame.origin.x + lastButton.frame.size.width, self.height);
    }
    
    _buttonScrollView.frame = self.bounds;
    
    float k = UI_SCREEN_WIDTH/750.0; //UI尺寸调整系数
    
    _selectedLeftLineView.frame = CGRectMake(0, 0, 6 * k, 100*k);
    UIButton *currentButton = [_titlesButtonArray objectAtIndex:_selectedIndex];
    _selectedLeftLineView.center = CGPointMake(_selectedLeftLineView.center.x, currentButton.center.y);
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (controlEvents & UIControlEventValueChanged)
    {
        [super addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    }
}


@end
