//
//  VerticalAlignTextView.m
//  StoryCam
//
//  Created by Ryan on 15/4/2.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import "VerticalAlignTextView.h"

@implementation VerticalAlignTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setContentSize:(CGSize)size
{
    UITextView* textView = self;
    float height = textView.bounds.size.height;
    float contentHeight = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)].height;

    CGFloat topCorrect = 0.0;

    switch (self.verticalAlignment) {
    case VerticalAlignmentTop:
        textView.contentOffset = CGPointZero; //set content offset to top
        break;
    case VerticalAlignmentMiddle:
        // 这里修改下，让他偏上，正中应该是.5
        topCorrect = (height - contentHeight * textView.zoomScale) * 0.4;
        topCorrect = topCorrect < 0 ? 0 : topCorrect;
        textView.contentOffset = CGPointMake(0, -topCorrect);
        break;
    case VerticalAlignmentBottom:
        topCorrect = textView.bounds.size.height - contentHeight;
        topCorrect = topCorrect < 0 ? 0 : topCorrect;
        textView.contentOffset = CGPointMake(0, -topCorrect);
        break;
    default:
        break;
    }
    if (contentHeight >= height) { //if the contentSize is greater than the height
        topCorrect = contentHeight - height; //set the contentOffset to be the
        topCorrect = topCorrect < 0 ? 0 : topCorrect; //contentHeight - height of textView
        textView.contentOffset = CGPointMake(0, topCorrect);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [self contentSize];
    [self setContentSize:size];
}
@end
