//
//  SProductColorModel.m
//  Wefafa
//
//  Created by shenpu on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SProductColorModel.h"

@implementation SProductColorModel
- (void)setWaterFLayout:(WaterFLayout *)waterFLayout
{
    _waterFLayout = waterFLayout;
    
    [self layout];
}

- (void)setProductColorSize:(CGSize)productColorSize
{
    _productColorSize = productColorSize;
    
    [self layout];
}

- (void)setColorName:(NSString *)colorName
{
    _colorName = colorName;
    [self layout];
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected=isSelected;
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
    
    if (self.productColorSize.width > 0)
    {
        float k = self.productColorSize.height / self.productColorSize.width;
        _productColorRect = CGRectMake(0, 0, cellWidth, cellWidth*k);//图片宽高
        offsetY += _productColorRect.size.height;
    }
    
    float sizeK = UI_SCREEN_WIDTH/750.0;
//    _priceLabelRect = CGRectMake(1*sizeK, offsetY - 40 * sizeK, cellWidth-1*sizeK*2, 40 * sizeK);
    
//    offsetY += 10 * sizeK;
    _titleLabelRect = CGRectMake(0, offsetY, cellWidth, 30 * sizeK);
    offsetY += _titleLabelRect.size.height;
    
    //计算Cell的Size
    _cellSize = CGSizeMake(cellWidth, offsetY);
}

@end
