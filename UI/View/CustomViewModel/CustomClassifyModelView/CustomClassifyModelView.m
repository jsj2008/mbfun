//
//  CustomClassifyModelView.m
//  WeFFDemo
//
//  Created by fafatime on 14-4-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
// 含有二级滑动分类标签 跟 搜索选择


#import "CustomClassifyModelView.h"
#import "AppSetting.h"

#import <QuartzCore/QuartzCore.h>
@implementation CustomClassifyModelView

- (id)initWithFrame:(CGRect)frame withDictionary:(NSDictionary *)transdic withName:(NSString *)nameStr
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        self.userInteractionEnabled=YES;
        
        dictionary= [[NSDictionary alloc]initWithDictionary:transdic];
        //二级菜单模块
//        NSLog(@"搜索模块中的 dic====%@",dictionary);
        

        //二层轮滑页面是否显示
        if ([[dictionary objectForKey:@"tabitem"]count]>0)
        {
//            UIScrollView *
            secondView = [[UIScrollView alloc]init];
            secondView.delegate=self;
//            secondView.bounces=YES;
            secondView.userInteractionEnabled=YES;
            [secondView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [secondView setContentSize:CGSizeMake(UI_SCREEN_WIDTH+150, 0)];
            [self addSubview:secondView];
            
//            secondView.pagingEnabled=YES;
            secondView.showsVerticalScrollIndicator=NO;//垂直线
            secondView.showsHorizontalScrollIndicator=NO;//水平线
            NSArray *itemArray = [NSArray arrayWithArray: [dictionary objectForKey:@"tabitem"]];
            NSMutableArray *nameMuArray = [[NSMutableArray alloc]init];
            for (int a=0; a<[itemArray count]; a++)
            {
                [nameMuArray addObject:[[itemArray objectAtIndex:a] objectForKey:@"itemname"]];
                
            }
//            NSString *activebg=[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"tabs"]objectForKey:@"_style" ]];
//            NSArray *icar=[activebg componentsSeparatedByString:@"("];
//            NSString *on=[icar objectAtIndex:1];
//            NSArray *onAry=[on componentsSeparatedByString:@")"];
//            NSString *activBJ=[onAry objectAtIndex:0];
            
         //图片的地址
//            NSString *nameFile=[NSString stringWithFormat:@"%@",[AppSetting getXMLFilePath]];
//
//            detailstrname = [[NSString alloc]initWithFormat:@"%@",nameStr];
//            NSString *detailNameFile=[nameFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",detailstrname]];
//
//            NSString *zipUpPath= [detailNameFile stringByAppendingPathComponent:[NSString stringWithFormat:@"secondImg"]];
            
//            NSString *iconString =[NSString stringWithFormat:@"%@/%@",zipUpPath,activBJ];
            for(int a=0;a<[nameMuArray count];a++)
            {
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:[nameMuArray objectAtIndex:a] forState:UIControlStateNormal];


                button.titleLabel.font=[UIFont systemFontOfSize:16];
                
                button.tag=100+a;
                [button addTarget:self
                           action:@selector(secondViewModelChange:)
                 forControlEvents:UIControlEventTouchUpInside];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor clearColor]];

                if (a==0)
                {
//                  [button setBackgroundImage:[UIImage imageWithContentsOfFile:iconString] forState:UIControlStateNormal];
                }

                NSString *textLengthSt=[nameMuArray objectAtIndex:a];
//                NSLog(@"textLengthSt===%d",textLengthSt.length);
                if (textLengthSt.length==4)
                {
                 [button setFrame:CGRectMake(5+80*a, 0, 80,secondView.frame.size.height)];
                }
                else
                {
            
                    if ([nameMuArray count]>=5)
                    {
                        [button setFrame:CGRectMake(20+60*a, 0, 50, secondView.frame.size.height)];
                    }
                    else
                    {
                           [button setFrame:CGRectMake(25+70*a, 0, 50,secondView.frame.size.height)];
                    }
                }
          
                [secondView addSubview:button];
            }
//            NSString *normalColorStr=[NSString stringWithFormat:@"%@",[[[dictionary objectForKey:@"tabs"]objectForKey:@"_style"]objectForKey:@"tabnormalbg"]];
//            NSArray *bgcolorArray=[normalColorStr componentsSeparatedByString:@","];
//            
//            UIColor *color =[UIColor colorWithRed:[[bgcolorArray objectAtIndex:0] integerValue]/255.0 green:[[bgcolorArray objectAtIndex:1]integerValue]/255.0 blue:[[bgcolorArray objectAtIndex:2]integerValue]/255.0 alpha:1];
//            [secondView setBackgroundColor:color];
//            [secondView release];
            
        
        }
        else
        {
        //搜索框的背景
        UIImageView *souImgView=[[UIImageView alloc]init];
        souImgView.hidden=NO;
        souImgView.userInteractionEnabled=YES;
        [souImgView setBackgroundColor:[UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:206.0/255.0 alpha:1]];
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(10, 8, UI_SCREEN_WIDTH-20, 28)];
        textField.placeholder=@"  搜索";
        textField.backgroundColor=[UIColor whiteColor];
        textField.userInteractionEnabled=NO;
        textField.layer.masksToBounds = YES;
        textField.layer.cornerRadius = 6.0;
        [souImgView addSubview:textField];
        [self addSubview:souImgView];
//        [textField release];
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                            action:@selector(gotoSearch)];
        
        [souImgView addGestureRecognizer:tap];
//        [tap release];

        }
    }
    return self;
}
-(void)gotoSearch
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoSearch"
                                                        object:nil
                                                      userInfo:nil];
}
-(void)secondViewModelChange:(UIButton*)clickSender
{
//    NSLog(@"click。t.ag====%d",clickSender.tag-100);
/*
    //图片的地址
    NSString *activebg=[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"tabs"]objectForKey:@"_style" ]];
    NSArray *icar=[activebg componentsSeparatedByString:@"("];
    NSString *on=[icar objectAtIndex:1];
    NSArray *onAry=[on componentsSeparatedByString:@")"];
    NSString *activBJ=[onAry objectAtIndex:0];
 
    NSString *nameFile=[NSString stringWithFormat:@"%@",[AppSetting getXMLFilePath]];
//    NSString *detailstrname=[NSString stringWithFormat:@"%@",nameStr];
    NSString *detailNameFile=[nameFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",detailstrname]];
    NSString *zipUpPath= [detailNameFile stringByAppendingPathComponent:[NSString stringWithFormat:@"secondImg"]];
    NSString *iconString =[NSString stringWithFormat:@"%@/%@",zipUpPath,activBJ];
    NSLog(@"iconString==%@",iconString);
    
    for (UIView *subView in secondView.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]])
        {
            
//            NSLog(@"subview==%@",subView);
            if (subView.tag==clickSender.tag)
            {
                [(UIButton*)subView setBackgroundImage:[UIImage imageWithContentsOfFile:iconString] forState:UIControlStateNormal];
            }
            else
            {
                [(UIButton *)subView setBackgroundImage:nil forState:UIControlStateNormal];
                
            }
        }
        
    }
*/
    NSString *clickSt=[NSString stringWithFormat:@"%d",(int)clickSender.tag-100];
    NSDictionary *clickTagDic=[NSDictionary dictionaryWithObjectsAndKeys:clickSt,@"tag",nil];
//    NSLog(@"dictag===%@",clickTagDic);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickSecondView"
                                                        object:nil
                                                      userInfo:clickTagDic];
    
    
}

@end
