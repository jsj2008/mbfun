//
//  ShoppingContentTableHeaderView.h
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingBagContentModel;

@protocol ShoppingContentTableHeaderViewDelegate <NSObject>

- (void)shoppingHeaderSelectedButton:(UIButton*)button model:(ShoppingBagContentModel*)model;

@end

@interface ShoppingContentTableHeaderView : UIView

@property (nonatomic, assign) id<ShoppingContentTableHeaderViewDelegate> delegate;

@property (nonatomic, strong) UIButton *selectedStateButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ShoppingBagContentModel *contentMdoel;

@end
