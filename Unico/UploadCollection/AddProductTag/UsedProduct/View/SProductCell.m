//
//  SProductCell.m
//  Wefafa
//
//  Created by chencheng on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SProductCell.h"
#import "SUtilityTool.h"

@interface SProductCell()
{
    UIImageView  *_productImageView;
    
    NSURL *_productImageURL;
    
    UILabel      *_pricelabel;
    UIView       *_priceBgView;
    float _price;
    
    UILabel     *_titleLabel;
}

@end

@implementation SProductCell



- (void)setProductImageURL:(NSURL *)productImageURL
{
    if (productImageURL == nil || [productImageURL isKindOfClass:[NSNull class]]
        || [[productImageURL description] length] == 0)
    {
        _productImageURL = nil;
    }
    else
    {
        _productImageURL = productImageURL;
        
        [_productImageView sd_setImageWithURL:_productImageURL isLoadThumbnail:NO];
    }
}

- (UIImage *)productImage
{
    NSLog(@"_productImageView.image = %@", _productImageView.image);
    return _productImageView.image;
}

- (void)setPrice:(float)price
{
    _price = price;
    
    NSMutableString *priceMutableString = [NSMutableString stringWithFormat:@"￥%0.2f", _price];
    
    int len = (int)[priceMutableString length];
    
    unichar ch;
    [priceMutableString getCharacters:&ch range:NSMakeRange(len-1, 1)];
    
    if (ch == '0')
    {
        [priceMutableString deleteCharactersInRange:NSMakeRange(len-1, 1)];
        
        len = (int)[priceMutableString length];
        [priceMutableString getCharacters:&ch range:NSMakeRange(len-1, 1)];
        
        if (ch == '0')
        {
            [priceMutableString deleteCharactersInRange:NSMakeRange(len-1, 1)];
            [priceMutableString deleteCharactersInRange:NSMakeRange(len-2, 1)];
        }
    }
    _pricelabel.text = priceMutableString;
    _priceBgView.hidden=NO;
    if (price==-1) {
        _pricelabel.text=@"";
        _priceBgView.hidden=YES;
        
    }
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (NSString *)title
{
    return _titleLabel.text;
}

//布局方面的属性
- (void)setProductImageRect:(CGRect)productImageRect
{
    _productImageView.frame = productImageRect;
}

- (CGRect)productImageRect
{
    return _productImageView.frame;
}

- (void)setPriceLabelRect:(CGRect)priceLabelRect
{
    _pricelabel.frame = priceLabelRect;
    _priceBgView.frame = priceLabelRect;
}

- (CGRect)priceLabelRect
{
    return _pricelabel.frame;
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
    
    _pricelabel = [[UILabel alloc] init];
    _pricelabel.font = FONT_T6;
    _pricelabel.textColor = [UIColor whiteColor];
    _pricelabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_pricelabel];
    
    
    _priceBgView = [[UIView alloc] init];
    _priceBgView.backgroundColor = [UIColor blackColor];
    _priceBgView.alpha = 0.4;
    [self insertSubview:_priceBgView belowSubview:_pricelabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = FONT_t7;
    _titleLabel.textColor = COLOR_C2;
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
