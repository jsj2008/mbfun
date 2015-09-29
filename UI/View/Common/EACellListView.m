//
//  EASelectRoomView.m
//  iShangEManager
//
//  Created by mac on 13-7-10.
//  Copyright (c) 2013年 FafaTimes. All rights reserved.
//

#import "EACellListView.h"
#import "QuartzCore/QuartzCore.h"
#import "UIButton+WebCache.h"
#import "UIUrlImageView.h"
#import "AppSetting.h"

#define kCellHeight 18
#define kCellWidth 58

@implementation EACellListView
//@synthesize datasource;
@synthesize dataArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)awakeFromNib
{
    [self innerInit];
}

-(void)innerInit
{
    _activeIndex=-1;
    _buttonTextColor = [UIColor darkGrayColor];
    _buttonBorderColor = [UIColor darkGrayColor];
    _buttonActiveTextColor = [UIColor redColor];
    _buttonActiveBorderColor = [UIColor redColor];
    _cellSize=CGSizeMake(kCellWidth,kCellHeight);
    _textFont=[UIFont boldSystemFontOfSize:12];
}

-(void)removeAllView{
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
}

-(void)reloadData
{
    [self removeAllView];
    [self createSubviews];
}

-(int)getListViewHeight
{
    return _realViewHeight;
}

