//
//  RootScrollView.h
//  SlideSwitchDemo
//
//  Created by liulian on 13-4-23.
//  Copyright (c) 2013年 liulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootScrollView : UIScrollView <UIScrollViewDelegate>
{
   
    CGFloat userContentOffsetX;
    BOOL isLeftScroll;
}
@property (nonatomic, strong) NSMutableArray *dataarray;
@property (nonatomic, strong) UIScrollView  *scrollView;
+ (RootScrollView *)shareInstance;

@end
