//
//  CollocationTableView.h
//  Wefafa
//
//  Created by mac on 14-8-13.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EGORefreshTableHeaderView.h"
//#import "EGORefreshTableFooterView.h"
#import "CommonEventHandler.h"
#import "PullDragTableView.h"

@interface CollocationTableView : PullDragTableView<UITableViewDelegate,UITableViewDataSource>//UITableView<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,EGORefreshTableFooterDelegate>
{
//    NSMutableArray* _dataArray;
//
//    // 加载状态
//    EGORefreshTableHeaderView *headViewRefresh;
//    BOOL isLoadData;
//    
//    EGORefreshTableFooterView *footViewRefresh;
//    BOOL reloading;
//    
    int cellDefaultHeight;
}

@property(nonatomic,assign) int selectedRowNum;
@property(nonatomic,readonly,retain) CommonEventHandler *onDidSelectedRow; //行选中
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSMutableDictionary *param;

@property (nonatomic,assign) BOOL showBottom;

//@property (strong, nonatomic) NSDictionary *functionXML;
//@property (strong, nonatomic) NSDictionary *rootXML;

//-(NSMutableArray*)dataArray;
//-(void)setDataArray:(NSMutableArray*)aDatas;

@end
