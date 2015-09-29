//
//  ReturnTableViewCell.m
//  Wefafa
//
//  Created by fafatime on 14-12-10.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "ReturnTableViewCell.h"

@implementation ReturnTableViewCell
@synthesize nameLabel;
@synthesize showDetailLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(17, 0, 60, 43)];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];
        showDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+60+17, 0, UI_SCREEN_WIDTH-60-20-17, 43)];
        showDetailLabel.backgroundColor=[UIColor clearColor];
        showDetailLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:showDetailLabel];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