-(void)createSubviews
{
    int splitwidth=_margin>0?_margin:2;
    int y=splitwidth;
    int x=splitwidth;
    int buttonsListHeight=splitwidth;
    
    for (int i=0;i<[dataArray count];i++)
    {
        NSString *str1=[dataArray objectAtIndex:i];
        UIButton *_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame=CGRectMake(x-6, y, _cellSize.width, _cellSize.height);

        [_btn setTitleColor:_buttonTextColor forState:UIControlStateNormal];
//        [_btn setTitleShadowColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1] forState:UIControlStateNormal];
        _btn.tintColor = [UIColor colorWithRed:0.3 green:0.6 blue:0.3 alpha:0.8];
        _btn.backgroundColor=[UIColor whiteColor];
        _btn.tag=i;
        _btn.titleLabel.font=_textFont;
        if (_cellType==EALIST_CELL_TYPE_TEXT)
            [_btn setTitle:str1 forState:UIControlStateNormal];
        else if (_cellType==EALIST_CELL_TYPE_IMAGE)
        {
//            [_btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
//            if ([[[str1 substringToIndex:7] lowercaseString] isEqualToString:@"http://"] || [[[str1 substringToIndex:8] lowercaseString] isEqualToString:@"https://"])
//            {
//                [_btn setImageWithURL:[NSURL URLWithString:str1] forState:UIControlStateNormal];
//            }
//            else
//                 [_btn setBackgroundImage:[UIImage imageNamed:str1] forState:UIControlStateNormal];
            
            
            UIUrlImageView *img=[[UIUrlImageView alloc] initWithFrame:_btn.frame];
            [img setContentMode:UIViewContentModeScaleAspectFit];
            if (str1.length==0)
                img.image=[UIImage imageNamed:DEFAULT_LOADING_IMAGE];
            else if ([[[str1 substringToIndex:7] lowercaseString] isEqualToString:@"http://"] || [[[str1 substringToIndex:8] lowercaseString] isEqualToString:@"https://"])
            {
                [img downloadImageUrl:str1 cachePath:[AppSetting getMBCacheFilePath] defaultImageName:@""];
            }
            else
                [img downloadImageUrl:str1 cachePath:[AppSetting getMBCacheFilePath] defaultImageName:@""];
            [self addSubview:img];
            
            _btn.backgroundColor=[UIColor clearColor];
        }
        [_btn addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

//        _btn.layer.cornerRadius = 2.0;
        _btn.layer.borderWidth = 1.0;
        _btn.layer.borderColor = _buttonBorderColor.CGColor;
        buttonsListHeight=_btn.frame.origin.y+_btn.frame.size.height-splitwidth;
        
        [self addSubview:_btn];
        
        x+=splitwidth+_cellSize.width;
        if (self.frame.size.width-(x+splitwidth+_cellSize.height)<=0)
        {
            y+=splitwidth+_cellSize.height;
            x=splitwidth;
        }
    }
    _realViewHeight=buttonsListHeight+2*splitwidth;
    if (_contentVerticalAlignment==EALIST_VERTICAL_ALIGNMENT_CENTER)
    {
        if (self.frame.size.height>buttonsListHeight)
        {
            int newStartY=(self.frame.size.height-buttonsListHeight)/2;
            int offsetY=newStartY-splitwidth;
            for (UIButton *btn in self.subviews)
            {
                btn.frame=CGRectOffset(btn.frame, 0, offsetY);
            }
        }
    }
    if (_cellType==EALIST_CELL_TYPE_IMAGE)
    {
        UIImage *img=[UIImage imageNamed:@"btn_select@3x.png"];
        _imageSelectedFlag=[[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, img.size.width/3, img.size.height/3)];
        _imageSelectedFlag.image=img;
        [self addSubview:_imageSelectedFlag];
    }
}


//SEL:  -(void)_sizeListView_onButtonClick:(id)sender button:(id)button
-(void)setDelegate:(id)del selector:(SEL)sel;
{
    delegate=del;
    selectorAddItemClick=sel;
}

-(void)addButtonClicked:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if (_listStyle==EALIST_STYLE_BUTTON_RADIOBUTTON)
    {
            [self setActiveIndex:(int)btn.tag];
    }
    if (_listStyle==EALIST_STYLE_BUTTON_CHECKBUTTON)
        [self setActiveIndex:(int)btn.tag!=_activeIndex?(int)btn.tag:-1];
    else
        _activeIndex=(int)btn.tag;
    
    if (delegate && selectorAddItemClick!=nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [delegate performSelector:selectorAddItemClick withObject:self withObject:sender];
#pragma clang diagnostic pop
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setButtonBorderColor:(UIColor *)bordercolor textColor:(UIColor *)textcolor
{
    _buttonBorderColor=bordercolor;
    _buttonTextColor=textcolor;
    [self drawButtonColor];
}

-(void)setButtonActiveBorderColor:(UIColor *)bordercolor activeTextColor:(UIColor *)textcolor
{
    _buttonActiveBorderColor=bordercolor;
    _buttonActiveTextColor=textcolor;
    [self drawButtonColor];
}

-(void)drawButtonColor
{
    _imageSelectedFlag.frame=CGRectMake(-100,_imageSelectedFlag.frame.size.height-_imageSelectedFlag.frame.size.height,_imageSelectedFlag.frame.size.width,_imageSelectedFlag.frame.size.height);
    
    for (UIButton *btn in self.subviews)
    {
        if ([btn isKindOfClass:[UIButton class]]==NO)
            continue;
        int i=(int)btn.tag;
        
        if (_enableArray.count>0 && [_enableArray[i] intValue]==0)
        {
            btn.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
            btn.layer.borderWidth = 1;
            btn.enabled=NO;
            [btn setTitleColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] forState:UIControlStateNormal];
            if (_cellType==EALIST_CELL_TYPE_IMAGE)
                btn.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
            else
                btn.backgroundColor=[UIColor whiteColor];
        }
        else
        {
            if (_cellType==EALIST_CELL_TYPE_IMAGE)
                btn.backgroundColor=[UIColor clearColor];
            else
                btn.backgroundColor=[UIColor whiteColor];

            if ((_listStyle==EALIST_STYLE_BUTTON_RADIOBUTTON || _listStyle==EALIST_STYLE_BUTTON_CHECKBUTTON) && _activeIndex==i)
            {
                [btn setTitleColor:_buttonActiveTextColor forState:UIControlStateNormal];
                btn.layer.borderColor = _buttonActiveBorderColor.CGColor;
                btn.layer.borderWidth = 1.5;
                if (_imageSelectedFlag!=nil)
                {
                    _imageSelectedFlag.frame=CGRectMake(btn.frame.origin.x,btn.frame.origin.y+btn.frame.size.height-_imageSelectedFlag.frame.size.height,_imageSelectedFlag.frame.size.width,_imageSelectedFlag.frame.size.height);
                }
            }
            else
            {
                [btn setTitleColor:_buttonTextColor forState:UIControlStateNormal];
                btn.layer.borderColor = _buttonBorderColor.CGColor;
                btn.layer.borderWidth = 1;
            }
            btn.enabled=YES;
        }
    }
    if (_imageSelectedFlag!=nil)
        [_imageSelectedFlag.superview bringSubviewToFront:_imageSelectedFlag];
}

-(void)setActiveIndex:(int)activeIndex1
{
    _activeIndex=activeIndex1;
    [self drawButtonColor];
}

-(void)setEnableArray:(NSArray *)arr
{
    _enableArray=[[NSMutableArray alloc] initWithArray:arr];
    [self drawButtonColor];
}

-(int)getCellIndex:(NSString*)text
{
    for (int i=0;i<dataArray.count;i++)
    {
        NSString *str=dataArray[i];
        if ([str isEqualToString:text])
        {
            return i;
        }
    }
    return -1;
}

@end
