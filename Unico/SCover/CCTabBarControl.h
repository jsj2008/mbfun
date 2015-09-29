//
//  CCTabBarControl.h
//  Wefafa
//
//  Created by chen cheng on 15/7/7.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCTabBarControl : UIControl
{
    NSArray *_titles;
    NSArray *_titlesButtonArray;
    
    UIView  *_selectedBottomLineView;
    UIView  *_selectedBottomBgView;
    
    int _preSelectedIndex;//之前的选项
    int _selectedIndex;
    
    NSMutableArray *_targetMutableArray;
    NSMutableArray *_actionMutableArray;
}

@property(strong, readwrite, nonatomic)NSArray *titles;
@property(assign, readwrite, nonatomic)int preSelectedIndex;//之前的选项
@property(assign, readwrite, nonatomic)int selectedIndex;

- (id)initWithTitles:(NSArray *)titles;


@end
