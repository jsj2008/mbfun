//
//  LogisticsTableViewCell.m
//  Wefafa
//
//  Created by fafatime on 14-12-24.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "LogisticsTableViewCell.h"
#import "Utils.h"
@implementation LogisticsTableViewCell
- (void)awakeFromNib
{
    // Initialization code
    [_lineImgView setBackgroundColor:[UIColor blackColor]];
    _stateName.backgroundColor=[UIColor clearColor];
    _stateName.textAlignment=NSTextAlignmentLeft;
    _timeLabel.textAlignment=NSTextAlignmentLeft;
    _timeLabel.backgroundColor=[UIColor clearColor];
    
    _pointImgView.backgroundColor=[Utils HexColor:0x66cccc Alpha:1.0];
    _pointImgView.layer.cornerRadius=_pointImgView.frame.size.height/2;
    _lineImgView.backgroundColor=[Utils HexColor:0x66cccc Alpha:1.0];
    _topImgView.backgroundColor=[Utils HexColor:0x66cccc Alpha:1.0];
//    _pointImgView
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
