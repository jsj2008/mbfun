//
//  BinDingSubContentView.m
//  Wefafa
//
//  Created by Jiang on 2/12/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "BinDingSubContentView.h"

@implementation BinDingSubContentView

- (void)awakeFromNib{
    self.originFrame = self.frame;
    _originFrame.size.width = UI_SCREEN_WIDTH;
}

@end
