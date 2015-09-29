//
//  SProductModel.m
//  Wefafa
//
//  Created by chencheng on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SProductModel.h"

@implementation SProductModel


- (void)setWaterFLayout:(WaterFLayout *)waterFLayout
{
    _waterFLayout = waterFLayout;
    
    [self layout];
}

- (void)setProductImageSize:(CGSize)productImageSize
{
    _productImageSize = productImageSize;
    
    [self layout];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
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
    
    if (_productImageURL == nil
        || [[_productImageURL description] length] == 0)
    {
        _productImageRect = CGRectMake(0, 0, cellWidth, 0);//图片宽高
    }
    else
    {
        if (self.productImageSize.width > 0)
        {
            float k = self.productImageSize.height / self.productImageSize.width;
            _productImageRect = CGRectMake(0, 0, cellWidth, cellWidth*k);//图片宽高
            offsetY += _productImageRect.size.height;
        }
    }
    
    float sizeK = UI_SCREEN_WIDTH/750.0;
    _priceLabelRect = CGRectMake(1*sizeK, offsetY - 40 * sizeK, cellWidth-1*sizeK*2, 40 * sizeK);
    
    offsetY += 10 * sizeK;
    _titleLabelRect = CGRectMake(0, offsetY, cellWidth, 30 * sizeK);
    offsetY += _titleLabelRect.size.height;
    
    //计算Cell的Size
    _cellSize = CGSizeMake(cellWidth, offsetY);
}


@end
