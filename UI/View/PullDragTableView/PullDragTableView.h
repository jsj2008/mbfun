//
//  PullDragTableView.h
//  Wefafa
//
//  Created by mac on 14-8-13.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "CommonEventHandler.h"

//
//  CollocationTableView.h
//  Wefafa
//
//  Created by mac on 14-8-13.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//
//@protocol PullDragTableViewDelegate <NSObject>
//
//-(void)reloadTableData:(id)sender;
//-(void)loadMoreTableData:(id)sender;
//
//@end

@interface PullDragTableView : UITableView<EGORefreshTableHeaderDelegate,EGORefreshTableFooterDelegate,UIScrollViewDelegate>
{
    NSMutableArray* _dataArray;
    
    // 加载状态
    EGORefreshTableHeaderView *headViewRefresh;
    BOOL isLoadData;
    
    EGORefreshTableFooterView *footViewRefresh;
    BOOL reloading;
    
}
//@property(assign,nonatomic) id<PullDragTableViewDelegate> pull_delegate;

@property(nonatomic,readonly,retain) CommonEventHandler *onLoadNewMessage; //下拉
@property(nonatomic,readonly,retain) CommonEventHandler *onLoadMoreMessage; //上拉
@property(nonatomic,assign) int pageIndex;
@property(nonatomic,assign) int pageSize;

-(NSMutableArray*)dataArray;
-(void)setDataArray:(NSMutableArray*)aDatas;
- (void)innerInit;

@end
