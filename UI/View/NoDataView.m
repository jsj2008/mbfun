//
//  NoDataView.m
//  Wefafa
//
//  Created by fafatime on 14-12-7.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView
@synthesize noDataImgView;
@synthesize titleLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/4)];
        self.titleLabel.backgroundColor=[UIColor clearColor];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.hidden=NO;
        self.titleLabel.text=@"没有相关数据";
        [self addSubview:self.titleLabel];
        self.noDataImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.noDataImgView.hidden=YES;
        self.noDataImgView.image=[UIImage imageNamed:@"shoppingNil.png"];
        self.noDataImgView.backgroundColor=[UIColor clearColor];
        [self addSubview:self.noDataImgView];
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
