//
//  ScratchableButtonsView.h
//  QCIconprocess
//
//  Created by Miaoz on 15/1/19.
//  Copyright (c) 2015年 Scasy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScratchableButtonsView;
@protocol ScratchableButtonsViewDelegate <NSObject>

- (void)scratchablePopover:(ScratchableButtonsView * )scratchableView didSelectMenuItemAtIndex:(NSInteger)selectedIndex;

@end
@interface ScratchableButtonsView : UIView
@property(weak,nonatomic)id <ScratchableButtonsViewDelegate> delegate;

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *dataarray;


- (id)initWithFrame:(CGRect)frame;
- (void)showInView:(UIView *)view;
- (void)dismissScratchPopover;
- (void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

#pragma mark 调整图片的位置  宫格排列
- (void)adjustImagePosWithColumns:(int)columns dataarray:(NSMutableArray *)array add:(BOOL)add;
//横向
-(void)addbuttonsWithdataarray:(NSMutableArray *)dataarray buttonoffsetY:(CGFloat)offsety width:(CGFloat)width height:(CGFloat)height isimage:(BOOL)isimage;
@end
