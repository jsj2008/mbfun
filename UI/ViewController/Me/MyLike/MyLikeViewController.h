//
//  MyLikeViewController.h
//  Wefafa
//
//  Created by fafatime on 14-9-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBCustomClassifyModelView.h"
#import "MBTabsView.h"
#import "ImageWaterView.h"
#import "SVPullToRefresh.h"
@class GoodsListCollectionView;
@interface MyLikeViewController : SBaseViewController/*UIViewController*/<MBCustomClassifyModelViewDelegate,UIScrollViewDelegate>
{
    MBTabsView *customClassifyModelV;
    NSMutableArray* collocationList;
    NSMutableArray* goodsList;

}

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *viewCenter;
@property (strong, nonatomic) UITableView *brandTableView;//品牌
@property (strong, nonatomic) NSString *use_Id;
@property (assign, nonatomic) BOOL isMy;


- (IBAction)btnBackClick:(id)sender;
@end
