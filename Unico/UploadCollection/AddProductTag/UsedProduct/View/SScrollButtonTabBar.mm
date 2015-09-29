//
//  SScrollButtonTabBar.m
//  Wefafa
//
//  Created by chencheng on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SScrollButtonTabBar.h"
#import "SUtilityTool.h"

@interface SScrollButtonTabBar ()
{
    UIScrollView  *_buttonScrollView;
    
    NSMutableArray *_titlesButtonArray;
    UIView  *_selectedBottomLineView;
    
    int _selectedIndex;
    
    
    float _originX;
    float _spacing;
}

@end

@implementation SScrollButtonTabBar

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
    NSLog(@"setSelectedIndex selectedIndex = %ld", selectedIndex);
    
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
            [button setTitleColor:COLOR_C2 forState:UIControlStateNormal];
            button.titleLabel.font = FONT_T4;
            
            NSLog(@"[button setTitleColor:COLOR_C2 forState:UIControlStateNormal]");
            
            [_buttonScrollView scrollRectToVisible:button.frame animated:YES];
            //自动设置btn所在的位置为中心
            if (button.frame.origin.x+button.frame.size.width/2>UI_SCREEN_WIDTH/2&&_buttonScrollView.contentSize.width-button.frame.origin.x>UI_SCREEN_WIDTH/2) {
                [_buttonScrollView setContentOffset:CGPointMake(button.frame.origin.x-(UI_SCREEN_WIDTH/2-button.frame.size.width/2), 0)  animated:YES];
            }else if(button.frame.origin.x+button.frame.size.width/2<UI_SCREEN_WIDTH/2){
                [_buttonScrollView setContentOffset:CGPointMake(0, 0)  animated:YES];
            }else if(_buttonScrollView.contentSize.width-button.frame.origin.x<UI_SCREEN_WIDTH/2){
                [_buttonScrollView setContentOffset:CGPointMake(_buttonScrollView.contentSize.width-UI_SCREEN_WIDTH, 0)  animated:YES];
            }
        }
        else
        {
            [button setTitleColor:COLOR_C6 forState:UIControlStateNormal];
            button.titleLabel.font = FONT_t4;
        }
    }
    
    UIButton  *currentButton = [_titlesButtonArray objectAtIndex:selectedIndex];
    
    float _selectedBottomLineWidth = currentButton.frame.size.width + 15;
    CGPoint center = currentButton.center;
    
    if (animated)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _selectedBottomLineView.frame = CGRectMake(center.x - _selectedBottomLineWidth/2.0, _selectedBottomLineView.frame.origin.y, _selectedBottomLineWidth, _selectedBottomLineView.frame.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        _selectedBottomLineView.frame = CGRectMake(center.x - _selectedBottomLineWidth/2.0, _selectedBottomLineView.frame.origin.y, _selectedBottomLineWidth, _selectedBottomLineView.frame.size.height);
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
    
    _buttonScrollView = [[UIScrollView alloc] init];
    _buttonScrollView.backgroundColor = [UIColor clearColor];
    _buttonScrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_buttonScrollView];
    
    _selectedBottomLineView = [[UIView alloc] init];
    _selectedBottomLineView.backgroundColor = [UIColor colorWithRed:0xfe/255.0 green:0xdc/255.0 blue:0x32/255.0 alpha:1];
    _selectedBottomLineView.layer.transform = CATransform3DMakeTranslation(0, 0, 100);
    [_buttonScrollView addSubview:_selectedBottomLineView];
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
        
        _originX = 30 * sizeK;
        _spacing = 90 * sizeK;
        
        
        
        
        //计算所有button的宽度总和
        float allButtonWidth = 0;
        for (int i=0; i<buttonCount; i++)
        {
            UIButton *button = [_titlesButtonArray objectAtIndex:i];
            
            float buttonWidth = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : button.titleLabel.font}].width;
            allButtonWidth += buttonWidth;
        }
        
        if (buttonCount > 1)
        {
            _spacing = (self.bounds.size.width - _originX*2 - allButtonWidth)/(buttonCount-1);
            if (_spacing < 90 * sizeK)
            {
                _spacing = 90 * sizeK;
            }
        }
        else
        {
            _spacing = 0;
            _originX = (self.bounds.size.width - allButtonWidth)/2.0;
        }
        
        float offsetX = _originX;
        
        for (int i=0; i<buttonCount; i++)
        {
            UIButton *button = [_titlesButtonArray objectAtIndex:i];
            
            
            if (i == _selectedIndex)
            {
                [button setTitleColor:COLOR_C2 forState:UIControlStateNormal];
                button.titleLabel.font = FONT_T4;
            }
            else
            {
                [button setTitleColor:COLOR_C6 forState:UIControlStateNormal];
                button.titleLabel.font = FONT_t4;
            }
            
            
            float buttonWidth = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : button.titleLabel.font}].width;
            float buttonHeight = self.height;
            
            button.frame = CGRectMake(offsetX, 0, buttonWidth, buttonHeight);
            
            offsetX += buttonWidth + _spacing;
        }
        
        _buttonScrollView.contentSize = CGSizeMake(offsetX + _originX - _spacing, self.height);
    }
    else
    {
        UIButton *lastButton = [_titlesButtonArray lastObject];
        _buttonScrollView.contentSize = CGSizeMake(lastButton.frame.origin.x + lastButton.frame.size.width, self.height);
    }
    
    _buttonScrollView.frame = self.bounds;
    
    float k = UI_SCREEN_WIDTH/750.0; //UI尺寸调整系数
    
    
    UIButton *currentButton = [_titlesButtonArray objectAtIndex:_selectedIndex];
    _selectedBottomLineView.frame = CGRectMake(0, self.bounds.size.height-6*k, currentButton.bounds.size.width+10*k, 6*k);
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
