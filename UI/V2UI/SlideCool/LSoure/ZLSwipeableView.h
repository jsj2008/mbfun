//
//  SlideCoolMainViewController.h
//  Designer
//
//  Created by Samuel on 14/1/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZLSwipeableViewDirection) {
    ZLSwipeableViewDirectionNone = 0,
    ZLSwipeableViewDirectionLeft,
    ZLSwipeableViewDirectionRight,
    ZLSwipeableViewDirectionBoth = ZLSwipeableViewDirectionLeft |
                                   ZLSwipeableViewDirectionRight,
};

@class ZLSwipeableView;

/// Delegate
@protocol ZLSwipeableViewDelegate <NSObject>

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeLeft:(UIView *)view;

- (void)swipeableView:(ZLSwipeableView *)swipeableView
        didSwipeRight:(UIView *)view;

- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view;

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didStartSwipingView:(UIView *)view
             atLocation:(CGPoint)location;

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation;

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location;

@end

// DataSource
@protocol ZLSwipeableViewDataSource <NSObject>

@required
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView;

@end

@interface ZLSwipeableView : UIView

@property (nonatomic, weak) IBOutlet id<ZLSwipeableViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<ZLSwipeableViewDelegate> delegate;
@property (nonatomic) BOOL isRotationEnabled;
@property (nonatomic) float rotationDegree;
@property (nonatomic) float rotationRelativeYOffsetFromCenter;
@property (nonatomic) ZLSwipeableViewDirection direction;
@property (nonatomic) CGFloat escapeVelocityThreshold;
@property (nonatomic) CGFloat relativeDisplacementThreshold;
@property (nonatomic) CGFloat pushVelocityMagnitude;
@property (nonatomic) CGPoint swipeableViewsCenter;
@property (nonatomic) CGRect collisionRect;
@property (nonatomic) CGFloat programaticSwipeRotationRelativeYOffsetFromCenter;

- (void)discardAllSwipeableViews;
- (void)loadNextSwipeableViewsIfNeeded;
- (void)swipeTopViewToLeft;
- (void)swipeTopViewToRight;

@end
