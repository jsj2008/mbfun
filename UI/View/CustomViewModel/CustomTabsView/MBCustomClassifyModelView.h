//
//  MBCustomClassifyModelView.h
//  Wefafa
//
//  Created by fafatime on 14-8-5.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBCustomClassifyModelViewDelegate <NSObject>

-(void)TabItemClick:(id)sender button:(id)param;

@end

@interface MBCustomClassifyModelView : UIView<UIScrollViewDelegate>
{
    NSMutableArray *buttonArray;
    NSInteger activeButtonIndex;
    UIColor *_backgroundColor;
    UIColor *_activeColor;
    UIColor *_textColor;
    UIColor *_selectedTextColor;
    BOOL isShowUnderLine;
    BOOL picAndText;
    BOOL isShowBottomLine;
    
}

@property (assign, nonatomic) id<MBCustomClassifyModelViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame WithTitleArray:(NSArray*)transTitleArray useScroll:(BOOL)useScroll WithPicAndText:(BOOL)pic WithPicArray:(NSArray *)picArray WithSelectPicArray:(NSArray *)selectImgArray WithShowRightBtnLine:(BOOL)showRightLine WithShowBottomBtnLine:(BOOL)showBottomLine;
-(void)addButtonActionView:(UIView *)view index:(NSInteger)index;
-(UIView *)getButtonActionViewForIndex:(NSInteger)index;
-(NSInteger)indexOfActiveButton;
-(NSInteger)buttonCount;
-(void)showUnderline:(BOOL)underline;

-(void)setBackgroundColor:(UIColor *)backgroundColor1;
-(void)setActiveColor:(UIColor *)activeColor1;
-(void)setTextColor:(UIColor *)textColor1;
-(void)setSelectedTextColor:(UIColor *)selectedTextColor1;
-(void)setFont:(UIFont*)font;
-(void)buttonClickedOfIndex:(NSInteger)index;

@end
