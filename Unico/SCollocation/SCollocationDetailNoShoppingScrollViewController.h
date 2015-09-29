//
//  SCollocationDetailNoShoppingScrollViewController.h
//  Wefafa
//
//  Created by chencheng on 15/7/17.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCollocationDetailNoneShopController.h"
#import "SBaseViewController.h"

@interface SCollocationDetailNoShoppingScrollViewController : UIViewController//SBaseViewController
{
    UIScrollView  *_scrollView;
    NSArray *_collocationIdArray;
    int     _currentcollocationIdIndex;
    
    SCollocationDetailNoneShopController *_detailNoShoppingViewController1;
    SCollocationDetailNoneShopController *_detailNoShoppingViewController2;
    SCollocationDetailNoneShopController *_detailNoShoppingViewController3;
}

@property(strong, readwrite, nonatomic) NSArray *collocationIdArray;
@property(assign, readwrite, nonatomic) int currentcollocationIdIndex;

@end
