//
//  SItemListViewController.h
//  Wefafa
//
//  Created by unico on 15/5/19.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBaseDetailViewController.h"

@interface SItemListViewController : SBaseViewController
{
    UIView *headContentView;
}
@property (strong,nonatomic) NSArray *list;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign,nonatomic) float headerViewHeight;


@end
