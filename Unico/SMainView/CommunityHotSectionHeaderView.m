//
//  CommunityHotSectionHeaderView.m
//  Wefafa
//
//  Created by wave on 15/8/18.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityHotSectionHeaderView.h"
#import "Utils.h"
#import "SUtilityTool.h"

@interface CommunityHotSectionHeaderView ()
@property (nonatomic) UILabel *label;
@end

@implementation CommunityHotSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //label
        if (!_label) {
            _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 0, 0)];
        }
        [_label setFont:FONT_T6];
        [_label setTextColor:COLOR_C2];
        //more
        UIImageView *imgView = [UIImageView new];
        [imgView setImage:[UIImage imageNamed:@"Unico/arrow_address.png"]];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        UILabel *label = [UILabel new];
        [label setText:@"更多"];
//        label setFont:<#(UIFont *)#>
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //黄色
    CGRect rectangle = CGRectMake(0, 12, 4, 16);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [[Utils HexColor:0xfedc32 Alpha:1] setFill];
    CGContextFillRect(contextRef, rectangle);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
