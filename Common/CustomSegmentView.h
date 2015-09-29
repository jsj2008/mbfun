//
//  CustomSegmentView.h
//  Wefafa
//
//  Created by su on 15/1/28.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectIndexSegment)(UIButton *btn,NSInteger index);

@interface CustomSegmentView : UIView

@property (nonatomic,strong)NSArray *itemsArr;//放nsstring或者uiimage
@property (nonatomic,copy)SelectIndexSegment actionBlock;//动作响应，SelectIndexSegment
@property (nonatomic)BOOL needShowSelectBg;
@property (nonatomic,strong)UIColor *selectBgColor;
@property (nonatomic)NSInteger selectIndex;
@end
