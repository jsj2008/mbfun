//
//  DetailEarnTableViewCell.m
//  Wefafa
//
//  Created by fafatime on 14-9-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "DetailEarnTableViewCell.h"

@implementation DetailEarnTableViewCell
@synthesize inLabel,detailWhere,inMoneyLabel,timeLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        inLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50, 25)];
        [inLabel setBackgroundColor:[UIColor clearColor]];
        inLabel.text=@"收入:";
        self.inLabel = inLabel;
        [self.contentView addSubview:inLabel];
        inMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 0, 70, 25)];
        [inMoneyLabel setBackgroundColor:[UIColor clearColor]];
        self.inMoneyLabel =inMoneyLabel;
        [self.contentView addSubview:self.inMoneyLabel];
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-200, 0, 200, 25)];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        self.timeLabel =timeLabel;
        [self.contentView addSubview:self.timeLabel];
        UILabel *wherelabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 25, 70, 25)];
        [wherelabel setBackgroundColor:[UIColor clearColor]];
        wherelabel.text=@"来源于:";
        [self.contentView addSubview:wherelabel];
        detailWhere=[[UILabel alloc]initWithFrame:CGRectMake(80, 25, 100, 25)];
        [detailWhere setBackgroundColor:[UIColor clearColor]];
        self.detailWhere=detailWhere;
        [self.contentView addSubview:detailWhere];
        
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
