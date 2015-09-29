//
//  SelectedSubButton.m
//  Wefafa
//
//  Created by Jiang on 4/15/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SelectedSubButton.h"
#import "Utils.h"

@interface SelectedSubButton ()

@property (nonatomic, strong) UILabel *subLabel;

@end

@implementation SelectedSubButton

- (void)awakeFromNib{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.subLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.frame.size.width, 17)];
    [self.subLabel setTextAlignment:NSTextAlignmentCenter];
    self.subLabel.textColor = [Utils HexColor:0x333333 Alpha:1];
    self.subLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:self.subLabel];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, self.frame.size.height/2, self.frame.size.width, 17);
}

- (void)setSubTitle:(NSString *)subTitle{
    _subTitle = [subTitle copy];
    self.subLabel.text = _subTitle;
}

@end
