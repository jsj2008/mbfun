//
//  GoodsSizeCollectionView.h
//  Wefafa
//
//  Created by Jiang on 15/8/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsSizeCollectionCell.h"

@protocol GoodsSizeSelectionCollectionViewDelegate <NSObject>

- (void)didClickedGoodsSizeCollectionViewWithcell:(GoodsSizeCollectionCell *)cell index:(NSInteger)index;

@end

@interface GoodsSizeSelectionCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *sizeArrM;
@property (nonatomic, assign) CGFloat sizeViewH;
@property (nonatomic, weak) id<GoodsSizeSelectionCollectionViewDelegate> clickedDelegate;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSMutableArray *tempArrM;

@property (nonatomic, strong) NSMutableArray *containsArrM;    // 用数组记录cell灰色的index

@end
