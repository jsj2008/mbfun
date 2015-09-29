//
//  CustomGridCell.m
//  Wefafa
//
//  Created by mac on 14-8-28.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CustomGridCell.h"

static const int Margin=8;

@implementation CustomGridCell

@synthesize image;
@synthesize namelabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self configView];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
static const int blank=3;
-(void)configView
{
    self.backgroundColor=[UIColor clearColor];
    
    CGRect imgframe;
    imgframe.size.width=Btn_WITHE;
    imgframe.size.height=Btn_HIGHT;
    imgframe.origin.x = (self.frame.size.width-imgframe.size.width)/2;
    imgframe.origin.y = Margin;
    image=[[UIImageView alloc] initWithFrame:imgframe];
    image.tag=1000;
    //    image.backgroundColor=[UIColor clearColor];
    [self addSubview:image];
    
    CGRect labelframe;
    labelframe.origin.x = Margin;
    labelframe.origin.y = imgframe.origin.y+imgframe.size.height+blank;
    labelframe.size.width=self.frame.size.width-2*Margin;
    labelframe.size.height=self.frame.size.height-labelframe.origin.y-Margin;
    
    namelabel = [[UILabel alloc]init];
    namelabel.tag=1001;
    [namelabel setFrame:labelframe];
    namelabel.textAlignment = NSTextAlignmentCenter;
    namelabel.backgroundColor=[UIColor clearColor];
    namelabel.font=[UIFont systemFontOfSize:13];
    [self addSubview:namelabel];
}

+(float)MinGridHeight
{
    return Margin+Btn_HIGHT+blank+16+Margin;
}

-(void)clicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(click:forIndex:)])
    {
        [self.delegate click:self forIndex:_gridIndex];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
    
    [self clicked:self];
}

@end;

