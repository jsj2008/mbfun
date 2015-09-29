//
//  ReturnGoodAndMoneyTableView.h
//  Wefafa
//
//  Created by fafatime on 14-12-19.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "PullDragTableView.h"
#import "UIUrlImageView.h"
#import "OrderBtn.h"
#import "CommonEventHandler.h"
@interface ReturnGoodAndMoneyTableView : PullDragTableView<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,retain)NSArray* dataArray;
@property (nonatomic,assign) int cellDefaultHeight;
@property(nonatomic,readonly,retain) CommonEventHandler *onDidSelectedRow; //行选中
@property(nonatomic,readonly,retain) CommonEventHandler *onDidCancleRow; //取消订单
@property(nonatomic,readonly,retain) CommonEventHandler *onDidOrderRow; //付款
@property(nonatomic,readonly,retain) CommonEventHandler *onDicTransRow;
@end
