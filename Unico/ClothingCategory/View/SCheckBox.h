//
//  SCheckBox.h
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SCheckBoxGroup;

/**
 *   自定义复选框、可以多选、可以单选，用在筛选界面。支持事件UIControlEventValueChanged
 */
@interface SCheckBox : UIControl

@property(strong, readonly, nonatomic)UIImageView *imageView;
@property(strong, readonly, nonatomic)UILabel *titleLabel;

//@property(assign, readwrite, nonatomic)BOOL selected;该属性继承自父类,在此不再重复声明。

@end


/**
 *   复选框组。注意：该类非控件类，也非视图类。暂时仅仅控制每组里面的SCheckBox是多选还是单选。
 */
@interface SCheckBoxGroup : NSObject

@property(assign, readwrite, nonatomic)int maxNumberOfSelected;//每组里面最多能选中多少个SCheckBox，默认值是1


/**
 *   将某个复选框添加到该组里面。
 */
- (void)addCheckBox:(SCheckBox *)checkBox;

/**
 *   将某个复选框从该组里面移除掉。
 */
- (void)removeCheckBox:(SCheckBox *)checkBox;

/**
 *   将该组里面的复选框全部移除掉。
 */
- (void)removeAllCheckBox;

@end