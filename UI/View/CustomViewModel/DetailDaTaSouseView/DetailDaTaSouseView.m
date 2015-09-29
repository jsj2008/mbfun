//
//  DetailDaTaSouseView.m
//  WeFFDemo
//
//  Created by fafatime on 14-4-29.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "DetailDaTaSouseView.h"
//#import "JSON/JSON.h"
#import "JSON.h"
#import "XMLDictionary.h"
#import "UIImageView+WebCache.h"
@implementation DetailDaTaSouseView

- (id)initWithFrame:(CGRect)frame WithDic:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        if (IOS_VERSION>=7.0)
        {
//           [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-20)];
        }
        else
        {
            [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-20)];
        }
        NSDictionary *transDic=[NSDictionary dictionaryWithDictionary:dic];
//        NSLog(@"具体的列表信息展示====%@",transDic);
        [self setBackgroundColor:[UIColor whiteColor]];
        UIScrollView *backScView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backScView.bounces=YES;
        backScView.userInteractionEnabled=YES;
       
        [self addSubview:backScView];
        
        UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 3, self.frame.size.width,50)];
        [backScView addSubview:topView];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, topView.frame.size.width-10, 25)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor=[UIColor blackColor];
//        nameLabel.font=[UIFont systemFontOfSize:16.0f];
        nameLabel.font=[UIFont systemFontOfSize:22.0f];
        nameLabel.text=[transDic objectForKey:@"news_title"];
        
        [topView addSubview:nameLabel];
//        [nameLabel release];
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(topView.frame.size.width/2, 25, 170, 25)];
        timeLabel.backgroundColor=[UIColor clearColor];
        
        timeLabel.textColor=[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1];
        [topView addSubview:timeLabel];
        timeLabel.font=[UIFont systemFontOfSize:15.0f];
        
        timeLabel.text=[transDic objectForKey:@"news_date"];
//        [timeLabel release];
        UILabel *sourceLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 150, 25)];
        sourceLabel.backgroundColor=[UIColor clearColor];
        [topView addSubview:sourceLabel];
        sourceLabel.textColor=[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1];
        
        sourceLabel.font=[UIFont systemFontOfSize:15.0f];
        sourceLabel.text=[transDic objectForKey:@"news_subtitle"];
//        [sourceLabel release];
        UIImageView *lineImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height-1, topView.frame.size.width, 1)];
        [lineImg setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1]];
        [topView addSubview:lineImg];
//        [lineImg release];
        //将content文字 图片 拆分开
        NSString *contentSt=[NSString stringWithFormat:@"%@",[transDic objectForKey:@"news_content"]];
        NSArray *array=[contentSt componentsSeparatedByString:@"</a>"];
//        NSLog(@"array====%@",array);
        NSString *imgSt=[array objectAtIndex:0];
//        NSLog(@"imgSt===%@",imgSt);
        NSDictionary *dicPic=[NSDictionary dictionaryWithXMLString:imgSt];
//        NSLog(@"dicpic====%@",dicPic);
        
        UIImageView *textImgView=[[UIImageView alloc]initWithFrame:CGRectMake(90, lineImg.frame.origin.y+15, [[[dicPic objectForKey:@"img"]objectForKey:@"_width"]intValue], [[[dicPic objectForKey:@"img"]objectForKey:@"_height"]intValue])];
        [textImgView setImageWithURL:[dicPic objectForKey:@"_href"]];
        [backScView addSubview:textImgView];
        
        
         //textview的高度要根据文字的高度来进行判断。
//        UITextView *contentTextView=[[UITextView alloc]initWithFrame:CGRectMake(topView.frame.origin.x, topView.frame.origin.y+topView.frame.size.height, topView.frame.size.width, self.frame.size.height-topView.frame.origin.y-topView.frame.size.height)];
        UITextView *contentTextView=[[UITextView alloc]init];
       
        NSString *st = [NSString stringWithFormat:@"%@",[array objectAtIndex:1]];
//        NSString *ss=;
         contentTextView.text=[self filterHTML:st];
        contentTextView.backgroundColor=[UIColor clearColor];
        contentTextView.font=[UIFont systemFontOfSize:16.0f];//14
        contentTextView.userInteractionEnabled=NO;
        [backScView addSubview:contentTextView];
        
        CGSize max=CGSizeMake(topView.frame.size.width, 10000);
        CGSize textSize=[contentTextView.text sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:max lineBreakMode:NSLineBreakByCharWrapping];
//        textview.font = [UIFont systemFontOfSize:14.0f];
        [contentTextView setFrame:CGRectMake(0,textImgView.frame.size.height+topView.frame.origin.y+topView.frame.size.height, topView.frame.size.width, textSize.height+400)];
        if (textSize.height>1000)
        {
            [contentTextView setFrame:CGRectMake(0,textImgView.frame.size.height+topView.frame.origin.y+topView.frame.size.height, topView.frame.size.width, textSize.height+510)];
            
         
            
        }

        
//         [backScView setContentSize:CGSizeMake(0,self.frame.size.height+contentTextView.frame.size.height)];
          [backScView setContentSize:CGSizeMake(0,contentTextView.frame.size.height)];
        
    }
    return self;
}
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}
@end
