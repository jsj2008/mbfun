//
//  STopImageBottomTitleButton.m
//  Wefafa
//
//  Created by unico_0 on 7/31/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "STopImageBottomTitleButton.h"

@implementation STopImageBottomTitleButton

- (void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rect = CGRectMake(0, contentRect.size.height * 0.7, contentRect.size.width, contentRect.size.height * 0.2);
    return rect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rect = CGRectMake(0, contentRect.size.height * 0.2, contentRect.size.width, contentRect.size.height * 0.4);
    return rect;
}

@end
