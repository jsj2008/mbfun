//
//  MBCustomClassifyModelView.m
//  Wefafa
//
//  Created by fafatime on 14-8-5.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MBCustomClassifyModelView.h"
#import "AttendCustomButton.h"
#import "CustomButton.h"
#import "Utils.h"
#import "SUtilityTool.h"

@implementation MBCustomClassifyModelView

- (id)initWithFrame:(CGRect)frame WithTitleArray:(NSArray *)transTitleArray useScroll:(BOOL)useScroll WithPicAndText:(BOOL)pic WithPicArray:(NSArray *)picArray WithSelectPicArray:(NSArray *)selectImgArray WithShowRightBtnLine:(BOOL)showRightLine WithShowBottomBtnLine:(BOOL)showBottomLine
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        imageLine.backgroundColor = COLLOCATION_TABLE_LINE;
//        [self addSubview:imageLine];
        
        UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
        imageLine2.backgroundColor = COLLOCATION_TABLE_LINE;
//        [self addSubview:imageLine2];
        
        isShowBottomLine = showBottomLine;
        
        
        
//        _backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:244.0/255.0 alpha:1];
        _activeColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:244.0/255.0 alpha:1];
        _textColor=[UIColor blackColor];
        _selectedTextColor= ORANGECOLORCUSTOM; //[UIColor redColor];
 
        //如果有图片则掉用custbTN
        picAndText = pic;
        
        [self setBackgroundColor:_backgroundColor];
        NSArray * titleArray = [NSArray arrayWithArray:transTitleArray];
        
        UIScrollView *secondView = [[UIScrollView alloc]init];
        
        secondView.delegate=self;
        buttonArray=[[NSMutableArray alloc] initWithCapacity:5];
        activeButtonIndex=0;
        
        secondView.userInteractionEnabled=YES;
        [secondView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        [self addSubview:secondView];
        
        [self setActiveColor:_activeColor];
        [self setSelectedTextColor:_selectedTextColor];
        
        float xx;
       
        if (useScroll)
        {
            xx=115;
            [secondView setContentSize:CGSizeMake(xx*[titleArray count], 0)];
        }
        else
        {
            xx = self.frame.size.width/[titleArray count];
            [secondView setContentSize:CGSizeMake(self.frame.size.width, 0)];
        }

        float ww;
        if (picAndText)//我的订单 中
        {
            for (int a=0; a<[titleArray count]; a++)
            {
                self.backgroundColor=_backgroundColor;
                
                CustomButton *clickBtn=[[CustomButton alloc]initWithFrame:CGRectMake(16+xx*a, 0, 38.5, self.frame.size.height) withLineUp:NO];
                clickBtn.nameLabel.text=[titleArray objectAtIndex:a];
                [clickBtn.itemImageV setImage:[UIImage imageNamed:[picArray objectAtIndex:a]]];
 
                [clickBtn.selectImageView setImage:[UIImage imageNamed:[selectImgArray objectAtIndex:a]]];
                 clickBtn.selectImageView.hidden=YES;
                if (a==0)
                {
                  clickBtn.selectImageView.hidden=NO;
                }
               
                clickBtn.nameLabel.font=[UIFont systemFontOfSize:11.0f];
                clickBtn.clickImgView.backgroundColor=_selectedTextColor;
                clickBtn.tag=a;
                [clickBtn setTitleColor:_textColor forState:UIControlStateNormal];
                [clickBtn addTarget:self
                             action:@selector(btnClick:)
                   forControlEvents:UIControlEventTouchUpInside];
                [secondView addSubview:clickBtn];
 
                ww=clickBtn.frame.origin.x+clickBtn.frame.size.width-UI_SCREEN_WIDTH;
                [buttonArray addObject:clickBtn];
            }
            
            if (buttonArray.count>activeButtonIndex)
                ((CustomButton*)buttonArray[activeButtonIndex]).clickImgView.hidden=(!isShowUnderLine)|NO;

        }
        else
        {
            for (int a=0; a<[titleArray count]; a++)
            {
                AttendCustomButton *clickBtn=[[AttendCustomButton alloc]initWithFrame:CGRectMake(xx*a, 0, xx, self.frame.size.height)];
                clickBtn.titleLabel.text=[titleArray objectAtIndex:a];
                
//                clickBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
  
                clickBtn.titleLabel.font=FONT_t4;

                clickBtn.tag=a;
                [clickBtn setTitleColor:_textColor forState:UIControlStateNormal];
                if(showRightLine==YES)
                {
                    clickBtn.rightLineImgView.hidden=NO;
                    if (a==[titleArray count]-1) {
                        
                        clickBtn.rightLineImgView.hidden=YES;
                    }
                  
                }
                [clickBtn addTarget:self
                             action:@selector(btnClick:)
                   forControlEvents:UIControlEventTouchUpInside];
                [secondView addSubview:clickBtn];
//                [clickBtn.clickImgView setBackgroundColor:_selectedTextColor];
                if(showBottomLine)
                {
                    clickBtn.clickImgView.hidden=NO;
                }
                else
                {
                    clickBtn.clickImgView.hidden=YES;
                }
                [clickBtn.clickImgView setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
                
                ww=clickBtn.frame.origin.x+clickBtn.frame.size.width-UI_SCREEN_WIDTH;
                [buttonArray addObject:clickBtn];
            }
            
        
            if(showBottomLine)
            {
                ((AttendCustomButton*)buttonArray[activeButtonIndex]).clickImgView.hidden=(!isShowUnderLine)|NO;
            }
            else
            {
                ((AttendCustomButton*)buttonArray[activeButtonIndex]).clickImgView.hidden=YES;
    
            }

        }
        [self showUnderline:isShowBottomLine];
        
        if (ww>50)
        {
           [secondView setContentSize:CGSizeMake(UI_SCREEN_WIDTH+ww, 0)];
        }
        

    }
    return self;
}

