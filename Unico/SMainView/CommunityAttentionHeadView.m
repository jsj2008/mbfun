
//
//  CommunityAttentionHeadView.m
//  Wefafa
//
//  Created by wave on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityAttentionHeadView.h"
#import "SUtilityTool.h"
#import "MBOtherUserInfoModel.h"

@interface CommunityAttentionHeadView ()
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *imgView;
//@property (nonatomic, assign) Arrowstate state;
@end

@implementation CommunityAttentionHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _label = [UILabel new];
        [self addSubview:_label];
        [_label setFont:FONT_t5];
        [_label setTextColor:COLOR_C2];
        [_label setText:@"为你推荐的达人"];
        [_label sizeToFit];
        [_label setTextAlignment:NSTextAlignmentLeft];
        [_label setLeft:10];
        [_label setCenterY:self.height / 2];
        _imgView = [UIImageView new];
        [self addSubview:_imgView];
//        [_imgView setImage:[UIImage imageNamed:@"Unico/xiaosanjiao.png"]];
        [_imgView setImage:[UIImage imageNamed:@"Unico/arrow_bottom.png"]];
        [_imgView sizeToFit];
        [_imgView setHeight:frame.size.height];
        [_imgView setRight:UI_SCREEN_WIDTH - 10];
        [_imgView setContentMode:UIViewContentModeScaleAspectFit];
        [_imgView setCenterY:self.height / 2];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(_imgView.left - 10, 0, UI_SCREEN_WIDTH - _imgView.left + 10, frame.size.height);
        btn.backgroundColor = [UIColor clearColor];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
        //默认有推荐达人
        _imgView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        _arrowState = arrowDOWN;
    }
    return self;
}

- (void)click {
    _arrowState = !_arrowState;
    CGFloat haha = _arrowState ? M_PI : 0;
    [self rotateArrow:haha];
    
    self.insertBlock(_arrowState);
}

- (void)rotateArrow:(CGFloat)roate {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.imgView.layer.transform = CATransform3DMakeRotation(roate, 0, 0, 1);
    } completion:NULL];
}

- (void)layoutSubviews {
    [_imgView setRight:UI_SCREEN_WIDTH - 10];
    [_imgView setCenterY:self.height / 2];

    [_label setLeft:10];
    [_label setCenterY:self.height / 2];
}

@end
