//
//  CustomBottomView.m
//  WeFFDemo
//
//  Created by fafatime on 14-4-29.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CustomBottomView.h"

@implementation CustomBottomView

- (id)initWithFrame:(CGRect)frame WithDic:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        if (IOS_VERSION>=7.0)
        {
//            [self setFrame:frame];
//            [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        }
        else
        {
            [self setFrame:CGRectMake(frame.origin.x, frame.origin.y-20, frame.size.width, frame.size.height)];
        }
        NSDictionary *bottomDic=[NSDictionary dictionaryWithDictionary:dic];
//        NSLog(@"底部的字典====%@",bottomDic);
        NSString *bgViewColor=[[bottomDic objectForKey:@"nav"] objectForKey:@"_style"];
        if ([[bottomDic objectForKey:@"nav"]objectForKey:@"_style"]==nil)
        {
            
            bgViewColor = [[NSString alloc]initWithFormat:@"background-color:RGB(70,70,70) RGB(185,24,24)"];
        }
        //背景颜色的数据处理
        NSArray *array = [bgViewColor componentsSeparatedByString:@":"];
        NSString *str=[array objectAtIndex:1];
        NSArray *array1=[str componentsSeparatedByString:@" "];
        //不点击的颜色
        NSString *colorStr = [array1 objectAtIndex:0];
        NSArray *array2 =[colorStr componentsSeparatedByString:@"RGB("];
        NSString *colorStr1=[array2 objectAtIndex:1];
        NSArray *array3 = [colorStr1 componentsSeparatedByString:@")"];
        NSString *colorStr3 = [array3 objectAtIndex:0];
        // 点击的背景颜色
//        NSString *actcolorStr =[array1 objectAtIndex:1];
//        NSArray *actarray2 =[actcolorStr componentsSeparatedByString:@"RGB("];
//        NSString *actcolorStr1=[actarray2 objectAtIndex:1];
//        NSArray *actarray3 = [actcolorStr1 componentsSeparatedByString:@")"];
//        NSString *actcolorStr3 = [actarray3 objectAtIndex:0];
        NSArray *bgcolorArray=[colorStr3 componentsSeparatedByString:@","];
//        NSArray *activeArray = [actcolorStr3 componentsSeparatedByString:@","];
//        NSLog(@"bgViewColor===%@",bgViewColor);
//        NSLog(@"zr===%@",array1);
//        NSLog(@"bg==%@--ac=%@",bgcolorArray,activeArray);
        
        UIColor *color =[UIColor colorWithRed:[[bgcolorArray objectAtIndex:0] integerValue]/255.0 green:[[bgcolorArray objectAtIndex:1]integerValue]/255.0 blue:[[bgcolorArray objectAtIndex:2]integerValue]/255.0 alpha:1];
        
//        UIColor *selectColor=[UIColor colorWithRed:[[activeArray objectAtIndex:0]integerValue]/255.0 green:[[activeArray objectAtIndex:1]integerValue]/255.0 blue:[[activeArray objectAtIndex:2]integerValue]/255.0 alpha:1.0];
        UIImageView *bottomImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [bottomImgV setBackgroundColor:color];
        [self addSubview:bottomImgV];
//        [bottomImgV release];
        
        
//        NSArray *itemArray=[[[bottomDic objectForKey:@"nav"] objectForKey:@"navitem"]objectForKey:@"item"];
        NSArray *itemArray =[NSArray arrayWithObjects:@"转发",@"评论",@"收藏",nil];
        
        
        for (int a =0; a<[itemArray count]; a++)
        {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(5+110*a, 10, 100, 30)];
            [self addSubview:button];
            [button setTitle:[itemArray objectAtIndex:a] forState:UIControlStateNormal];
            
        }
        

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
