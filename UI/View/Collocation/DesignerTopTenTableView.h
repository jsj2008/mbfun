//
//  DesignerTopTenTableView.h
//  Wefafa
//
//  Created by mac on 14-9-26.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "PullDragTableView.h"
#import "CommonEventHandler.h"

@interface DesignerTopTenTableView : PullDragTableView<UITableViewDelegate,UITableViewDataSource>
{
    int cellDefaultHeight;
    NSArray *allImgArray;
    NSArray *titleArray;
    NSMutableArray *championArr;
}

@property(nonatomic,assign) int selectedRowNum;
@property(nonatomic,readonly,retain) CommonEventHandler *onDidSelectedRow; //行选中
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSMutableDictionary *param;

@end
