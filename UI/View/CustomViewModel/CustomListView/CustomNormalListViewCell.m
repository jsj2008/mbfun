//
//  CustomNormalListViewCell.m
//  Wefafa
//
//  Created by mac on 14-8-20.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CustomNormalListViewCell.h"

static const int Margin=3;

@implementation CustomNormalListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self innerInit];
}

-(void)innerInit
{
    int x=6, y=Margin;
    int height=self.frame.size.height-2*Margin;
    
    _imageHead = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, height, height)];
    [self.contentView addSubview:_imageHead];
    
    x+=_imageHead.frame.size.width+6;
    _lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(x, y, SCREEN_WIDTH-x-20, 22)];
    _lbTitle.backgroundColor=[UIColor clearColor];
    _lbTitle.font=[UIFont systemFontOfSize:16];
    _lbTitle.textColor=[UIColor blackColor];
    [self.contentView addSubview:_lbTitle];
    
    y+=_lbTitle.frame.size.height+Margin;
    _lbDetail = [[UILabel alloc]initWithFrame:CGRectMake(x, y, SCREEN_WIDTH-x-20, 12)];
    _lbDetail.backgroundColor=[UIColor clearColor];
    _lbDetail.font=[UIFont systemFontOfSize:12];
    _lbDetail.textColor=[UIColor grayColor];
    [self.contentView addSubview:_lbDetail];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
