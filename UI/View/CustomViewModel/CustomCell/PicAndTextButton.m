//
//  PicAndTextButton.m
//  Wefafa
//
//  Created by fafatime on 14-11-30.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "PicAndTextButton.h"

@implementation PicAndTextButton
@synthesize itemImageV;
@synthesize nameLabel;
@synthesize selectImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        itemImageV = [[UIUrlImageView alloc] initWithFrame:CGRectMake(0,18, 18, 15)];//25
        itemImageV.backgroundColor=[UIColor clearColor];
        self.itemImageV = itemImageV;
        [self addSubview:self.itemImageV];
        
        
        selectImageView = [[UIUrlImageView alloc]initWithFrame:itemImageV.frame];
        selectImageView.backgroundColor=[UIColor clearColor];
        self.selectImageView=selectImageView;
        selectImageView.hidden=YES;
        [self addSubview:self.selectImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemImageV.frame.size.width+5,0,self.frame.size.width-itemImageV.frame.size.width,self.frame.size.height)];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.textColor = [UIColor blackColor];
        [nameLabel setFont:[UIFont systemFontOfSize:16.0]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.nameLabel];

        nameLabel.textAlignment=NSTextAlignmentLeft;

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
