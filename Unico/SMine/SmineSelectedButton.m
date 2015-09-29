//
//  SmineSelectedButton.m
//  Wefafa
//
//  Created by unico_0 on 6/4/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SmineSelectedButton.h"
#import "SUtilityTool.h"

@implementation SmineSelectedButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    _subLabel = [[UILabel alloc]init];
    _subLabel.textColor = COLOR_C6;
    _subLabel.font = FONT_t4;
    _subLabel.text = @"0";
    _subLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_subLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    contentRect = self.bounds;
    CGRect frame = contentRect;
    
    contentRect.origin.y = 17.0/ 110.0 * contentRect.size.height;
    contentRect.size.height = 14.0;
    
    frame.origin.y = CGRectGetMaxY(contentRect)+2;
    frame.size.height = 10.0;
    _subLabel.frame = contentRect;
    return frame;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (selected) {
        _subLabel.textColor = COLOR_C2;
    }else{
        _subLabel.textColor = COLOR_C6;
    }
}

- (void)setHighlighted:(BOOL)highlighted{
    
}

@end
