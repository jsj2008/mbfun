//
//  SCategorySubItemModel.m
//  Wefafa
//
//  Created by chencheng on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SCategorySubItemModel.h"

@implementation SCategorySubItemModel


- (void)setWaterFLayout:(WaterFLayout *)waterFLayout
{
    _waterFLayout = waterFLayout;
    
    [self layout];
}

- (void)setCategorySubItemImageRect:(CGRect)categorySubItemImageRect
{
    _categorySubItemImageRect = categorySubItemImageRect;
    
    [self layout];
}

- (void)setCategorySubItemImageSize:(CGSize)categorySubItemImageSize
{
    _categorySubItemImageSize = categorySubItemImageSize;
    
    [self layout];
}

- (void)setCategorySubItemName:(NSString *)categorySubItemName
{
    _categorySubItemName = categorySubItemName;
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
    float cellWidth = (self.collectionView.frame.size.width - ((_waterFLayout.sectionInset.left + _waterFLayout.sectionInset.right) + _waterFLayout.minimumColumnSpacing * (_waterFLayout.columnCount-1)))/(float)(_waterFLayout.columnCount);
    
    if (_categorySubItemImageURL == nil
        || [[_categorySubItemImageURL description] length] == 0)
    {
        _categorySubItemImageRect = CGRectMake(0, 0, cellWidth, 0);//图片宽高
    }
    else
    {
        if (self.categorySubItemImageSize.width > 0)
        {
            float k = self.categorySubItemImageSize.height / self.categorySubItemImageSize.width;
            _categorySubItemImageRect = CGRectMake(0, 0, cellWidth, cellWidth*k);//图片宽高
            offsetY += _categorySubItemImageRect.size.height;
        }
    }
    
    float sizeK = UI_SCREEN_WIDTH/750.0;
    
    offsetY += 10 * sizeK;
    _categorySubItemNameLabelRect = CGRectMake(0, offsetY, cellWidth, 42 * sizeK);
    offsetY += _categorySubItemNameLabelRect.size.height;
    
    //计算Cell的Size
    _cellSize = CGSizeMake(cellWidth, offsetY);
}


@end
