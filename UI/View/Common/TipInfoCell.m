//
//  TipInfoCell.m
//  Wefafa
//
//  Created by mac on 13-10-29.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "TipInfoCell.h"
#import "Utils.h"

@implementation TipInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTipInfo:(NSString *)str
{
    if (lbTipInfo == nil) {
        lbTipInfo = [[UILabel alloc] init];
        [self.contentView addSubview:lbTipInfo];
    }
    lbTipInfo.frame = self.contentView.frame;
    lbTipInfo.textAlignment=NSTextAlignmentCenter;
    lbTipInfo.font=[UIFont systemFontOfSize:14.0];
    lbTipInfo.backgroundColor = TITLE_BG;
    lbTipInfo.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    lbTipInfo.shadowColor=[UIColor whiteColor];
    lbTipInfo.shadowOffset=CGSizeMake(1,1);
    [lbTipInfo setText:str];
}

-(void)setPicIshidden:(BOOL)picIshidden
{
    if (_noMessageImage == nil) {
        _noMessageImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_noMessageImage];
        
    }
    _noMessageImage.frame = CGRectMake(60, 24, 18, 16);
    _noMessageImage.image = [UIImage imageNamed:@"bubbles4.png"];
    _noMessageImage.hidden = picIshidden;
    
}

@end
