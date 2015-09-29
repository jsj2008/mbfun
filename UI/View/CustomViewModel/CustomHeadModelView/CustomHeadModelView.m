//
//  CustomHeadModelView.m
//  WeFFDemo
//
//  Created by fafatime on 14-4-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//  含有头部标题 和策划按钮选择.

#import "CustomHeadModelView.h"
#import "Utils.h"
#import "AppSetting.h"

@implementation CustomHeadModelView

- (id)initWithFrame:(CGRect)frame WithDic:(NSDictionary *)transDic WithColor:(NSString *)colcorStr
{
    self = [super init];
    if (self) {
        [self setFrame:frame];
        //7.1的sdk
        if (IOS_VERSION>=7.0)
        {
            [self setFrame:frame];
            ios7height=20;
        }
        else
        {
            [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-20)];
            ios7height=0;
        }
        
        
        dictionary = [[NSDictionary alloc]initWithDictionary:transDic];
//        NSLog(@"头部--%@",dictionary);
//        NSLog(@"头部的颜色===%@",colcorStr);
        
        NSString *titleA = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"text"]];

        UIImageView *headImgView=[[UIImageView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.frame.size.height)];
        headImgView.userInteractionEnabled=YES;
        UILabel *nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(50, 5+ios7height, UI_SCREEN_WIDTH-100, 40)]; //25
        UIImageView *headLogo=[[UIImageView alloc]initWithFrame:CGRectMake(115,5+ios7height, 100, 40)];
//        headLogo.hidden=YES;
        //缓存文件
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *nameFile=[NSString stringWithFormat:@"%@",[AppSetting getXMLFilePath]];
        NSString *zipUpPath= [nameFile stringByAppendingPathComponent:[NSString stringWithFormat:@"url"]];
        //背景颜色
        headImgView.backgroundColor=TITLE_BG;
        
        //头像
        if ([dictionary objectForKey:@"text"]==nil)
        {
//            NSLog(@"as");

            if ([[[dictionary objectForKey:@"center"] objectForKey:@"title"] objectForKey:@"img"]==nil)
            {
                NSLog(@"abc没有图片 原生应用");
                nameLabel.hidden=NO;
                headLogo.hidden=YES;
                titleA = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"text"]];
//                NSLog(@"titleA===%@",titleA);
                headImgView.backgroundColor=TITLE_BG;
           
                if ([dictionary objectForKey:@"text"]==nil)
                {
                    
                    titleA = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"functionname"]];
            
                }
                
            }
            else
            {
                nameLabel.hidden=YES;
                headLogo.hidden=NO;
                NSString *imgStr=[NSString stringWithFormat:@"%@",[[[dictionary objectForKey:@"center"] objectForKey:@"title"] objectForKey:@"img"]];
                [headLogo setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",zipUpPath,imgStr]]];
                [headImgView addSubview:headLogo];
//                [headLogo release];
//                NSLog(@"-----%@-----%@",zipUpPath,imgStr);
            }

            
        }
        else
        {
           
            nameLabel.hidden=NO;
            headLogo.hidden=YES;
            
        }

        
        UIButton *menuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        menuBtn.hidden=YES;
        menuBtn.titleLabel.font=[UIFont systemFontOfSize:17.0f];
        UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.hidden=YES;

        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(8, 17+ios7height, 13, 22)];//37
        imageView.hidden=YES;
        
        [imageView setImage:[UIImage imageNamed:@"backImg.png"]];
        [headImgView addSubview: imageView];

        NSString *defaultName=[defaults objectForKey:@"nameback"];
//        NSLog(@"defaultName---%@",defaultName);
        
        if ([[dictionary objectForKey:@"text"]isEqualToString:defaultName])
        {
            menuBtn.hidden=YES;
        }
        else
        {
            menuBtn.hidden=NO;
            imageView.hidden=NO;
            
            [menuBtn setTitle:@"返回" forState:UIControlStateNormal];
            
        }
        [menuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(clickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [menuBtn setFrame:CGRectMake(10, 9+ios7height,60,40)];//0, 35,70, 25) 29
        [headImgView addSubview:menuBtn];
        

        nameLabel.text=titleA;
        nameLabel.font=[UIFont systemFontOfSize:22];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        
        nameLabel.textColor=[UIColor whiteColor];
        nameLabel.backgroundColor=[UIColor clearColor];
        [headImgView addSubview:nameLabel];
//        [nameLabel release];
        [headImgView addSubview:rightBtn];
        backJust = [NSString stringWithFormat:@"%@",nameLabel.text];
        
        [self addSubview:headImgView];
//        [headImgView release];
        
    }
    return self;
}

//目录按钮
-(void)clickMenuBtn:(UIButton *)sender
{
    NSDictionary *trName=[NSDictionary dictionaryWithObjectsAndKeys:backJust,@"headName", nil];
    if ([sender.titleLabel.text isEqualToString:@"返回"])
    {
        NSLog(@"点击返回");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backhome"
                                                            object:nil
                                                          userInfo:trName];
        
    }
    else
    {
        NSLog(@"点击目录");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showPath"
                                                            object:nil];
    }
    
}
-(void)rightbutton
{
    //将右键按钮下的列表字典通过通知传送出去
//    NSDictionary *rightBtnDic=[NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"right"]];
//    NSLog(@"r==%@",rightBtnDic);
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"rightBtn"
//                                                        object:nil
//                                                      userInfo:rightBtnDic];

    
}

@end
