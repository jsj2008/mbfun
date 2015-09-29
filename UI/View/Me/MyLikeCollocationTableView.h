//
//  MyLikeCollocationTableView.h
//  Wefafa
//
//  Created by mac on 14-10-20.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "PullDragTableView.h"

#import "CommonEventHandler.h"
#import "PullDragTableView.h"

@interface MyLikeCollocationTableView : PullDragTableView<UITableViewDelegate,UITableViewDataSource>
{
    int cellDefaultHeight;
}

@property(nonatomic,assign) int selectedRowNum;
@property(nonatomic,readonly,retain) CommonEventHandler *onDidSelectedRow; //行选中
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSMutableDictionary *param;

@end
