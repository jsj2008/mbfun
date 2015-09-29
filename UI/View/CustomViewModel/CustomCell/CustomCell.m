//
//  CustomCell.m
//  One
//
//  Created by fafatime on 14-3-28.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize titleLabel;
@synthesize numberLabel;
@synthesize loginOutLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, -9, 150, 60)];
        titleLabel.backgroundColor=[UIColor clearColor];
    
        titleLabel.textColor=[UIColor blackColor];
        self.titleLabel=titleLabel;
        [self.contentView addSubview:self.titleLabel];
        numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, -9, 100,60 )];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.textColor=[UIColor blackColor];
        self.numberLabel = numberLabel;
        [self.contentView addSubview:self.numberLabel];//.contentView
        loginOutLabel =[[ UILabel alloc]initWithFrame:CGRectMake(5, -9, 300, 60)];
        loginOutLabel.backgroundColor=[UIColor clearColor];
        loginOutLabel.textColor=[UIColor redColor];
        [self.contentView addSubview:self.loginOutLabel];
        
        
        
    }
    return self;
}
-(void)dealloc
{
//    [numberLabel release];numberLabel=nil;
//    [titleLabel release],titleLabel=nil;
//    [loginOutLabel release],loginOutLabel=nil;
//    [super dealloc];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
