//
//  SCheckBox.m
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SCheckBox.h"


@interface SCheckBox()
{
    UIImageView *_imageView;
    UILabel     *_titleLabel;
    
    UIImageView *_selectedImageView;
    
    BOOL _selected;
    
    __weak SCheckBoxGroup *_group;
}

@property(weak, readwrite, nonatomic)SCheckBoxGroup *group;//SCheckBox所在的组，相同组里面的SCheckBox可以设置成单选或多选

@end


@interface SCheckBoxGroup()
{
    NSMutableArray *_checkBoxMutableArray;
}

@property(strong, readonly, nonatomic)NSMutableArray *checkBoxMutableArray;

@end



@implementation SCheckBox

@synthesize selected = _selected;

- (void)initSubviews
{
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _selectedImageView = [[UIImageView alloc] init];
    _selectedImageView.image = [UIImage imageNamed:@"Unico/product_selected_state"];
    [self addSubview:_selectedImageView];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    self.selected = NO;
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
    self  = [super initWithFrame:frame];
    if (self != nil)
    {
        [self initSubviews];
        
        [self layoutSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
    _titleLabel.frame = self.bounds;
    
    float k = UI_SCREEN_WIDTH/750.0;
    
    _selectedImageView.frame = CGRectMake(self.frame.size.width-46*k, self.frame.size.height-37*k, 46*k, 37*k);
}

- (void)setSelected:(BOOL)selected
{
    NSLog(@"setSelected setSelected = %d", selected);
    
    if (selected)
    {
        self.layer.borderColor = [UIColor colorWithRed:59.0/255.0 green:59.0/255.0 blue:59.0/255.0 alpha:1.0].CGColor;
        self.layer.borderWidth = 2;
        
        _selectedImageView.hidden = NO;
    }
    else
    {
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1;
        
        _selectedImageView.hidden = YES;
    }
    
    if (_selected != selected)
    {
        _selected = selected;
        
        NSLog(@"_selected = %d", _selected);
        
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
}

- (void)tap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (self.group == nil)//不属于任何一组
    {
        NSLog(@"self.selected = !(self.selected)");
        self.selected = !(self.selected);
    }
    else
    {
        if (!self.selected)
        {
            int maxNumberOfSelected = self.group.maxNumberOfSelected;
            
            int cureentNumberOfSelected = 0;
            
            for (SCheckBox *checkBox in self.group.checkBoxMutableArray)
            {
                if (checkBox.selected)
                {
                    cureentNumberOfSelected++;
                }
            }
            
            if (cureentNumberOfSelected >= maxNumberOfSelected)
            {
                return;
            }
            else
            {
                self.selected = YES;
            }
        }
        else
        {
            self.selected = NO;
        }
    }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (controlEvents & UIControlEventValueChanged)
    {
        [super addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    }
}

@end


@implementation SCheckBoxGroup

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _checkBoxMutableArray = [[NSMutableArray alloc] init];
        
        self.maxNumberOfSelected = 1;
    }
    return self;
}

/**
 *   将某个复选框添加到该组里面。
 */
- (void)addCheckBox:(SCheckBox *)checkBox
{
    [_checkBoxMutableArray addObject:checkBox];
    checkBox.group = self;
}

/**
 *   将某个复选框从该组里面移除掉。
 */
- (void)removeCheckBox:(SCheckBox *)checkBox
{
    [_checkBoxMutableArray removeObject:checkBox];
    checkBox.group = nil;
}

/**
 *   将该组里面的复选框全部移除掉。
 */
- (void)removeAllCheckBox
{
    for (SCheckBox *checkBox in _checkBoxMutableArray)
    {
        checkBox.group = nil;
    }
    [_checkBoxMutableArray removeAllObjects];
}

@end