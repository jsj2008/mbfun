//
//  MBContentSrollView.m
//  Wefafa
//
//  Created by Jiang on 4/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBContentSrollView.h"

@implementation MBContentSrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.subViewArray = [NSMutableArray array];
    }
    return self;
}

@end
