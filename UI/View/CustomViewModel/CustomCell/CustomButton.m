//
//  CustomButton.m
//  Wefafa
//
//  Created by fafatime on 14-5-20.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
@synthesize itemImageV;
@synthesize nameLabel;
@synthesize selectImageView;


- (id)initWithFrame:(CGRect)frame withLineUp:(BOOL)Up
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization cod
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height-1);
        
        itemImageV = [[UIUrlImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-30)/2.0, 5, 30, 30)];
        itemImageV.backgroundColor=[UIColor clearColor];
        self.itemImageV = itemImageV;
        [self addSubview:self.itemImageV];
        selectImageView = [[UIUrlImageView alloc]initWithFrame:itemImageV.frame];
        selectImageView.backgroundColor=[UIColor clearColor];
        self.selectImageView=selectImageView;
        [self addSubview:self.selectImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-15,self.frame.size.width, 15)];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.textColor = [UIColor whiteColor];
        [nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        self.nameLabel = nameLabel;
        [self addSubview:self.nameLabel];
        self.clickImgView = [[UIUrlImageView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width, 2)];
    
        if (Up)
        {
            
        }
        else
        {
            [itemImageV  setFrame:CGRectMake((self.frame.size.width-30)/2.0, 6, 30, 30)];
            [selectImageView setFrame:itemImageV.frame];
            [nameLabel setFrame:CGRectMake(0,36,self.frame.size.width, 15)];
            nameLabel.textAlignment=NSTextAlignmentCenter;
            [self.clickImgView setFrame:CGRectMake(0, self.frame.size.height-2, self.frame.size.width, 2)];
        }
    
        self.clickImgView.hidden=YES;
        [self addSubview:self.clickImgView];
        
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
