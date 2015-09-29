//
//  ClothingCategoryCollectionViewCell.m
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "ClothingCategoryCollectionViewCell.h"
#import "UIImageView+WebCache.h"


@interface ClothingCategoryCollectionViewCell ()
{
    UIImageView *_clothingImageView;
    NSURL *_clothingImageURL;
    
    UIImageView *_tagImageView;
    NSURL *_tagImageURL;
    
    UIImageView *_promotionsImageView;
    
    UILabel *_clothingTitleLabel;
    UILabel *_originalPriceLabel;
    UILabel *_salesPriceLabel;
    
    float _originalPrice;
    UIView *_originalPriceDeleteLineView;
    float _salesPrice;

}

@end




@implementation ClothingCategoryCollectionViewCell


- (void)setClothingImageURL:(NSURL *)clothingImageURL
{
    if (clothingImageURL == nil || [clothingImageURL isKindOfClass:[NSNull class]]
        || [[clothingImageURL description] length] == 0)
    {
        _clothingImageURL = nil;
    }
    else
    {
        _clothingImageURL = clothingImageURL;
        
        [_clothingImageView sd_setImageWithURL:clothingImageURL isLoadThumbnail:NO];
    }
}

- (void)setTagImageURL:(NSURL *)tagImageURL
{
    if (tagImageURL == nil || [tagImageURL isKindOfClass:[NSNull class]]
        || [[tagImageURL description] length] == 0)
    {
        _tagImageURL = nil;
    }
    else
    {
        _tagImageURL = tagImageURL;
        [_tagImageView sd_setImageWithURL:_tagImageURL isLoadThumbnail:NO];
    }
}


- (void)setClothingTitle:(NSString *)clothingTitle
{
    _clothingTitleLabel.text = clothingTitle;
}

- (NSString *)clothingTitle
{
    return _clothingTitleLabel.text;
}

- (void)setOriginalPrice:(float)originalPrice
{
    _originalPrice = originalPrice;
    
    _originalPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f", _originalPrice];
}

- (void)setSalesPrice:(float)salesPrice
{
    _salesPrice = salesPrice;
    
    _salesPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f", _salesPrice];
}



//布局方面的属性
- (void)setClothingImageRect:(CGRect)clothingImageRect
{
    _clothingImageView.frame = clothingImageRect;
}

- (CGRect)clothingImageRect
{
    return _clothingImageView.frame;
}


- (void)setTitleFont:(UIFont *)titleFont
{
    _clothingTitleLabel.font = titleFont;
}

- (UIFont *)titleFont
{
    return _clothingTitleLabel.font;
}

- (void)setTitleRect:(CGRect)titleRect
{
    _clothingTitleLabel.frame = titleRect;
}

- (CGRect)titleRect
{
    return _clothingTitleLabel.frame;
}

- (void)setSalesPriceFont:(UIFont *)salesPriceFont
{
    _salesPriceLabel.font = salesPriceFont;
}

- (UIFont *)salesPriceFont
{
    return _salesPriceLabel.font;
}

- (void)setSalesPriceRect:(CGRect)salesPriceRect
{
    _salesPriceLabel.frame = salesPriceRect;
}

- (void)setOriginalPriceFont:(UIFont *)originalPriceFont
{
    _originalPriceLabel.font = originalPriceFont;
}

- (UIFont *)originalPriceFont
{
    return _originalPriceLabel.font;
}

- (void)setOriginalPriceRect:(CGRect)originalPriceRect
{
    _originalPriceLabel.frame = originalPriceRect;
    
    _originalPriceDeleteLineView.frame = CGRectMake(-2, _originalPriceLabel.bounds.size.height/2.0, _originalPriceDeleteLineView.frame.size.width, 1);
}

- (CGRect)originalPriceRect
{
    return _originalPriceLabel.frame;
}

- (void)setOriginalPriceDeleteLineWidth:(float)originalPriceDeleteLineWidth
{
    _originalPriceDeleteLineView.frame = CGRectMake(_originalPriceDeleteLineView.frame.origin.x, _originalPriceDeleteLineView.frame.origin.y, originalPriceDeleteLineWidth, _originalPriceDeleteLineView.size.height);
}

- (CGRect)salesPriceRect
{
    return _salesPriceLabel.frame;
}

- (void)initSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    _clothingImageView = [[UIImageView alloc] init];
    [self addSubview:_clothingImageView];
    
    _tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 12)];
    [self addSubview:_tagImageView];
    
    _promotionsImageView = [[UIImageView alloc] init];
    [self addSubview:_promotionsImageView];
    
    
    _clothingTitleLabel = [[UILabel alloc] init];
    _clothingTitleLabel.textColor = [UIColor colorWithRed:0xbb/255.0 green:0xbb/255.0 blue:0xbb/255.0 alpha:1];
    [self addSubview:_clothingTitleLabel];
    
    _originalPriceLabel = [[UILabel alloc] init];
    _originalPriceLabel.textColor = [UIColor colorWithRed:0xbb/255.0 green:0xbb/255.0 blue:0xbb/255.0 alpha:1];
    [self addSubview:_originalPriceLabel];
    
    _originalPriceDeleteLineView = [[UIView alloc] init];
    _originalPriceDeleteLineView.backgroundColor = [UIColor colorWithRed:0xbb/255.0 green:0xbb/255.0 blue:0xbb/255.0 alpha:1];
    [_originalPriceLabel addSubview:_originalPriceDeleteLineView];
    
    _salesPriceLabel = [[UILabel alloc] init];
    [self addSubview:_salesPriceLabel];
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

