//
//  CustomFunctionBar.m
//  Wefafa
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CustomFunctionBar.h"

@implementation CustomFunctionBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)showUnderline:(BOOL)underline
{
    [super showUnderline:NO];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor1
{
    [super setBackgroundColor:backgroundColor1];
    [super setActiveColor:backgroundColor1];
}

-(void)setTextColor:(UIColor *)textColor1
{
    [super setTextColor:textColor1];
    [super setSelectedTextColor:textColor1];
}

-(ATTEND_CLICK_SHOW_VIEW_TYPE)getShowViewForIndex:(int)index
{
    AttendCustomButton *btn=buttonArray[index];
    return btn.showViewType;
}

-(void)setShowViewForIndex:(int)index showType:(ATTEND_CLICK_SHOW_VIEW_TYPE)showType
{
    AttendCustomButton *btn=buttonArray[index];
    btn.showViewType=showType;
}

-(void)btnClick:(UIButton *)sender
{
    AttendCustomButton * custBtn = (AttendCustomButton *)sender;

    custBtn.titleLabel.textColor=_selectedTextColor;
    custBtn.clickImgView.hidden=(!isShowUnderLine)|NO;
    for (UIButton *button in buttonArray) {
        AttendCustomButton * otherBtn = (AttendCustomButton *)button;
        if (button.tag==sender.tag)
        {
            activeButtonIndex=button.tag;
            otherBtn.backgroundColor=_activeColor;
       
        }
        else
        {
            otherBtn.titleLabel.textColor=_textColor;
            otherBtn.clickImgView.hidden=YES;
            otherBtn.backgroundColor=[UIColor clearColor];
        }
        
    }
    
    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(TabItemClick:button:)])
    {
        [self.delegate TabItemClick:self button:custBtn];
    }
}

@end
