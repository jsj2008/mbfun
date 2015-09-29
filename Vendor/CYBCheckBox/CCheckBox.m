//
//  CCheckBox.m
//  test
//
//  Created by mac on 14-3-13.
//  Copyright (c) 2014年 FafaTimes. All rights reserved.
//

#import "CCheckBox.h"

@implementation CCheckBox

@synthesize label,icon,delegate;




- (id)initWithFrame:(CGRect)frame style:(CHECKBOX_STYLE)style iconSize:(int)iconsize fontSize:(int)fontsize
{
    _style=style;
    CHECKBOX_MARGIN=2;
    iconsize=iconsize<14?14:iconsize;
    MinHeight=iconsize>fontsize?iconsize:fontsize;
    
    self = [super initWithFrame:CGRectMake(frame.origin.x,
                                           frame.origin.y,
                                           frame.size.width,
                                           MinHeight+ 2*CHECKBOX_MARGIN)];
    if (self) {
        
        icon =[[UIImageView alloc] initWithFrame: CGRectMake (CHECKBOX_MARGIN, CHECKBOX_MARGIN, iconsize, iconsize)];
        [self setChecked:NO];
        [self addSubview:icon];
        
        int lb_x=icon.frame.size.width + 2*CHECKBOX_MARGIN;
        label =[[UILabel alloc] initWithFrame:
                CGRectMake(lb_x,
                    CHECKBOX_MARGIN,
                    frame.size.width - lb_x - CHECKBOX_MARGIN,
                    frame.size.height-2*CHECKBOX_MARGIN)];
        label.backgroundColor =[UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:fontsize];
        label.numberOfLines=0;
        [self addSubview:label];
        [self addTarget:self action:@selector(clicked) forControlEvents: UIControlEventTouchUpInside];
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

-(BOOL)isChecked {
    return checked;
}

-(void)setChecked: (BOOL)flag {
    if (flag != checked)
    {
        checked = flag;
    }
    if (_style==CHECKBOX_STYLE_MULTISELECTED)
    {
        NSString *suffix = checked ? @"on" : @"off";
        NSString *imageName = [NSString stringWithFormat:@"cb_glossy_%@", suffix];
        [icon setImage: [UIImage imageNamed:imageName]];
    }
    else if (_style==CHECKBOX_STYLE_SINGLESELECTED)
    {
        NSString *suffix = checked ? @"Selected" : @"Unselected";
        NSString *imageName = [NSString stringWithFormat:@"RadioButton-%@", suffix];
        [icon setImage: [UIImage imageNamed:imageName]];
    }
}

-(void)clicked {
    if (_style==CHECKBOX_STYLE_MULTISELECTED)
        [self setChecked: !checked];
    else if (_style==CHECKBOX_STYLE_SINGLESELECTED)
        [self setChecked:YES];

    if (delegate != nil)
    {
        SEL sel = NSSelectorFromString (@"checkBoxClicked:");
        if ([delegate respondsToSelector: sel])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [delegate performSelector: sel withObject:self];
#pragma clang diagnostic pop
        }
    }
}

-(NSString *)text
{
    return label.text;
}

-(void)setText:(NSString *)t
{
    CGSize sz = [t sizeWithFont:label.font  constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT)];
    int lb_x=icon.frame.origin.x+icon.frame.size.width+CHECKBOX_MARGIN;
    int rheight=sz.height>MinHeight?sz.height:MinHeight;
    CGRect labelFrame = CGRectMake(lb_x, CHECKBOX_MARGIN, self.frame.size.width - lb_x-CHECKBOX_MARGIN, sz.height);
    label.frame=labelFrame;
    label.text=t;
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, rheight+2*CHECKBOX_MARGIN);
    icon.frame = CGRectMake (icon.frame.origin.x, (self.frame.size.height-icon.frame.size.height)/2, icon.frame.size.width, icon.frame.size.height);
}

+(int)getViewHeight:(NSString *)t width:(int)width iconSize:(int)iconSize fontSize:(int)fontSize
{
    int MARGIN=2;
    iconSize=iconSize<14?14:iconSize;
    int minHeight=iconSize>fontSize?iconSize:fontSize;
    CGSize sz = [t sizeWithFont:[UIFont systemFontOfSize:fontSize]  constrainedToSize:CGSizeMake(width-MARGIN-iconSize-2*MARGIN, MAXFLOAT)];
    int rheight=sz.height>minHeight?sz.height:minHeight;
    return rheight+2*MARGIN;
}

-(void)dealloc {
#if ! __has_feature(objc_arc)
    delegate = nil;
    [label release];
    [icon release];
    [super dealloc];
#endif
}
@end