-(void)showUnderline:(BOOL)underline
{
    isShowUnderLine=underline;
    if (picAndText)
    {
        if (buttonArray.count>0)
            ((CustomButton*)buttonArray[activeButtonIndex]).clickImgView.hidden=!isShowUnderLine;
    }
    else
    {
    
        if (buttonArray.count>0)
        ((AttendCustomButton*)buttonArray[activeButtonIndex]).clickImgView.hidden=!isShowUnderLine;
    }
}
-(void)buttonClickedOfIndex:(NSInteger)index
{
    for (UIButton *button in buttonArray) {
        if (picAndText) {
            
           CustomButton * otherBtn = (CustomButton *)button;
            if (button.tag==index)
            {
                otherBtn.nameLabel.textColor=_selectedTextColor;
                activeButtonIndex=button.tag;
                otherBtn.selectImageView.hidden=NO;
                otherBtn.clickImgView.hidden=(!isShowUnderLine)|NO;
                
            }
            else
            {
                otherBtn.nameLabel.textColor=_textColor;
                otherBtn.clickImgView.hidden=YES;
                otherBtn.selectImageView.hidden=YES;
                otherBtn.backgroundColor=[UIColor clearColor];
            }

        }
        else
        {
            AttendCustomButton * otherBtn = (AttendCustomButton *)button;
            if (button.tag==index)
            {
                otherBtn.titleLabel.textColor=_selectedTextColor;
                activeButtonIndex=button.tag;
//                otherBtn.backgroundColor=_activeColor;
                otherBtn.clickImgView.hidden=(!isShowUnderLine)|NO;
            }
            else
            {
                otherBtn.titleLabel.textColor=_textColor;
                otherBtn.clickImgView.hidden=YES;
                otherBtn.backgroundColor=[UIColor clearColor];
            }

        }
        
    }
}

-(void)btnClick:(UIButton *)sender
{
    if (picAndText)
    {
        CustomButton * custBtn = (CustomButton *)sender;
        if (custBtn.tag==activeButtonIndex)
        {
            
        }
        else
        {
            custBtn.nameLabel.textColor=_selectedTextColor;
            custBtn.clickImgView.hidden=(!isShowUnderLine)|NO;
            for (UIButton *button in buttonArray) {
                CustomButton * otherBtn = (CustomButton *)button;
                if (button.tag==sender.tag)
                {
                    activeButtonIndex=button.tag;
                    otherBtn.nameLabel.textColor=_activeColor;
                    otherBtn.selectImageView.hidden=NO;
                }
                else
                {
                    otherBtn.nameLabel.textColor=_textColor;
                    otherBtn.clickImgView.hidden=YES;
                    otherBtn.selectImageView.hidden=YES;
                    otherBtn.backgroundColor=[UIColor clearColor];
                }
                
            }
            
            if (_delegate!=nil && [_delegate respondsToSelector:@selector(TabItemClick:button:)])
            {
                [_delegate TabItemClick:self button:custBtn];
            }
        }

    }
    else
    {
   
        AttendCustomButton * custBtn = (AttendCustomButton *)sender;
        if (custBtn.tag==activeButtonIndex)
        {
            
        }
        else
        {
            custBtn.titleLabel.textColor=_selectedTextColor;
            custBtn.titleLabel.font=FONT_T4;
            custBtn.clickImgView.hidden=(!isShowUnderLine)|NO;
            for (UIButton *button in buttonArray) {
                AttendCustomButton * otherBtn = (AttendCustomButton *)button;
                if (button.tag==sender.tag)
                {
                    activeButtonIndex=button.tag;
//                    otherBtn.backgroundColor=_activeColor;
                }
                else
                {
                    otherBtn.titleLabel.textColor=_textColor;
                    otherBtn.titleLabel.font=FONT_t4;
                    otherBtn.clickImgView.hidden=YES;
                    otherBtn.backgroundColor=[UIColor clearColor];
                }
                
            }
            
            if (_delegate!=nil && [_delegate respondsToSelector:@selector(TabItemClick:button:)])
            {
                [_delegate TabItemClick:self button:custBtn];
            }
        }

    }
    
}

