//
//  LeftSubTitleButton.m
//  Wefafa
//
//  Created by Jiang on 4/21/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "LeftSubTitleButton.h"
#import "Utils.h"

@interface LeftSubTitleButton ()

@end

@implementation LeftSubTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.subLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 30, 25)];
    self.subLabel.textAlignment = NSTextAlignmentLeft;
    self.subLabel.textColor = [Utils HexColor:0x919191 Alpha:1];
    self.subLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:_subLabel];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(32, 5, 50, 25);
}

- (void)setLeftSubTitle:(NSString *)leftSubTitle{
    _leftSubTitle = [leftSubTitle copy];
    CGRect rect = self.subLabel.frame;
    rect.size = [_leftSubTitle sizeWithFont:[UIFont systemFontOfSize:12]];
    self.subLabel.text = leftSubTitle;
}

@end
