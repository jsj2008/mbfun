//
//  CollocationTopicTableView.h
//  Wefafa
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "PullDragTableView.h"

@interface CollocationTopicTableView : PullDragTableView<UITableViewDelegate,UITableViewDataSource>
{
    int cellDefaultHeight;
}

@property(nonatomic,readonly,retain) CommonEventHandler *onDidSelectedRow; //行选中
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSMutableDictionary *param;

@end
