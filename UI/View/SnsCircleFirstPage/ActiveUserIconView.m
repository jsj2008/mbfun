//
//  ActiveUserIconView.m
//  Wefafa
//
//  Created by mac on 13-10-11.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "ActiveUserIconView.h"
#import "Utils.h"
#import "RoundHeadImageView.h"

@implementation ActiveUserIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self configView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)configView
{
    self.backgroundColor = VIEW_BACKCOLOR2;
    
//    imgHeadBackground = [[UIImageView alloc] init];
//    imgHeadBackground.image = [UIImage imageNamed:@"头像底图.png"];
//    imgHeadBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self addSubview:imgHeadBackground];
    
    _imageView = [[RoundHeadImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _imageView.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];//@"default_head_image.png"
    [self addSubview:_imageView];
    
    _label = [[UILabel alloc] init];
    _label.textColor = [UIColor darkGrayColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font=[UIFont systemFontOfSize:12.0];
    _label.backgroundColor = [UIColor clearColor];
    _label.numberOfLines = 1;
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //        _label.lineBreakMode = UILineBreakModeCharacterWrap;
    
    [self addSubview:_label];
}
- (void)layoutSubviews {
    int w=self.frame.size.width;
    int h=self.frame.size.height;
    
    int imgwidth=38,imgheight=38;
    int imgx=(w-imgwidth)/2;
    imgHeadBackground.frame=CGRectMake(imgx, 2, imgwidth, imgheight);
    _imageView.frame = CGRectInset(imgHeadBackground.frame, 1, 1);
    int y=imgHeadBackground.frame.origin.y+imgHeadBackground.frame.size.height+1;
    _label.frame = CGRectMake(0, y, w, h-y);
}

@end
