//
//  SCategorySubItemCell.m
//  Wefafa
//
//  Created by chencheng on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SCategorySubItemCell.h"
#import "SUtilityTool.h"

@interface SCategorySubItemCell()
{
    UIImageView  *_categorySubItemImageView;
    
    NSURL *_categorySubItemImageURL;

    UILabel     *_categorySubItemNameLabel;
}

@end

@implementation SCategorySubItemCell

- (void)setCategorySubItemImageURL:(NSURL *)categorySubItemImageURL
{
    if (categorySubItemImageURL == nil || [categorySubItemImageURL isKindOfClass:[NSNull class]]
        || [[categorySubItemImageURL description] length] == 0)
    {
        _categorySubItemImageURL = nil;
    }
    else
    {
        _categorySubItemImageURL = categorySubItemImageURL;
        [_categorySubItemImageView sd_setImageWithURL:_categorySubItemImageURL isLoadThumbnail:NO];
    }
}

- (void)setCategorySubItemName:(NSString *)categorySubItemName
{
    _categorySubItemNameLabel.text = categorySubItemName;
}

- (NSString *)categorySubItemName
{
    return _categorySubItemNameLabel.text;
}

//布局方面的属性
- (void)setCategorySubItemImageRect:(CGRect)categorySubItemImageRect
{
    _categorySubItemImageView.frame = categorySubItemImageRect;
    //自适应宽高
    _categorySubItemImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (CGRect)categorySubItemImageRect
{
    return _categorySubItemImageView.frame;
}

- (void)setCategorySubItemNameLabelRect:(CGRect)categorySubItemNameLabelRect
{
    _categorySubItemNameLabel.frame = categorySubItemNameLabelRect;
}

- (CGRect)categorySubItemNameLabelRect
{
    return _categorySubItemNameLabel.frame;
}


- (void)initSubviews
{
    /*self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 0;
    self.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = COLOR_C9.CGColor;
    self.layer.borderWidth = 1 * sizeK;*/
    
    _categorySubItemImageView = [[UIImageView alloc] init];
    [self addSubview:_categorySubItemImageView];
    

    _categorySubItemNameLabel = [[UILabel alloc] init];
    _categorySubItemNameLabel.font = FONT_t6;
    _categorySubItemNameLabel.textColor = COLOR_C2;
    _categorySubItemNameLabel.textAlignment = NSTextAlignmentCenter;
    _categorySubItemNameLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_categorySubItemNameLabel];
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
    }
    
    return self;
}


@end












