//
//  LineTextField.m
//  Wefafa
//
//  Created by Jiang on 2/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "LineTextField.h"

@implementation LineTextField

- (void)awakeFromNib{
    CGFloat line_Width = self.frame.size.width;
    CGFloat line_Y = self.frame.size.height - 1;
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    lineLayer.frame = CGRectMake(0, line_Y, line_Width, 1);
    [self.layer addSublayer:lineLayer];
    
    self.returnKeyType = UIReturnKeyDone;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

@end
