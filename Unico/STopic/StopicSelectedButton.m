//
//  StopicSelectedButton.m
//  Wefafa
//
//  Created by unico_0 on 6/2/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "StopicSelectedButton.h"
#import "SUtilityTool.h"

@implementation StopicSelectedButton

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
    _subLabel.textColor = [self titleColorForState:self.state];
    _subLabel.font = FONT_t7;
    _subLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_subLabel];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    contentRect = self.bounds;
    CGRect frame = contentRect;
    
    contentRect.origin.y = 25.0/ 110.0 * contentRect.size.height;
    contentRect.size.height = 15.0;
    
    frame.origin.y = CGRectGetMaxY(contentRect) + 5;
    frame.size.height = 10.0;
    _subLabel.frame = frame;
    
    return contentRect;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        _subLabel.textColor = [self titleColorForState:UIControlStateSelected];
    }else{
        _subLabel.textColor = [self titleColorForState:UIControlStateNormal];
    }
}

- (void)setHighlighted:(BOOL)highlighted{
    
}

@end
