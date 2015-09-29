//
//  ClothingCategoryViewModel.m
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "ClothingCategoryViewModel.h"

@implementation ClothingCategoryViewModel


@end


@interface CollectionViewCellModel()
{
    //数据属性
    NSURL *_clothingImageURL;
    CGSize _clothingImageSize;
    NSString *_clothingTitle;
    float _originalPrice;
    float _salesPrice;
    BOOL _promotions;
    
    //布局属性 （布局属性放在Model，可以避免代码冗余）
    CGRect _clothingImageRect;
    UIFont *_titleFont;
    CGRect _titleRect;
    
    UIFont *_salesPriceFont;
    CGRect _salesPriceRect;
    CGSize _cellSize;
    
    UIFont *_originalPriceFont;
    float _originalPriceDeleteLineWidth;
}

@end


@implementation CollectionViewCellModel

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _titleFont = [UIFont systemFontOfSize:15];//默认字体
        _salesPriceFont = [UIFont systemFontOfSize:15];//默认字体
        _originalPriceFont = [UIFont systemFontOfSize:13];//默认字体
    }
    return self;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    
    [self layout];
}

- (void)setSalesPriceFont:(UIFont *)salesPriceFont
{
    _salesPriceFont = salesPriceFont;
    
    [self layout];
}

- (void)setOriginalPriceFont:(UIFont *)originalPriceFont
{
    _originalPriceFont = originalPriceFont;
    
    [self layout];
}

- (void)setClothingImageSize:(CGSize)clothingImageSize
{
    _clothingImageSize = clothingImageSize;
    
    [self layout];
}

- (void)setClothingTitle:(NSString *)clothingTitle
{
    _clothingTitle = clothingTitle;
    
    [self layout];
}

- (void)setSalesPrice:(float)salesPrice
{
    _salesPrice = salesPrice;
    
    [self layout];
}

- (void)setOriginalPrice:(float)originalPrice
{
    _originalPrice = originalPrice;
    
    [self layout];
}


- (void)layout
{
    if (_waterFLayout == nil)
    {
        return;
    }
    
    float offsetY = 0;
    
    //计算图片的Rect
    float cellWidth = (UI_SCREEN_WIDTH - ((_waterFLayout.sectionInset.left + _waterFLayout.sectionInset.right) + _waterFLayout.minimumColumnSpacing * (_waterFLayout.columnCount-1)))/(float)(_waterFLayout.columnCount);
    
    if (_clothingImageURL == nil
        || [[_clothingImageURL description] length] == 0)
    {
        _clothingImageRect = CGRectMake(0, 0, cellWidth, 0);//图片宽高
    }
    else
    {
        if (self.clothingImageSize.width > 0)
        {
            float k = self.clothingImageSize.height / self.clothingImageSize.width;
            _clothingImageRect = CGRectMake(0, 0, cellWidth, cellWidth*k);//图片宽高
            offsetY += self.clothingImageRect.size.height;
        }
    }
    
    //计算标题的Rect
    float k = UI_SCREEN_WIDTH/750.0;
    
    CGRect titleRect = [self.clothingTitle boundingRectWithSize:CGSizeMake(cellWidth - 30*k*2, 1024*100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleFont} context:nil];
    _titleRect = CGRectMake(30*k, offsetY, titleRect.size.width, titleRect.size.height);
    offsetY += self.titleRect.size.height;
    
    
    //计算售价的Rect
    NSString *salesPriceString = [NSString stringWithFormat:@"￥%0.2f", self.salesPrice] ;
    CGSize salesPriceLabelSize = [salesPriceString sizeWithAttributes:@{NSFontAttributeName : self.salesPriceFont}];
    
    _salesPriceRect = CGRectMake(30*k, offsetY, salesPriceLabelSize.width, 30);
    offsetY += self.salesPriceRect.size.height;
    
    
    //计算原价的Rect
    _originalPriceRect = CGRectMake(_salesPriceRect.origin.x + _salesPriceRect.size.width + 10, _salesPriceRect.origin.y, cellWidth-(_salesPriceRect.origin.x + _salesPriceRect.size.width + 10), 30);
    
    //计算删除线的长度
    NSString *originalString = [NSString stringWithFormat:@"￥%0.2f", self.originalPrice] ;
    CGSize originalStringSize = [originalString sizeWithAttributes:@{NSFontAttributeName : self.originalPriceFont}];
    
    _originalPriceDeleteLineWidth = originalStringSize.width + 4;
    
    //计算Cell的Size
    _cellSize = CGSizeMake(cellWidth, offsetY);
}

@end