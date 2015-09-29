//
//  RewardCreateCompletion.m
//  Designer
//
//  Created by Jiang on 1/15/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "RewardDetailsHeaderView.h"

@implementation RewardDetailsHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RewardDetailsHeaderView" owner:nil options:nil];
        self = [array firstObject];
        CGRect rect = self.frame;
        rect.size.height = 344;
        self.frame = rect;
    }
    return self;
}

@end
