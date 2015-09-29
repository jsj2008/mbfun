//
//  UMButton.m
//  newdesigner
//
//  Created by Miaoz on 14/10/24.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "UMButton.h"
#import "UIColor+extend.h"
#import <QuartzCore/QuartzCore.h>
@implementation UMButton



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //给按钮加一个白色的板框
    if (self.layer.borderWidth != 0.5f) {
        self.layer.borderColor = [[UIColor colorWithHexString:@"#919191"] CGColor];
        self.layer.borderWidth = 0.5f;
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
//        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];

    }

    //给按钮设置弧度,这里将按钮变成了圆形
    self.layer.cornerRadius = 3.0f;
    self.layer.masksToBounds = YES;
//     self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
   
    [self addImageView];

}
-(void)addImageView{
    if (_rightImageView == nil) {
        UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_more@3x"]];
        rightImageView.frame = CGRectMake(self.bounds.size.width-20.0f, (self.bounds.size.height-15.0f)/2.0, 10.0f, 15.0f);
        _rightImageView = rightImageView;
        rightImageView.hidden = YES;
//        rightImageView.transform =CGAffineTransformMakeRotation(M_PI);
        [self addSubview:rightImageView];
    }
    
    
    if (_centerImageView == nil) {
        UIImageView *centerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        centerImageView.layer.masksToBounds = YES;
//        centerImageView.layer.cornerRadius = 6.0;
        centerImageView.layer.borderWidth = 1.0;
        centerImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        centerImageView.frame = CGRectMake(self.bounds.size.width/2.0f+20, (self.bounds.size.height-15.0f)/2.0, 15.0f, 15.0f);
        centerImageView.backgroundColor = [UIColor clearColor];
        _centerImageView = centerImageView;
        centerImageView.hidden = YES;
        [self addSubview:centerImageView];
        

    }
}

-(void)dealloc
{
    [_centerImageView removeFromSuperview];
    [_rightImageView removeFromSuperview];
    _centerImageView = nil;
    _rightImageView = nil;

}
@end
