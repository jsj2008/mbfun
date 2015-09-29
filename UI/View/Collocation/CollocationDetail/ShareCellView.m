//
//  ShareCellView.m
//  Wefafa
//
//  Created by mac on 14-11-26.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "ShareCellView.h"

@implementation ShareCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)btnItemClicked:(id)sender {
    NSLog(@"-----btnItemClicked");
}
@end
