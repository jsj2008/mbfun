//
//  CommunityHotHeadView.m
//  Wefafa
//
//  Created by wave on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityHotHeadView.h"
#import "Utils.h"
#import "SUtilityTool.h"

@interface CommunityHotHeadView ()
@property (nonatomic) UILabel *label;
@property (nonatomic, strong) UILabel *labelMore;
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation CommunityHotHeadView

- (void)setTitle:(NSString *)title {
    [_label setText:title];
    [_label sizeToFit];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _label = [UILabel new];
        [_label setFont:FONT_T6];
        [_label setTextColor:COLOR_C2];
        [self addSubview:_label];
        //more
        _labelMore = [UILabel new];
        [_labelMore setText:@"更多"];
        [_labelMore setTextColor:COLOR_C6];
        [_labelMore setFont:FONT_t7];
        [_labelMore sizeToFit];
        _labelMore.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        [_labelMore addGestureRecognizer:tap];
        
        
        _imgView = [UIImageView new];
        [_imgView setImage:[UIImage imageNamed:@"Unico/arrow_address.png"]];
        [_imgView sizeToFit];
        
        [self addSubview:_labelMore];
        [self addSubview:_imgView];
        //线条
        CALayer *layer = [CALayer layer];
        layer.zPosition = 5;
        layer.frame = CGRectMake(0, self.height - .5f, UI_SCREEN_WIDTH, 0.5f);
        layer.backgroundColor = [Utils HexColor:0xd9d9d9 Alpha:1].CGColor;
        [self.layer addSublayer:layer];
        
    }
    return self;
}

- (void)click {
    
    self.block(_section);
}

- (void)drawRect:(CGRect)rect {
    //黄色矩形
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGRect rectangle = CGRectMake(0, 12, 4, 15);
    [[Utils HexColor:0xfedc32 Alpha:1] setFill];
    CGContextFillRect(contextRef, rectangle);
}

- (void)layoutSubviews {
    [_label setLeft:10];
    [_label setCenterY:self.height/2];
    
    [_imgView setRight:UI_SCREEN_WIDTH - 10];
    [_imgView setCenterY:self.height/2];
    
    [_labelMore setRight:_imgView.left - 5];
    [_labelMore setCenterY:self.height/2];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
