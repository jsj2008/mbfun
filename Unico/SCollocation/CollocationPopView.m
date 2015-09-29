//
//  CollocationPopView.m
//  Wefafa
//
//  Created by wave on 15/7/3.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CollocationPopView.h"
#import "SUtilityTool.h"
@implementation CollocationPopView
{
    BOOL _isRemove;
    UIView *homePopView;
    
}
int _btnHeight = 40;
int _btnWidth= 75;//105
-(instancetype)initCollocationPopView:(CGRect)frame withIsMy:(BOOL)isMy
{
    if (self=[super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        CGRect rect = frame;
        rect.size.width=_btnWidth;
//        rect.size.height=2*_btnHeight;
        rect.size.height+=5;
        
        self.backgroundColor=[UIColor clearColor];
        self.layer.anchorPoint=CGPointMake(0.8, 0);
        self.frame=rect;
        
        homePopView =[[UIView alloc]initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
        
        [self addSubview:homePopView];
        NSArray *ary;
        NSArray *aryImg;
        if (isMy) {
            ary= @[ @"分享", @"删除"];
            aryImg = @[ @"Unico/icon_navigation_share",@"Unico/icon_navigation_report"];// @"collocationdelete"];
        }
        else
        {
            ary= @[ @"分享", @"举报"];
            aryImg = @[ @"Unico/icon_navigation_share",@"Unico/icon_navigation_report"];// @"collocationdelete"];
        }

        for (NSString *str in ary) {
 
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, (int)[ary indexOfObject:str] * _btnHeight + 5, _btnWidth, _btnHeight);
            btn.tag = [ary indexOfObject:str] + 170;
            [btn setImage:[UIImage imageNamed:aryImg[(int)[ary indexOfObject:str]]] forState:UIControlStateNormal];
            int k = (int)[ary indexOfObject:str];
            NSLog(@"k--------%d",k);
            
            if ((int)[ary indexOfObject:str]==1) {
//                  CGFloat top, left, bottom, right;
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0,12, 0, 0)];
                  [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 18 , 0, 0)];
            }else
            {
                 [btn setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 9, btn.width - 30)];
                  [btn setTitleEdgeInsets:UIEdgeInsetsMake(8, 18 , 0, 0)];
            }
          /*
           if ((int)[ary indexOfObject:str]==1) {
           //                  CGFloat top, left, bottom, right;
           [btn setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
           [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 10 , 0, 0)];
           }else
           {
           [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0,0, 0)];
           [btn setTitleEdgeInsets:UIEdgeInsetsMake(10, 10 , 0, 0)];
           }
           */
          //+ 15
//            btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn setTitle:str forState:UIControlStateNormal];
            [btn setTitleColor:[Utils HexColor:0X999999 Alpha:1] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment=NSTextAlignmentCenter;
            btn.titleLabel.font = FONT_t6;
            
            [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
            self.layer.cornerRadius=3.0;
            self.layer.masksToBounds=YES;
            
            [self addSubview:btn];
        
        }
        
    }
    return self;
}
- (void)showPop {
    if (!self) {
        return;
    }
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.alpha = 0;
    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidePop {
    if (!self || _isRemove) {
        return;
    }
    _isRemove = YES;
    self.transform = CGAffineTransformMakeScale(1, 1);
    self.alpha = 1;
    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)clicked:(UIButton *)sender
{
    [self hidePop];
    if ([self.delegate respondsToSelector:@selector(collocationPopViewSelected:)]) {
        [self.delegate collocationPopViewSelected:sender.tag-170];
    }
}
- (void)drawRect:(CGRect)rect {
    CGContextRef contentRef = UIGraphicsGetCurrentContext();
    CGContextBeginPath(contentRef);//标记
    CGContextMoveToPoint(contentRef, 0, 5);
    CGContextAddLineToPoint(contentRef, self.width - 20, 5);
    CGContextAddLineToPoint(contentRef, self.width - 15, 0);
    CGContextAddLineToPoint(contentRef, self.width - 10, 5);
    CGContextAddLineToPoint(contentRef, self.width, 5);
    CGContextAddLineToPoint(contentRef, self.width, self.height + 5);
    CGContextAddLineToPoint(contentRef, 0, self.height + 5);
    CGContextAddLineToPoint(contentRef, 0, 5);
    [[Utils HexColor:0x000000 Alpha:.8] setFill];
    [[Utils HexColor:0x000000 Alpha:.8] setStroke];
    CGContextClosePath(contentRef);
    CGContextDrawPath(contentRef, kCGPathFillStroke);
}
@end