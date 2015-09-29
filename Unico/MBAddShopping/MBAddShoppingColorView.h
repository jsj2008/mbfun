//
//  MBAddShoppingColorView.h
//  Wefafa
//
//  Created by Jiang on 5/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBAddShoppingColorCell.h"
@protocol MBAddShoppingColorViewDelegate <NSObject>
@required
/**
 *	@简要 已选颜色的cell
 *	@参数 cell : 选择的cell
 *	@参数 index : 选取位置
 *
 *  @返回 nil
 */
- (void)colorViewContentCollectionCell:(MBAddShoppingColorCell *)cell
              didSelectItemAtIndexPath:(NSInteger)index;

@end

typedef NSMutableArray* (^tempArray)(NSString *colorId);
@interface MBAddShoppingColorView : UICollectionView

@property (nonatomic, assign) id<MBAddShoppingColorViewDelegate> colorCollectionDelegate;
@property (nonatomic, strong) NSArray *contentModelArray;       //存放所有颜色
@property (nonatomic, strong) NSMutableArray *tempColorArray;   //临时存放颜色的数组
@property (nonatomic, assign) NSInteger selectedIndex;          //保存已选
@property (nonatomic, copy) tempArray temp;

@end
