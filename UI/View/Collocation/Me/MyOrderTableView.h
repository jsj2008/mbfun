//
//  MyOrderTableView.h
//  Wefafa
//
//  Created by fafatime on 14-9-23.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "PullDragTableView.h"
#import "CommonEventHandler.h"
#import "PullDragTableView.h"
@interface MyOrderTableView : PullDragTableView<UITableViewDataSource,UITableViewDelegate>
{
    int  cellDefaultHeight;
    
}
@property(nonatomic,readonly,retain) CommonEventHandler *onDidSelectedRow; //行选中
@property(nonatomic,readonly,retain) CommonEventHandler *onDidCancleRow; //取消订单
@property(nonatomic,readonly,retain) CommonEventHandler *onDidOrderRow; //付款
@property(nonatomic,readonly,retain) CommonEventHandler *onDicTransRow;
@property(nonatomic,assign) int cellDefaultHeight;
@property(nonatomic,retain) NSArray *dataArray;
//@property(nonatomic,copy) NSMutableDictionary *param;
@property (nonatomic,assign) BOOL isUnReceived;

@end
