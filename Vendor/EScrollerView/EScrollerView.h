//
//  EScrollerView.h
//  One
//
//  Created by fafatime on 14-3-31.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "StyledPageControl.h"

typedef enum
{
    ESCROLLERVIEW_SCROLL_PAGE_RIGHT,
    ESCROLLERVIEW_SCROLL_PAGE_LEFT,
    ESCROLLERVIEW_SCROLL_PAGE_CENTER,
    ESCROLLERVIEW_SCROLL_NO_PAGE,
}ESCROLLERVIEW_SCROLL_PAGE_POSITION;

@protocol EScrollerViewDelegate <NSObject>
@optional
-(void)EScrollerViewDidClicked:(UIImageView *)imageView;
@end

@interface EScrollerView : UIView<UIScrollViewDelegate> {
	CGRect viewSize;
	UIScrollView *scrollView;
	NSArray *imageArray;
    NSArray *titleArray;
//    UIPageControl *pageControl;
    StyledPageControl *pageControl;
    int currentPageIndex;
    UILabel *noteTitle;
    NSString *_defaultImageName;
    ESCROLLERVIEW_SCROLL_PAGE_POSITION _scrollPagePosition;
}
@property(nonatomic,assign)id<EScrollerViewDelegate> delegate;
@property(nonatomic,retain) UIView *noteView;
-(NSArray *)getImageUrlArray;

@property(nonatomic,assign) BOOL isRecycleScroll;
-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr;
-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr defaultImageName:(NSString *)defaultImageName scrollPagePosition:(ESCROLLERVIEW_SCROLL_PAGE_POSITION)scrollPagePosition isRecycleScroll:(BOOL)isRecycleScroll;

@end
