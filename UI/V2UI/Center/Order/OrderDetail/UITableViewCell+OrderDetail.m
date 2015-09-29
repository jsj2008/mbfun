//
//  UITableViewCell+OrderDetail.m
//  Designer
//
//  Created by Juvid on 15/1/19.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "UITableViewCell+OrderDetail.h"

@implementation UITableViewCell (OrderDetail)
-(void)setStartUI
{
    for (int i=0; i<3; i++) {
        CGFloat vSpace=6;
        CGFloat topSpace=24;
        CGFloat labHight=14;
        NSArray *arr=@[@"收  货  人:",@"手       机:",@"收货地址:"];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(15, topSpace+i*(vSpace+labHight), self.frame.size.width-30, labHight)];
        lab.text=arr[i];
        lab.textColor=kUIColorFromRGB(0x313131);
        lab.backgroundColor=[UIColor clearColor];
        lab.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:lab];}
}
@end
