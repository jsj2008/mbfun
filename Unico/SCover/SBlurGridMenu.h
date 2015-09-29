//
//  SBlurGridMenu.h
//  SBlurGridMenu
//
//  Created by Carson Perrotti on 2014-10-18.
//  Copyright (c) 2014 Carson Perrotti. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SBlurBlurEffectStyle) {
    SBlurBlurEffectStyleExtraLight,
    SBlurBlurEffectStyleLight,
    SBlurBlurEffectStyleDark
};

@class SBlurGridMenuItem;
@protocol SBlurGridMenuDelegate;

typedef void (^SelectionHandler)(SBlurGridMenuItem *item);

@interface SBlurGridMenu : UICollectionViewController

@property (nonatomic, assign) SBlurBlurEffectStyle blurEffectStyle;

@property (nonatomic, weak) id <SBlurGridMenuDelegate> delegate;
@property (nonatomic, readonly) NSArray *menuItems;

- (instancetype)initWithMenuItems:(NSArray *)items;

@end

@protocol SBlurGridMenuDelegate <NSObject>

@optional
- (void)gridMenuDidTapOnBackground:(SBlurGridMenu *)menu;
- (void)gridMenu:(SBlurGridMenu *)menu didTapOnItem:(SBlurGridMenuItem *)item;

@end

@interface SBlurGridMenuItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) SelectionHandler selectionHandler;

@end

@interface UIViewController (SBlurGridMenu)

@property (nonatomic, strong) SBlurGridMenu *gridMenu;

- (void)presentGridMenu:(SBlurGridMenu *)menu animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissGridMenuAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end