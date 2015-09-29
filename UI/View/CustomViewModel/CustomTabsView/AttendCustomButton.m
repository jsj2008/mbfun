//
//  AttendCustomButton.m
//  Wefafa
//
//  Created by fafatime on 14-8-5.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "AttendCustomButton.h"
#import "Utils.h"

@implementation AttendCustomButton
@synthesize titleLabel;
@synthesize clickImgView;
@synthesize itemImage;
@synthesize actionView;
@synthesize rightLineImgView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.itemImage];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.textColor=[UIColor blackColor];
        self.titleLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.clickImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-3,self.frame.size.width, 3)];
        self.clickImgView.hidden=YES;
        [self addSubview:self.clickImgView];
  
        self.rightLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-1,self.frame.size.height/2-7.5, 1, 15)];
        [self.rightLineImgView setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
        self.rightLineImgView.hidden=YES;
        [self addSubview:self.rightLineImgView];
        
        
   

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
