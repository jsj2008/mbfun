//
//  SDiscoverySelectedButton.m
//  Wefafa
//
//  Created by unico_0 on 6/20/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoverySelectedButton.h"

@implementation SDiscoverySelectedButton

- (void)awakeFromNib{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, contentRect.size.width - 5, contentRect.size.width, 20);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(10, 10, contentRect.size.width - 20, contentRect.size.width - 20);
}

@end
