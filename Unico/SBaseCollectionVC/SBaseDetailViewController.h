//
//  SBaseDetailViewController.h
//  Wefafa
//
//  Created by unico on 15/5/15.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBaseDetailViewController : SBaseViewController
{
    UICollectionReusableView *headContent;
}
@property (nonatomic) UICollectionView *collectionView;
// 当前的数据索引
@property (nonatomic, assign) NSInteger headerViewHeight;
// item列表数组
// 当前的数据索引
@property (nonatomic, assign) NSInteger lastPageIndex;
@property (nonatomic, strong) NSMutableArray *goodsList;


@property (nonatomic) BOOL isCalculateHeight;
-(void)getData;
-(void)layoutUI;
//-(void)loadData;
@end
