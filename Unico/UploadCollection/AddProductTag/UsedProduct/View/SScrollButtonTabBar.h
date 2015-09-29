//
//  SScrollButtonTabBar.h
//  Wefafa
//
//  Created by chencheng on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SScrollButtonTabBar : UIControl


@property(assign, readwrite, nonatomic)BOOL autoLayoutButtons;//是否自动布局UIButton 默认值 YES
@property(assign, readwrite, nonatomic)int selectedIndex;
@property(strong, readwrite, nonatomic)NSArray *buttons;
@property(strong, readwrite, nonatomic)NSArray *titles;

- (void)setSelectedIndex:(NSUInteger )selectedIndex animated:(BOOL)animated;


@end


