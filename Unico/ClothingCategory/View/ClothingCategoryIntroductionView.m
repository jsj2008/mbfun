//
//  ClothingCategoryIntroductionView.m
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "ClothingCategoryIntroductionView.h"
#import "UIImageView+WebCache.h"


@interface ClothingCategoryIntroductionView ()
{
    UIImageView  *_introductionImageView;
    NSURL        *_introductionImageURL;
    
    UILabel      *_introductionLabel;
}

@end



@implementation ClothingCategoryIntroductionView

- (void)setIntroductionImageURL:(NSURL *)introductionImageURL
{
    if (introductionImageURL == nil || [introductionImageURL isKindOfClass:[NSNull class]]
        || [[introductionImageURL description] length] == 0)
    {
        _introductionImageURL = nil;
    }
    else
    {
        _introductionImageURL = introductionImageURL;
        [_introductionImageView sd_setImageWithURL:_introductionImageURL isLoadThumbnail:NO];
    }
}


- (void)setIntroductionText:(NSString *)introductionText
{
    _introductionLabel.text = introductionText;
    
    [self layoutSubviews];
}

- (NSString *)introductionText
{
    return _introductionLabel.text;
}

- (void)initSubviews
{
    self.layer.masksToBounds = YES;
    
    _introductionImageView = [[UIImageView alloc] init];
    _introductionImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_introductionImageView];
    
    _introductionLabel = [[UILabel alloc] init];
    _introductionLabel.numberOfLines = 0;
    _introductionLabel.textColor = [UIColor colorWithRed:0xbb/255.0 green:0xbb/255.0 blue:0xbb/255.0 alpha:1];
    _introductionLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_introductionLabel];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [self initSubviews];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        [self initSubviews];
        [self layoutSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float offsetY = 0;
    float k = UI_SCREEN_WIDTH/750.0; //UI尺寸调整系数
    
    if (_introductionImageURL != nil)
    {
        _introductionImageView.frame = CGRectMake(0, offsetY, self.width, 344 * k);
        offsetY += _introductionImageView.height;
    }
    
    if (_introductionLabel.text != nil && [_introductionLabel.text length] > 0)
    {
        CGRect labelRect = [_introductionLabel.text boundingRectWithSize:CGSizeMake(self.width - 30*k*2, 1024*100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _introductionLabel.font} context:nil];
        
        _introductionLabel.frame = CGRectMake(30 * k, offsetY, self.width - 30*k*2, labelRect.size.height+20);
        offsetY += _introductionLabel.frame.size.height;
    }
    else
    {
        _introductionLabel.frame = CGRectMake(30 * k, offsetY, self.width - 30*k*2, 0);
        offsetY += 15;
    }
    
    [super setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, offsetY)];//调整自己的宽高
    
    [self.superview layoutSubviews];//父视图根据变化的子视图的宽高再做相应的调整。
}



@end

