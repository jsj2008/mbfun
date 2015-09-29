//
//  CustomeShowTableViewCell.m
//  Wefafa
//
//  Created by fafatime on 14-9-17.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CustomeShowTableViewCell.h"

@implementation CustomeShowTableViewCell
@synthesize headImgView;
@synthesize nameLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9, 25, 25)];
        [self.contentView addSubview:headImgView];
        
        nameLabel =[[UILabel alloc]
                         initWithFrame:CGRectMake(65, 15, UI_SCREEN_WIDTH-100, 21)];
        [nameLabel setTextColor:[UIColor blackColor]];
       // [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1]
//        nameLabel.font=[UIFont systemFontOfSize:14.0f];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:nameLabel];
      
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
