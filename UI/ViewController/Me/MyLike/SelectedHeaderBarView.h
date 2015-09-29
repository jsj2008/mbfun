//
//  SearchHeaderToobar.h
//  Designer
//
//  Created by Jiang on 1/27/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectedHeaderBarView;

@protocol SelectedHeaderBarViewDelegate <NSObject>

- (void)selectedHeaderToobar:(SelectedHeaderBarView*)selectedHeaderBarView didSelectNumber:(NSInteger)index;

@end

@interface SelectedHeaderBarView : UIToolbar

@property (nonatomic, assign) id<SelectedHeaderBarViewDelegate> selectedHeaderBarViewDelegate;
@property (nonatomic, strong) NSArray* headerTitlesArray;
- (void)setLineLocationPercentage:(CGFloat)percentage;
- (void)scrollViewEndAction:(int)page;

@end
