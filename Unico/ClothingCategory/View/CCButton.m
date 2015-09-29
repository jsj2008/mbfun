//
//  CCButton.m
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CCButton.h"


@interface CCButton()
{
    UIImageView *_rightImageView;
    int _customState;
}

@end

@implementation CCButton

- (void)initSubviews
{
    _rightImageView = [[UIImageView alloc] init];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_rightImageView];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [self initSubviews];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        [self initSubviews];
        
        [self layoutSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _rightImageView.frame = CGRectMake(self.width-12, (self.height-12)/2.0, 12, 12);
}


@end

