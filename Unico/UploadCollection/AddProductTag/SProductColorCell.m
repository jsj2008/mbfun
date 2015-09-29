//
//  SProductColorCell.m
//  Wefafa
//
//  Created by shenpu on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SProductColorCell.h"
#import "SUtilityTool.h"

@interface SProductColorCell()
{
    UIImageView  *_productImageView;
    UIImageView *_isSelectedView;
    
    NSURL *_productImageURL;
    
    UILabel     *_titleLabel;
}

@end

@implementation SProductColorCell


- (void)setProductColorURL:(NSURL *)productColorURL
{
    if (productColorURL == nil || [productColorURL isKindOfClass:[NSNull class]]
        || [[productColorURL description] length] == 0)
    {
        _productImageURL = nil;
    }
    else
    {
        _productImageURL = productColorURL;
        
        [_productImageView sd_setImageWithURL:_productImageURL isLoadThumbnail:NO];
    }
}

- (void)setColorValue:(NSString *)colorValue
{
    NSScanner* scanner = [NSScanner scannerWithString: colorValue];
    
    unsigned long long longValue;
    [scanner scanHexLongLong: &longValue];
    
    _productImageView.backgroundColor = UIColorFromRGB(longValue);
}

- (void)setColorName:(NSString *)colorName
{
    _titleLabel.text = colorName;
}

- (NSString *)colorName
{
    return _titleLabel.text;
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected=isSelected;
    if (_isSelected)
    {
        _isSelectedView.hidden=NO;
        
    }
    else
    {
        _isSelectedView.hidden=YES;
    }
}


//布局方面的属性
- (void)setProductColorRect:(CGRect)productColorRect
{
    _productImageView.frame = productColorRect;
    float sizeK=UI_SCREEN_WIDTH/750.0;
    _productImageView.frame=CGRectMake(productColorRect.origin.x+10*sizeK, 10*sizeK, productColorRect.size.width-20*sizeK, productColorRect.size.height-20*sizeK);
    _productImageView.layer.cornerRadius=(productColorRect.size.width-20*sizeK)/2;
    _isSelectedView.frame=CGRectMake(self.bounds.size.width-40*sizeK,0, 40*sizeK, 40*sizeK);
}

- (CGRect)productImageRect
{
    return _productImageView.frame;
}

- (void)setTitleLabelRect:(CGRect)titleLabelRect
{
    _titleLabel.frame = titleLabelRect;
}

- (CGRect)titleLabelRect
{
    return _titleLabel.frame;
}

- (void)initSubviews
{
    float sizeK = UI_SCREEN_WIDTH/750.0;
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 0;
    self.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = COLOR_C9.CGColor;
    self.layer.borderWidth = 1 * sizeK;
    
    _productImageView = [[UIImageView alloc] init];
    [self addSubview:_productImageView];
    
    _productImageView.layer.borderColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1].CGColor;
    _productImageView.layer.borderWidth = 1 * sizeK;
    _productImageView.backgroundColor=[UIColor orangeColor];
    _productImageView.layer.cornerRadius=60*sizeK;
    _productImageView.layer.masksToBounds=YES;
    

    _isSelectedView = [[UIImageView alloc] init];
    _isSelectedView.image=[UIImage imageNamed:@"Unico/ico_itemcheck"];
    _isSelectedView.layer.cornerRadius=15*sizeK;
    _isSelectedView.layer.masksToBounds=YES;
    
    [self addSubview:_isSelectedView];
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = FONT_t7;
    _titleLabel.textColor = COLOR_C6;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
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
