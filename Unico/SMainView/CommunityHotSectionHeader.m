//
//  CommunityHotSectionHeader.m
//  Wefafa
//
//  Created by wave on 15/8/18.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityHotSectionHeader.h"
#import "Utils.h"
#import "SUtilityTool.h"

@interface CommunityHotSectionHeader ()
@property (nonatomic) UILabel *label;
@end

@implementation CommunityHotSectionHeader

//model赋值 _label
- (void)setTitle:(NSString *)title {
    [_label setText:title];
    [_label sizeToFit];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _label = [UILabel new];
        [_label setFont:FONT_T6];
        [_label setTextColor:COLOR_C2];
        //more
        UILabel *label = [UILabel new];
        [label setText:@"更多"];
        [label setTextColor:COLOR_C6];
        [label setFont:FONT_t7];
        UIImageView *imgView = [UIImageView new];
        [imgView setImage:[UIImage imageNamed:@"Unico/arrow_address.png"]];
        [imgView sizeToFit];
        [imgView setRight:UI_SCREEN_WIDTH - 10];
        [label setRight:imgView.left + 5];
        //线条
        CALayer *layer = [CALayer layer];
        layer.zPosition = 5;
        layer.frame = CGRectMake(0, self.height - .5f, UI_SCREEN_WIDTH, 0.5f);
        layer.backgroundColor = [Utils HexColor:0xd9d9d9 Alpha:1].CGColor;
        [self.layer addSublayer:layer];
    }
    return self;
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
    [_label setCenterY:self.centerY];
}

@end
