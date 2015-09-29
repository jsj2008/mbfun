//
//  MyCircleGridCell.m
//  Wefafa
//
//  Created by mac on 13-10-9.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "MyCircleGridCell.h"
#import "RoundHeadImageView.h"

@implementation MyCircleGridCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        UIView *background = [[UIView alloc] init];
//        background.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1.000 alpha:1.000];
//        self.selectedBackgroundView = background;
        
        _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MYCIRCLE_GRID_WIDTH, MYCIRCLE_GRID_HEIGHT)];
        
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MYCIRCLE_GRID_WIDTH, MYCIRCLE_GRID_HEIGHT)];
        _backgroundImage.image = [[UIImage imageNamed:@"circle_list_bg.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        [_backView addSubview:_backgroundImage];
        
        _userNumImage = [[UIImageView alloc] init];
        _userNumImage.image = [UIImage imageNamed:@"public_icon_person.png"];
        [_backView addSubview:_userNumImage];
        
//        imgHeadBackground = [[UIImageView alloc] init];
//        imgHeadBackground.image = [UIImage imageNamed:@"头像底图.png"];
//        [_backView addSubview:imgHeadBackground];
        
        _headImage = [[RoundHeadImageView alloc] init];
        _headImage.contentMode = UIViewContentModeScaleAspectFit;
        [_backView addSubview:_headImage];
        
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font=[UIFont systemFontOfSize:14.0];
        _label.backgroundColor = [UIColor clearColor];
        _label.numberOfLines = 1;
        //        _label.lineBreakMode = UILineBreakModeCharacterWrap;
        [_backView addSubview:_label];
        
        
        _labelNum = [[UILabel alloc] init];
        _labelNum.textColor = [UIColor darkGrayColor];
        _labelNum.textAlignment =NSTextAlignmentLeft;
        _labelNum.font=[UIFont systemFontOfSize:12.0];
        _labelNum.backgroundColor = [UIColor clearColor];
        _labelNum.numberOfLines = 1;
        //        _label.lineBreakMode = UILineBreakModeCharacterWrap;
        [_backView addSubview:_labelNum];
        
        [self.contentView addSubview:_backView];
    }
    return self;
}

- (void)layoutSubviews
{
    [self setViewsFrame];
    if(_isHideLabelNum)
    {
        //居中
        _label.frame=CGRectMake(_label.frame.origin.x,_label.frame.origin.y+11,_label.frame.size.width,_label.frame.size.height);
        _labelNum.hidden=YES;
        _userNumImage.hidden=YES;
    }
    else
    {
        _labelNum.hidden=NO;
        _userNumImage.hidden=NO;
    }
}

-(void)setViewsFrame
{
    int s1=10;
    imgHeadBackground.frame=CGRectMake(s1,s1,40,40);
    _headImage.frame = CGRectMake(s1+1,s1+1,40-2,40-2);
    int x1=_headImage.frame.origin.x+_headImage.frame.size.width+6;
    _label.frame = CGRectMake(x1, s1+3, MYCIRCLE_GRID_WIDTH-x1-6, 14);
    _userNumImage.frame=CGRectMake(x1-2, _label.frame.origin.y+18, 20, 20);
    _labelNum.frame = CGRectMake(x1+18, _label.frame.origin.y+21, 50, 14);
}

-(void)setIsHideLabelNum:(BOOL)isHide
{
    _isHideLabelNum=isHide;
}

@end
