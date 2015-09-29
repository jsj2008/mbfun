//
//  HeadBtnView.m
//  Wefafa
//
//  Created by fafatime on 14-12-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "HeadBtnView.h"
#import "CustomHeadBtn.h"
#import "Utils.h"


@implementation HeadBtnView
@synthesize colloctBtn,goodBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        colloctBtn=[CustomHeadBtn buttonWithType:UIButtonTypeCustom];
        [colloctBtn setTitle:@"搭配" forState:UIControlStateNormal];
        [colloctBtn setBackgroundColor:[UIColor clearColor]];
//        [colloctBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        colloctBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
//        [colloctBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [colloctBtn setTitleColor:[Utils HexColor:0x333333 Alpha:1] forState:UIControlStateNormal];
        
        [colloctBtn setFrame:CGRectMake(0, (frame.size.height - 10)/2-3, frame.size.width/2, 30)];
        colloctBtn.style=6;
        colloctBtn.selected=YES;
        
        [self addSubview:colloctBtn];
        goodBtn=[CustomHeadBtn buttonWithType:UIButtonTypeCustom];
        [goodBtn setFrame:CGRectMake(frame.size.width/2, (frame.size.height - 10)/2-3, frame.size.width/2, 30)];
        [goodBtn setTitle:@"单品" forState:UIControlStateNormal];
        [goodBtn setBackgroundColor:[UIColor clearColor]];
        goodBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [goodBtn setTitleColor:[Utils HexColor:0x333333 Alpha:1] forState:UIControlStateNormal];
        goodBtn.style=7;
        

        [self addSubview:goodBtn];
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

@end
