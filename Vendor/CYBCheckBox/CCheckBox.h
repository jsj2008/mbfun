//
//  CCheckBox.h
//  test
//
//  Created by mac on 14-3-13.
//  Copyright (c) 2014年 FafaTimes. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CHECKBOX_STYLE_MULTISELECTED,
    CHECKBOX_STYLE_SINGLESELECTED,
}CHECKBOX_STYLE;

@interface CCheckBox : UIControl
{
    //默认多选
    UILabel *label;
    UIImageView *icon;
    BOOL checked;
    id delegate;
    
    int CHECKBOX_MARGIN;
    int MinHeight;
}

@property (retain, nonatomic) id delegate;//checkBoxClicked:(id)sender
//sample:
//-(void)checkBoxClicked:(id)sender
//{
//    CCheckBox *checkbox=(CCheckBox*)sender;
//    if (checkbox.style==CHECKBOX_STYLE_MULTISELECTED)
//    {
//        todo
//    }
//    if (checkbox.style==CHECKBOX_STYLE_SINGLESELECTED)
//    {
//        todo
//    }
//}

@property (retain, nonatomic) UILabel *label;
@property (retain, nonatomic) UIImageView *icon;
@property (assign, nonatomic) CHECKBOX_STYLE style;

- (id)initWithFrame:(CGRect)frame style:(CHECKBOX_STYLE)style iconSize:(int)iconsize fontSize:(int)fontsize;
-(BOOL)isChecked;
-(void)setChecked: (BOOL)flag;
-(NSString *)text;
-(void)setText:(NSString *)t;
+(int)getViewHeight:(NSString *)t width:(int)width iconSize:(int)iconSize fontSize:(int)fontSize;

@end


