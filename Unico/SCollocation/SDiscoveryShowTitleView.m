//
//  SDiscoveryShowTitleView.m
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryShowTitleView.h"
#import "SUtilityTool.h"

@implementation SDiscoveryShowTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.titleString = title;
    }
    return self;
}

- (void)initSubViews{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *decorateView = [[UIView alloc]initWithFrame:CGRectMake(0, 13, 3, 14)];
    decorateView.backgroundColor = COLOR_C2;
    [self addSubview:decorateView];
    _decorateView = decorateView;
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, UI_SCREEN_WIDTH - 20, 39.5)];
    _titleLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel.font = FONT_T4;
    _titleLabel.textColor = COLOR_C2;
    [self addSubview:_titleLabel];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 70, 0, 60, 39.5)];
    [button addTarget:self action:@selector(touchMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    button.contentHorizontalAlignment = UIViewContentModeRight;
    button.titleLabel.font = FONT_t7;
    [button setTitle:@"更多" forState:UIControlStateNormal];
    [button setTitleColor:COLOR_C6 forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"Unico/right_arrow"] forState:UIControlStateNormal];
    [self addSubview:button];
    _moreButton = button;
    
    _subTitleLabel = [[UILabel alloc]initWithFrame:button.frame];
    _subTitleLabel .font = FONT_t7;
    _subTitleLabel.textColor = COLOR_C6;
    _subTitleLabel.textAlignment = NSTextAlignmentRight;
    _subTitleLabel.hidden = YES;
    [self addSubview:_subTitleLabel];
}

- (void)touchMoreButton:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(showTitleTouchMoreButton:)]) {
        [self.delegate showTitleTouchMoreButton:sender];
    }
}

- (void)setTitleString:(NSString *)titleString{
    _titleString = [titleString copy];
    _titleLabel.text = titleString;
}

- (void)setIsHiddenLine:(BOOL)isHiddenLine{
    _isHiddenLine = isHiddenLine;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    if (_isHiddenLine) return;
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context,
                        kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,
                          1.0/ [UIScreen mainScreen].scale);
    //设置颜色
    CGContextSetStrokeColorWithColor(context, COLOR_C9.CGColor);
    //    cgcontextset
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context,
                         0, self.bounds.size.height);
    //下一点
    CGContextAddLineToPoint(context,
                            self.bounds.size.width, self.bounds.size.height);
    //绘制完成
    CGContextStrokePath(context);
}

@end