-(UIButton *)buttonWithTag:(int)tag
{
    return buttonArray[tag];
}
-(void)addButtonActionView:(UIView *)view index:(NSInteger)index
{
    if (picAndText)
    {
//        CustomButton *btn=buttonArray[index];
//        btn.actionView=view;
    }
    else
    {
        
        AttendCustomButton *btn=buttonArray[index];
        btn.actionView=view;
    }

}

- (UIView *)getButtonActionViewForIndex:(NSInteger)index
{
    if (buttonArray.count>index)
    {
        if (picAndText)
        {
//            CustomButton *btn=buttonArray[index];
//            return btn.actionView;
        }
        else
        {
          AttendCustomButton *btn=buttonArray[index];
          return btn.actionView;
        }
    }
    return nil;
}

-(NSInteger)indexOfActiveButton
{
    return activeButtonIndex;
}

-(NSInteger)buttonCount
{
    return buttonArray.count;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor1
{
    _backgroundColor=backgroundColor1;
    [super setBackgroundColor:_backgroundColor];
}
-(void)setActiveColor:(UIColor *)activeColor1
{
    _activeColor=activeColor1;
    for (int a=0; a<[buttonArray count]; a++)
    {
        if (picAndText) {
            
            CustomButton *clickBtn=[buttonArray objectAtIndex:a];
            
            if (a==activeButtonIndex)
            {
                clickBtn.backgroundColor=[UIColor clearColor];//_activeColor;
            }
            else
            {
                clickBtn.backgroundColor=[UIColor clearColor];
            }
  
        }
        else
        {
            AttendCustomButton *clickBtn=[buttonArray objectAtIndex:a];
            
            if (a==activeButtonIndex)
            {
                clickBtn.backgroundColor=[UIColor clearColor];//_activeColor;
            }
            else
            {
                clickBtn.backgroundColor=[UIColor clearColor];
            }
        }
       
    }
}
-(void)setTextColor:(UIColor *)textColor1
{
    _textColor=textColor1;
    for (int a=0; a<[buttonArray count]; a++)
    {
        if (picAndText)
        {
            CustomButton *clickBtn=[buttonArray objectAtIndex:a];
            
            if (a!=activeButtonIndex)
            {
                clickBtn.nameLabel.textColor=_textColor;
            }
        }
        else
        {
            AttendCustomButton *clickBtn=[buttonArray objectAtIndex:a];
            
            if (a!=activeButtonIndex)
            {
                clickBtn.titleLabel.textColor=_textColor;
                clickBtn.titleLabel.font=FONT_t4;
                
            }
        }

    }
}
-(void)setSelectedTextColor:(UIColor *)selectedTextColor1
{
    _selectedTextColor=selectedTextColor1;
    if (buttonArray.count>activeButtonIndex)
    {
        if (picAndText) {
            CustomButton *btn=buttonArray[activeButtonIndex];
            btn.nameLabel.textColor=_selectedTextColor;
            [btn.clickImgView setBackgroundColor:_selectedTextColor];
            [btn.clickImgView setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
        }
        else
        {
            AttendCustomButton *btn=buttonArray[activeButtonIndex];
            btn.titleLabel.textColor=_selectedTextColor;
            btn.titleLabel.font=FONT_T4;
//            btn.titleLabel.font=[UIFont boldSystemFontOfSize:14.0f];
//            btn.titleLabel.font=[UIFont fontWithName:@"Verdana-Bold" size:14.0];
        }
    }
    for (int a=0; a<[buttonArray count]; a++)
    {
        if (picAndText) {
            CustomButton *btn=buttonArray[activeButtonIndex];
            btn.nameLabel.textColor=_selectedTextColor;
            
        }
        else
        {
            AttendCustomButton *btn=[buttonArray objectAtIndex:a];
//            [btn.clickImgView setBackgroundColor:_selectedTextColor];
            [btn.clickImgView setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
        }
    }
}

-(void)setFont:(UIFont*)font
{
    for (int a=0; a<[buttonArray count]; a++)
    {
        if (picAndText) {
            CustomButton *btn=[buttonArray objectAtIndex:a];
            btn.nameLabel.font=font;
        }
        else
        {
        
            AttendCustomButton *btn=[buttonArray objectAtIndex:a];
            btn.titleLabel.font=font;
        }
    }
}

@end
