//
//  UIScrollView+paging.m
//  Wefafa
//
//  Created by wave on 15/8/18.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "UIScrollView+paging.h"
#import <objc/runtime.h>
//#import "UIScrollView+MJRefresh.h"
//#import "MJRefresh.h"
#import "SVPullToRefresh.h"

static const float kAnimationDuration = 0.25f;

static const char jy_originContentHeight;
static const char jy_secondScrollView;

@interface UIScrollView()

@property (nonatomic, assign) float originContentHeight;

@end


@implementation UIScrollView (paging)

- (void)setOriginContentHeight:(float)originContentHeight {
    objc_setAssociatedObject(self, &jy_originContentHeight, @(originContentHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)originContentHeight {
    return [objc_getAssociatedObject(self, &jy_originContentHeight) floatValue];
}


- (void)setFirstScrollView:(UIScrollView *)firstScrollView {
    [self addFirstScrollViewFooter];
}

- (UIScrollView *)secondScrollView {
    return objc_getAssociatedObject(self, &jy_secondScrollView);
}

- (void)setSecondScrollView:(UIScrollView *)secondScrollView {
    objc_setAssociatedObject(self, &jy_secondScrollView, secondScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addFirstScrollViewFooter];
    /*
    CGRect frame = self.bounds;
    frame.origin.y = self.contentSize.height + self.footer.frame.size.height;
    secondScrollView.frame = frame;
    */
    CGRect frame = self.bounds;
    frame.origin.y = self.contentSize.height + self.infiniteScrollingView.frame.size.height;
    secondScrollView.frame = frame;
    
    [self addSubview:secondScrollView];
    
    [self addSecondScrollViewHeader];
}

- (void)addFirstScrollViewFooter {
    __weak __typeof(self) weakSelf = self;
    /*
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf endFooterRefreshing];
    }];
    footer.appearencePercentTriggerAutoRefresh = 2;
    [footer setTitle:@"继续拖动,查看图文详情" forState:MJRefreshStateIdle];
    
    self.footer = footer;
     */
    [self addInfiniteScrollingWithActionHandler:^{
        [weakSelf endFooterRefreshing];
    }];
    
}

- (void)addSecondScrollViewHeader {
    __weak __typeof(self) weakSelf = self;
    /*
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf endHeaderRefreshing];
        [weakSelf addFirstScrollViewFooter];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉,返回宝贝详情" forState:MJRefreshStateIdle];
    [header setTitle:@"释放,返回宝贝详情" forState:MJRefreshStatePulling];
    
    self.secondScrollView.header = header;
     */
    [self.secondScrollView addPullToRefreshWithActionHandler:^{
        [weakSelf endHeaderRefreshing];
        [weakSelf addFirstScrollViewFooter];
    }];
}

- (void)endFooterRefreshing {
    /*
    [self.footer endRefreshing];
    self.footer.hidden = YES;
    self.scrollEnabled = NO;
    
    self.secondScrollView.header.hidden = NO;
    self.secondScrollView.scrollEnabled = YES;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.contentInset = UIEdgeInsetsMake(-self.contentSize.height - self.footer.frame.size.height, 0, 0, 0);
    }];
    
    self.originContentHeight = self.contentSize.height;
    self.contentSize = self.secondScrollView.contentSize;
     */
    [self.infiniteScrollingView startAnimating];
    self.infiniteScrollingView.hidden = YES;
    self.scrollEnabled = NO;
    
    self.secondScrollView.pullToRefreshView.hidden = NO;
    self.secondScrollView.scrollEnabled = YES;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.contentInset = UIEdgeInsetsMake(-self.contentSize.height - self.infiniteScrollingView.height, 0, 0, 0);
    }];
    
    self.originContentHeight = self.contentSize.height;
    self.contentSize = self.secondScrollView.contentSize;
}

- (void)endHeaderRefreshing {
    /*
    [self.secondScrollView.header endRefreshing];
    self.secondScrollView.header.hidden = YES;
    self.secondScrollView.scrollEnabled = NO;
    
    self.footer.hidden = NO;
    self.scrollEnabled = YES;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, self.footer.frame.size.height, 0);
    }];
    self.contentSize = CGSizeMake(0, self.originContentHeight);
     */
    [self.secondScrollView.pullToRefreshView stopAnimating];
    self.secondScrollView.pullToRefreshView.hidden = YES;
    self.secondScrollView.scrollEnabled = NO;
    
    self.infiniteScrollingView.hidden = NO;
    self.scrollEnabled = YES;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, self.infiniteScrollingView.height, 0);
    }];
    self.contentSize = CGSizeMake(0, self.originContentHeight);
}

@end
