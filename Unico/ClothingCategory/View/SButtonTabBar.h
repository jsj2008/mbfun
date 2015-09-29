//
//  SButtonTabBar.h
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *   由UIButton组成的TabBar，被选中的UIButton底部会有一根黄色的线段。支持事件UIControlEventValueChanged
 */
@interface SButtonTabBar : UIControl


@property(assign, readwrite, nonatomic)BOOL autoLayoutButtons;//是否自动布局UIButton 默认值 YES
@property(assign, readwrite, nonatomic)int selectedIndex;
@property(strong, readwrite, nonatomic)NSArray *buttons;

- (void)setSelectedIndex:(NSUInteger )selectedIndex animated:(BOOL)animated;

@end

