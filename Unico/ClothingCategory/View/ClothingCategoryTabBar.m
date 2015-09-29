//
//  ClothingCategoryTabBar.m
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "ClothingCategoryTabBar.h"



@interface ClothingCategoryTabBar ()
{
    UIScrollView  *_cellScrollView;
    
    NSMutableArray *_cellMutableArray;
    int _selectedIndex;

    
    float _cellWidth;
    float _cellHeight;
    float _originX;
    float _spacing;

    
}

@end




@implementation ClothingCategoryTabBar

- (void)setSelectedIndex:(int)selectedIndex
{
    if (_selectedIndex == selectedIndex)
    {
        return;
    }
    
    _selectedIndex = selectedIndex;
    
    
    for (int i=0; i<[_cellMutableArray count]; i++)
    {
        ClothingCategoryTabBarCell *cell = [_cellMutableArray objectAtIndex:i];
        
        if (i == _selectedIndex)
        {
            cell.selected = YES;
            
            NSLog(@"[_cellScrollView scrollRectToVisible:cell.frame animated:YES] i = %d", i);
            
            [_cellScrollView scrollRectToVisible:cell.frame animated:YES];
            
        }
        else
        {
            cell.selected = NO;
        }
    }
    
    
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
    self.layer.masksToBounds = YES;
    
    float k = UI_SCREEN_WIDTH/750.0; //UI尺寸调整系数
    
    _cellWidth = 140 * k;
    _cellHeight = 140 * k;
    _originX = 30 * k;
    _spacing = 22 * k;

    
    _cellScrollView = [[UIScrollView alloc] init];
    _cellScrollView.showsHorizontalScrollIndicator = NO;
    _selectedIndex = -1;//未选择任何cell
    [self addSubview:_cellScrollView];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _selectedIndex = -1;//默认没选择任何cell
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
        
        [self layoutSubviews];
    }
    return self;
}

- (void)setCells:(NSArray *)cells
{
    if (_cellMutableArray != nil)
    {
        for (ClothingCategoryTabBarCell *cell in _cellMutableArray)
        {
            [cell removeFromSuperview];
        }
    }
    
    _cellMutableArray = [cells mutableCopy];
    
    [self layoutSubviews];
}

- (NSArray *)cells
{
    return [_cellMutableArray copy];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([_cellMutableArray count] == 0)
    {
        return;
    }
    
    float k = UI_SCREEN_WIDTH/750.0; //UI尺寸调整系数
    
    _cellScrollView.frame = CGRectMake(_originX, 0, self.width - _originX*2, self.height);
    
    float selfHeight = _cellHeight+2*k*2;
    
    
    for (int i=0; i<[_cellMutableArray count]; i++)
    {
        ClothingCategoryTabBarCell *cell = [_cellMutableArray objectAtIndex:i];
        cell.tag = i;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTap:)];
        [cell addGestureRecognizer:tapGestureRecognizer];
        
        cell.frame = CGRectMake(i*(_cellWidth+_spacing), (selfHeight-_cellHeight)/2.0, _cellWidth, _cellHeight);
        
        [_cellScrollView addSubview:cell];
    }
    
    _cellScrollView.contentSize = CGSizeMake([_cellMutableArray count]*_cellWidth + ([_cellMutableArray count]-1)*_spacing, _cellScrollView.height);
    
    
    if ([_cellMutableArray count] == 0)
    {
        [super setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0)];
    }
    else
    {
        [super setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, selfHeight)];
        
        if (_selectedIndex>=0 && (_selectedIndex+1)<=[_cellMutableArray count])
        {
            //让选中的cell显示出来
            ClothingCategoryTabBarCell *selectedCell = [_cellMutableArray objectAtIndex:_selectedIndex];
            float selectedCellOffsetX = selectedCell.frame.origin.x;
            
            selectedCellOffsetX = _selectedIndex * (_cellWidth + _spacing) - _cellScrollView.frame.size.width/2.0 + _cellWidth/2.0;
            
            if (selectedCellOffsetX < 0)
            {
                selectedCellOffsetX = 0;
            }
            else if (selectedCellOffsetX > _cellScrollView.contentSize.width-_cellScrollView.width)
            {
                selectedCellOffsetX = _cellScrollView.contentSize.width-_cellScrollView.width;
            }
                
            _cellScrollView.contentOffset = CGPointMake(selectedCellOffsetX, 0);
        }
    }
    
    [self.superview layoutSubviews];
}



- (void)cellTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    ClothingCategoryTabBarCell *cell = (ClothingCategoryTabBarCell *)tapGestureRecognizer.view;
    if (cell.tag == self.selectedIndex)
    {
        return;
    }
    
    self.selectedIndex = (int)cell.tag;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (controlEvents & UIControlEventValueChanged)
    {
        [super addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    }
}

@end

