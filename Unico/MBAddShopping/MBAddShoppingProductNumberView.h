//
//  MBAddShoppingProductNumberView.h
//  Wefafa
//
//  Created by su on 15/5/16.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBAddShoppingProductNumberViewDelegate <NSObject>

- (void)shoppingProductNumberChange:(int)number;

@end

@interface MBAddShoppingProductNumberView : UIView

@property (nonatomic, assign) int number;
@property (nonatomic, assign) int stockCount;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) UITextField *centerField;
@property (nonatomic, assign) id<MBAddShoppingProductNumberViewDelegate> delegate;

@end
