//
//  SProductListReturnTopControl.m
//  Wefafa
//
//  Created by PHM on 9/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SProductListReturnTopControl.h"

@implementation SProductListReturnTopControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        [self initSubviews];
    }
    return self;
}

//设置隐藏动画效果
-(void)setHidden:(BOOL)hidden{
    if (hidden) {
        [super setHidden:hidden];
        self.alpha = 0;
    }
    
    [UIView animateWithDuration:1 animations:^{
        if (!hidden) {
            self.alpha = 1;
        }
    } completion:^(BOOL finished) {
       [super setHidden:hidden];
    }];
}

#pragma mark - 设置ReturnTopButton的UI
#pragma mark 初始化ReturnTopButton
- (void)initSubviews
{
    self.backgroundColor = [UIColor clearColor];
    _returnTopImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/to_top.png"]];
    _returnTopImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_returnTopImageView];
    
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_returnTopImageView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.f
                                                         constant:0.f],
                           [NSLayoutConstraint constraintWithItem:_returnTopImageView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:0.f],
                           [NSLayoutConstraint constraintWithItem:_returnTopImageView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.f
                                                         constant:0.f],
                           [NSLayoutConstraint constraintWithItem:_returnTopImageView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.f
                                                         constant:0.f]
                           ]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

//单击图标 返回顶端
-(void)tapClick:(UITapGestureRecognizer *)tapGestureRecognizer{
    if ([_delegate respondsToSelector:@selector(returnTopControlClick)]) {
        [_delegate returnTopControlClick];
    }
}




@end
