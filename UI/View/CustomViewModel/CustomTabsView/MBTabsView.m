//
//  MBTabsView.m
//  Wefafa
//
//  Created by mac on 14-9-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MBTabsView.h"
#import "AttendCustomButton.h"
#import "Utils.h"
@implementation MBTabsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame WithTitleArray:(NSArray *)transTitleArray withIconArray:(NSArray*)iconArray useScroll:(BOOL)useScroll WithPicAndText:(BOOL)pic
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:244.0/255.0 alpha:1];
        _activeColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:244.0/255.0 alpha:1];
        _textColor=[UIColor blackColor];
        _selectedTextColor=[UIColor blueColor];
        [self showUnderline:YES];
        
        [self setBackgroundColor:_backgroundColor];
        NSArray * titleArray = [NSArray arrayWithArray:transTitleArray];
        
        UIScrollView *secondView = [[UIScrollView alloc]init];
        
        secondView.delegate=self;
        buttonArray=[[NSMutableArray alloc] initWithCapacity:5];
        activeButtonIndex=0;
        
        secondView.userInteractionEnabled=YES;
        [secondView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        [self addSubview:secondView];
        
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
        
        UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(secondView.frame.origin.x, secondView.frame.size.height-0.5, secondView.frame.size.width, 0.5)];
        [secondView addSubview:view];
        view.backgroundColor=[Utils HexColor:0x373737 Alpha:0.5];
        
        UIFont *font=[UIFont systemFontOfSize:11.0f];
        int iconsize=12;
        NSMutableString *titlestr=[[NSMutableString alloc] init];
        for (int a=0; a<[titleArray count]; a++)
        {
            [titlestr appendString:[titleArray objectAtIndex:a]];
        }
        CGSize allsize=[titlestr sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
        int margin=2;
        int iconwidth=0;
        if (iconArray.count>0)
            iconwidth=iconsize+1;
        
        int span=(SCREEN_WIDTH-2*36-allsize.width-titleArray.count*(iconwidth+2*margin))/([titleArray count]-1);
        
        float x=36;
        for (int a=0; a<[titleArray count]; a++)
        {
            NSString *titlestr=[titleArray objectAtIndex:a];
            CGSize titlesize=[titlestr sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
            AttendCustomButton *clickBtn=[[AttendCustomButton alloc]initWithFrame:CGRectMake(x+xx*a, 0, xx, self.frame.size.height)];
            
            clickBtn.titleLabel.text=titlestr;
            int startx=margin;
            if (iconArray.count>0)
            {
                clickBtn.itemImage.image=[UIImage imageNamed:[iconArray objectAtIndex:a]];
                clickBtn.itemImage.frame=CGRectMake(margin, (self.frame.size.height-iconsize)/2, iconsize, iconsize);
                startx+=clickBtn.itemImage.frame.origin.x+clickBtn.itemImage.frame.size.width;
            }
            clickBtn.titleLabel.font=font;
            int w=startx;
            clickBtn.titleLabel.frame=CGRectMake(startx+1,0, titlesize.width, clickBtn.frame.size.height);
            w+=1+clickBtn.titleLabel.frame.size.width+margin;
            clickBtn.clickImgView.frame=CGRectMake(0,clickBtn.frame.size.height-2,w, 2);
            
            clickBtn.tag=a;
            [clickBtn setTitleColor:_textColor forState:UIControlStateNormal];
            [clickBtn addTarget:self
                         action:@selector(btnClick:)
               forControlEvents:UIControlEventTouchUpInside];
            [secondView addSubview:clickBtn];
            [clickBtn.clickImgView setBackgroundColor:_selectedTextColor];
            [buttonArray addObject:clickBtn];
            
            clickBtn.frame=CGRectMake(x, 0, w, self.frame.size.height);
            x+=w+span;
        }
        
        if (buttonArray.count>activeButtonIndex)
            ((AttendCustomButton*)buttonArray[activeButtonIndex]).clickImgView.hidden=(!isShowUnderLine)|NO;
        
        [self setActiveColor:_activeColor];
        [self setSelectedTextColor:_selectedTextColor];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
}
*/

@end
