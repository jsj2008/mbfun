//
//  MNWheelView.h
//  Tab学习
//
//  Created by qsit on 15-1-6.
//  Copyright (c) 2015年 abc. All rights reserved.
//
//  齿轮滚动视图
//  可以手势滑动
//  单击上下边滑动
//

#import <UIKit/UIKit.h>

typedef void (^click) (int i,UIImage *image);

@interface MNWheelView : UIView
// imageNames 和images 二选一
//图片名数组
@property(nonatomic,weak)NSArray *imageNames;
//图片数组
@property(nonatomic,weak)NSArray *images;
//回调单击方法
@property(nonatomic,strong)click click;

@end
