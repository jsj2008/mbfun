//
//  ClothingCategoryHeaderContentView.m
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "ClothingCategoryHeaderContentView.h"
#import "AppDelegate.h"
#import "ClothingCategoryFilterViewController.h"


@interface ClothingCategoryHeaderContentView ()
{
    ClothingCategoryIntroductionView *_clothingCategoryIntroductionView;
    ClothingCategoryTabBar *_clothingCategoryTabBar;
    
    SButtonTabBar *_buttonTabBar;
    CCButton *_filterButton;
    
    UIView *_titleView;
}

@end




@implementation ClothingCategoryHeaderContentView


- (void)initSubviews
{
    self.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    
    _clothingCategoryIntroductionView = [[ClothingCategoryIntroductionView alloc] init];
    [self addSubview:_clothingCategoryIntroductionView];
    
    
    _clothingCategoryTabBar = [[ClothingCategoryTabBar alloc] init];
    [self addSubview:_clothingCategoryTabBar];
    
    _titleView = [[UIView alloc] init];
    _titleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_titleView];
    
    _buttonTabBar = [[SButtonTabBar alloc] init];
    _buttonTabBar.autoLayoutButtons = NO;
    [_titleView addSubview:_buttonTabBar];
    
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
        [self layoutSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float offsetY = 0;//64;
    
    _clothingCategoryIntroductionView.frame = CGRectMake(0, offsetY, self.frame.size.width, _clothingCategoryIntroductionView.frame.size.height);
    offsetY += _clothingCategoryIntroductionView.frame.size.height;
    
    
    if ([_clothingCategoryTabBar.cells count] <= 1)
    {
        _clothingCategoryTabBar.frame = CGRectMake(0, offsetY , self.width, 0);
        offsetY += _clothingCategoryTabBar.frame.size.height;
    }
    else
    {
        _clothingCategoryTabBar.frame = CGRectMake(0, offsetY , self.width, _clothingCategoryTabBar.frame.size.height);
        offsetY += _clothingCategoryTabBar.frame.size.height;
    }

    
    _titleView.frame = CGRectMake(0, offsetY, self.frame.size.width, 50);
    offsetY += _titleView.frame.size.height;
    
    
    _buttonTabBar.frame = CGRectMake(0, 10, self.width, 40);

    [super setFrame:CGRectMake(0, 0, self.frame.size.width, offsetY)];
}

@end

