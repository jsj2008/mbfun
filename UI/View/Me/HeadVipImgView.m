//
//  HeadVipImgView.m
//  Wefafa
//
//  Created by metesbonweios on 15/7/20.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "HeadVipImgView.h"

@implementation HeadVipImgView
@synthesize headImgView,vipImgView;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        headImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        headImgView.layer.cornerRadius =headImgView.frame.size.width/ 2;
        headImgView.layer.borderWidth = 3.0;
        headImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        headImgView.layer.masksToBounds = YES;
        [self addSubview:headImgView];

        vipImgView=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-((headImgView.frame.size.width/4)*frame.size.width/100)+10-10*frame.size.width/100, frame.size.height-10-headImgView.frame.size.width/4, 20, 20)];
//        if (frame.size.width<70) {
//            //50
//           [vipImgView setFrame:CGRectMake(frame.size.width-15, frame.size.height-15, 15,15)];
//        }
        vipImgView.layer.cornerRadius=vipImgView.frame.size.width/ 2;
        vipImgView.layer.borderWidth = 1.0;
        vipImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        vipImgView.layer.masksToBounds = YES;
        [vipImgView setImage:[UIImage imageNamed:@"peoplevip@2x"]];
        [self addSubview:vipImgView];
    }
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
