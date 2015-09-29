//
//  CommunityHotHeaderView.m
//  Wefafa
//
//  Created by wave on 15/8/20.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityHotHeaderView.h"
#import "Utils.h"
#import "SUtilityTool.h"

@interface CommunityHotHeaderView ()
@property (nonatomic) UILabel *label;
@property (nonatomic, strong) UILabel *labelMore;
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation CommunityHotHeaderView

//model赋值 _label
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
        [self.contentView addSubview:_label];
        //more
        _labelMore = [UILabel new];
        [_labelMore setText:@"更多"];
        [_labelMore setTextColor:COLOR_C6];
        [_labelMore setFont:FONT_t7];
        [_labelMore sizeToFit];

        _imgView = [UIImageView new];
        [_imgView setImage:[UIImage imageNamed:@"Unico/arrow_address.png"]];
        [_imgView sizeToFit];

        [self.contentView addSubview:_labelMore];
        [self.contentView addSubview:_imgView];
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
    
    [_imgView setRight:UI_SCREEN_WIDTH - 10];
    [_imgView setCenterY:self.centerY];
    
    [_labelMore setRight:_imgView.left - 5];
    [_labelMore setCenterY:self.centerY];
//    self.backgroundView = [[UIImageView alloc] initWithImage:[self imageWithColor:[UIColor whiteColor] size:self.bounds.size alpha:1]];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size alpha:(float)alpha {
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetAlpha(context, alpha);
        CGContextSetFillColorWithColor(context,color.CGColor);
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
}

@end
