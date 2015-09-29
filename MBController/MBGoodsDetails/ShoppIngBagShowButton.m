//
//  ShoppIngBagShowButton.m
//  Wefafa
//
//  Created by Jiang on 5/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "ShoppIngBagShowButton.h"
#import "WeFaFaGet.h"
#import "SUtilityTool.h"

@interface ShoppIngBagShowButton ()
{
    CGFloat _labelWidth;
}
@end

@implementation ShoppIngBagShowButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:9];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.layer.cornerRadius = 7;
        self.titleLabel.layer.masksToBounds = YES;
        self.titleLabel.backgroundColor = COLOR_C12;
        self.titleLabel.hidden = YES;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rect = CGRectMake(contentRect.size.width - _labelWidth - 1, self.contentEdgeInsets.top + 1, _labelWidth, 14);
    return rect;
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    if ([self isPureInt:title]){
        if (title.intValue > 99) title = @"99+";
    }
    _labelWidth = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:9]}].width;
    if (_labelWidth <= 9){
        _labelWidth = 14;
    }else{
        _labelWidth += 4;
    }
    [super setTitle:title forState:state];
    if (sns.isLogin) {
        self.titleLabel.hidden = NO;
    }else{
        self.titleLabel.hidden = YES;
    }
    if (title.length==0||[title isEqualToString:@""]) {
        self.titleLabel.hidden = YES;
    }
}

- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end
