//
//  NoneHeightLightButton.m
//  Wefafa
//
//  Created by Jiang on 3/17/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "NoneHeightLightButton.h"
#import "Utils.h"

@implementation NoneHeightLightButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.backImgView];
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
        self.textLabel.textAlignment=NSTextAlignmentCenter;
        self.textLabel.textColor=[UIColor blackColor];
        self.textLabel.backgroundColor=[UIColor clearColor];
        self.textLabel.font=[UIFont systemFontOfSize:15.0f];
        
        [self addSubview:self.textLabel];
        self.rightLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-0.5,self.frame.origin.y,0.5, self.frame.size.height)];
        [self.rightLineImgView setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
        self.rightLineImgView.hidden=YES;
        [self addSubview:self.rightLineImgView];
    }
    return self;
}
- (void)setSelected:(BOOL)isSelect
{
    if (isSelect) {
        self.backImgView.backgroundColor=[Utils HexColor:0xe2e2e2 Alpha:1];
    }
    else
    {
       self.backImgView.backgroundColor=[UIColor whiteColor];
    }
    
}
- (void)setHighlighted:(BOOL)highlighted{
    [super setHidden:NO];
}

@end
