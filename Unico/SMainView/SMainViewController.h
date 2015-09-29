//
//  SMainViewController.h
//  Wefafa
//
//  Created by unico on 15/5/16.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBaseViewController.h"
@class CommunityCollectionView;
@class CommunityKeyBoardAccessoryView;
@class SMDataModel, SMenuBottomModel, ShoppIngBagShowButton;
@class CommunityAttentionTableView;

//用户保存首页数据  最后tableview偏移量  最后的索引
@interface CollocationModel : NSObject
@property(nonatomic,strong)NSMutableArray *list;
@property(nonatomic)NSInteger lastPageIndex;
@property(nonatomic)NSInteger lastOffset;
@end

@interface SMainViewController : SBaseViewController

@property (nonatomic) CommunityCollectionView *collectionView;      //搭配
@property (nonatomic) CommunityAttentionTableView *attentionTbView; //关注
/**
 *  社区-关注 回复键盘
 */
@property (nonatomic, strong) CommunityKeyBoardAccessoryView *IFView;
@property (nonatomic, strong) SMenuBottomModel *layoutModel;

- (void)callKeyBoardwithModel:(SMDataModel*)model integer:(NSInteger)integer;
- (void)hideKeyBoard;

+ (SMainViewController*)instance;
- (void)scrollToTop;

@end