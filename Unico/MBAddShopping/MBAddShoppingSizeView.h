//
//  MBAddShoppingSizeView.h
//  Wefafa
//
//  Created by Jiang on 5/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBAddShoppingSizeCell.h"
@protocol MBAddShoppingSizeViewDelegate <NSObject>
@required
/**
 *	@简要 已选尺寸的cell
 *	@参数 cell : 选择的cell
 *	@参数 index : 选取位置
 *
 *  @返回 nil
 */
- (void)sizeViewContentCollectionCell:(MBAddShoppingSizeCell*)cell
         didSelectItemAtIndexPath:(NSInteger)index;

@end

@interface MBAddShoppingSizeView : UICollectionView

@property (nonatomic, assign) id<MBAddShoppingSizeViewDelegate> sizeCollectionDelegate;
@property (nonatomic, strong) NSArray *contentModelArray;       //存放所有尺寸
@property (nonatomic, strong) NSMutableArray *tempSizeArray;    //临时存放尺寸的数组
@property (nonatomic, assign) NSInteger selectedIndex;          //保存已选

@end
