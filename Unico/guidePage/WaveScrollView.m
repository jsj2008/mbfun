//
//  WaveScrollView.m
//  MCPagerView
//
//  Created by wave on 15/9/17.
//
//

#import "WaveScrollView.h"

//#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
//#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define BASETAG 1001

@implementation WaveScrollView
{
    CGRect _rect;
    
    UIView* _floatView;
    CGRect _tempRect;
}

-(void)layoutSubviews
{
    //--------PAGE ONE--------
    //1 弹幕
    _floatView = [self viewWithTag:0 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = (self.contentOffset.x - _rect.origin.x) * (1.03 - 1);
    _floatView.frame = _tempRect;
    
    //2 弹幕
    _floatView = [self viewWithTag:1 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = (self.contentOffset.x - _rect.origin.x) * (1.2 - 1);
    _floatView.frame = _tempRect;
    
    //2 字幕
    _floatView = [self viewWithTag:2 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = (self.contentOffset.x - _rect.origin.x) * (1.3 - 1);
    _floatView.frame = _tempRect;
    
    //3 字幕
     _floatView = [self viewWithTag:3 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = -self.contentOffset.x * 0.2;
    _floatView.frame = _tempRect;
    //渐隐效果
    CGFloat alpha = ABS(self.contentOffset.x - SCREEN_WIDTH) / SCREEN_WIDTH;
//    _floatView = [self viewWithTag:0 + BASETAG];
//    _floatView.alpha = alpha;
    _floatView = [self viewWithTag:1 + BASETAG];
    _floatView.alpha = alpha;
    _floatView = [self viewWithTag:2 + BASETAG];
    _floatView.alpha = alpha;
    _floatView = [self viewWithTag:3 + BASETAG];
    _floatView.alpha = alpha;
    
    //--------PAGE TWO--------  4 ~ 8
    _floatView = [self viewWithTag:4 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = 0;//(self.contentOffset.x - _rect.origin.x) * (1.03 - 1);
    _floatView.frame = _tempRect;
    
    _floatView = [self viewWithTag:5 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = -self.contentOffset.x;
    _floatView.frame = _tempRect;
    
    _floatView = [self viewWithTag:6 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = -self.contentOffset.x * 2;
    _floatView.frame = _tempRect;
    
    _floatView = [self viewWithTag:7 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = -self.contentOffset.x * 3;
    _floatView.frame = _tempRect;
    
    _floatView = [self viewWithTag:8 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = -self.contentOffset.x * 4;
    _floatView.frame = _tempRect;
    //渐隐效果
    alpha = ABS(self.contentOffset.x - SCREEN_WIDTH * 2) / SCREEN_WIDTH - ABS(self.contentOffset.x- SCREEN_WIDTH) / SCREEN_WIDTH;
    _floatView = [self viewWithTag:5 + BASETAG];
    _floatView.alpha = alpha;
    _floatView = [self viewWithTag:6 + BASETAG];
    _floatView.alpha = alpha;
    _floatView = [self viewWithTag:7 + BASETAG];
    _floatView.alpha = alpha;
    _floatView = [self viewWithTag:8 + BASETAG];
    _floatView.alpha = alpha;
    
    //--------PAGE THREE--------  9 ~ 13
    _floatView = [self viewWithTag:9 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = (self.contentOffset.x - _rect.origin.x) * 0;;
    _floatView.frame = _tempRect;
    
    _floatView = [self viewWithTag:10 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = -self.contentOffset.x;
    _floatView.frame = _tempRect;
    _floatView = [self viewWithTag:11 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = -self.contentOffset.x * 1.5;
    _floatView.frame = _tempRect;
    
    _floatView = [self viewWithTag:12 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = -self.contentOffset.x * 2;
    _floatView.frame = _tempRect;
    
    _floatView = [self viewWithTag:13 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = -self.contentOffset.x * 2.5;
    _floatView.frame = _tempRect;
    //渐隐效果
    alpha = ABS(self.contentOffset.x - SCREEN_WIDTH * 3) / SCREEN_WIDTH - ABS(self.contentOffset.x- SCREEN_WIDTH * 2) / SCREEN_WIDTH;
    NSLog(@"-self.contentOffset.x ==-== %f", -self.contentOffset.x);

    _floatView = [self viewWithTag:10 + BASETAG];
    _floatView.alpha = alpha;
    _floatView = [self viewWithTag:11 + BASETAG];
    _floatView.alpha = alpha;
    _floatView = [self viewWithTag:12 + BASETAG];
    _floatView.alpha = alpha;
    _floatView = [self viewWithTag:13 + BASETAG];
    _floatView.alpha = alpha;
    
    //--------PAGE THREE--------  14 ~ 17
    _floatView = [self viewWithTag:14 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = (self.contentOffset.x - _rect.origin.x) * 0;
    _floatView.frame = _tempRect;

    _floatView = [self viewWithTag:15 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = -self.contentOffset.x * 0.25;
    _floatView.frame = _tempRect;
//    _floatView = [self viewWithTag:15 + BASETAG];
//    _rect = [self convertRect:_floatView.frame toView:self];
//    _tempRect.origin.x = -self.contentOffset.x * 0.05;
//    _floatView.frame = _tempRect;
    
    _floatView = [self viewWithTag:16 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = -self.contentOffset.x * 1.5;
    _floatView.frame = _tempRect;
    
    _floatView = [self viewWithTag:17 + BASETAG];
    _rect = [self convertRect:_floatView.frame toView:self];
    _tempRect.origin.x = -self.contentOffset.x * 2.5;
    _floatView.frame = _tempRect;
}

@end
