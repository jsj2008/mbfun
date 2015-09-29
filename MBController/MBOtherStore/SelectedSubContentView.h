//
//  SelectedSubContentView.h
//  Wefafa
//
//  Created by Jiang on 4/3/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectedSubContentViewDelegate <NSObject>

- (void)selectedSubContentViewSelectedIndex:(NSInteger)index;

@end

typedef enum : NSUInteger {
    normalType = 0,
    mineButtonType,
    mineButtonImageType
} SelectedButtonType;

@interface SelectedSubContentView : UIView

@property (assign, nonatomic) id<SelectedSubContentViewDelegate> delegate;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, assign) BOOL isShowAnimation;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, assign) SelectedButtonType selectedButtonType;

- (instancetype)initWithFrame:(CGRect)frame AndNameArray:(NSArray*)nameArray buttonType:(SelectedButtonType)buttonType;
- (instancetype)initWithFrame:(CGRect)frame AndNameArray:(NSArray*)nameArray;
- (void)scrollViewEndAction:(NSInteger)page;
- (void)setLineLocationPercentage:(CGFloat)percentage;

@end
