//
//  CustomListTableViewCell.m
//  One
//
//  Created by fafatime on 14-3-30.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CustomListTableViewCell.h"

@implementation CustomListTableViewCell
@synthesize headImgView;
@synthesize titleLabel;
@synthesize timeLabel;
//@synthesize detailLabel;
@synthesize detailTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 8,70, 50)];
        self.headImgView = headImgView;
        [self.contentView addSubview:self.headImgView];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(58+20, 0, UI_SCREEN_WIDTH-58-20, 30)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:16];
        titleLabel.textColor=[UIColor blackColor];
        self.titleLabel = titleLabel;
        [self.contentView addSubview:self.titleLabel];
  
        
//        detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(58, 30, 260, 86-30)];
//        detailLabel.backgroundColor=[UIColor clearColor];
//        detailLabel.textColor=[UIColor blackColor];
//        self.detailLabel=detailLabel;
        detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(58+20, 20, UI_SCREEN_WIDTH-58-20, ListTabViewCellWidth-32)];
        detailTextView.userInteractionEnabled=NO;
        detailTextView.backgroundColor=[UIColor clearColor];
        detailTextView.font=[UIFont systemFontOfSize:12];
        detailTextView.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153.0/255.0 alpha:1];
        self.detailTextView=detailTextView;
        [self.contentView addSubview:self.detailTextView];
        
//        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-150, detailTextView.frame.size.height+detailTextView.frame.origin.y, 150, 30)];
//        
//        timeLabel.backgroundColor=[UIColor clearColor];
//        timeLabel.textColor=[UIColor blackColor];
//        timeLabel.font=[UIFont systemFontOfSize:13];
//        
//        self.titleLabel = titleLabel;
//        [self.contentView addSubview:self.timeLabel];
        
    }
    return self;
}
-(void)dealloc
{
//    [headImgView release],headImgView=nil;
//    [titleLabel release],titleLabel=nil;
//    [timeLabel release],timeLabel=nil;
////    [detailLabel release],detailLabel=nil;
//    
//    
//    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
