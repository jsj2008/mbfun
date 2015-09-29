//
//  RoundHeadImageView.m
//  Wefafa
//
//  Created by fafa  on 13-7-11.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "RoundHeadImageView.h"
#import "QuartzCore/QuartzCore.h"
#import "Utils.h"
@implementation RoundHeadImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self innerInit];
}
-(void)innerInit
{
    _isShowRoundHead=YES;
    _cornerRadius = 3.0;
    _needShadow=NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    if (!_isShowRoundHead) return;
    CALayer *sublayer = [self layer];
    sublayer.masksToBounds = YES;
    if (_needShadow)
    {
        sublayer.shadowOffset = CGSizeMake(0, 2);
        sublayer.shadowRadius =3.0;
        sublayer.shadowOpacity = 0.7;
    }
    sublayer.cornerRadius = _cornerRadius;
//    self.layer.borderColor = [Utils HexColor:0xc7c7c7 Alpha:1.0].CGColor;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth =1.0;
}

@end
