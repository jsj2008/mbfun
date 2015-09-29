//
//  CustomNormalListView.h
//  Wefafa
//
//  Created by mac on 14-8-13.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEventHandler.h"
#import "PullDragTableView.h"

@protocol CustomNormalListViewDelegate <NSObject>

-(id)createListCell:(id)sender;
-(void)listView:(id)sender cell:(id)cell cellForRowAtIndexPath:(NSIndexPath*)indexPath;

@optional
-(void)listView:(id)sender cell:(id)cell clickedItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)listView:(id)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath;

//拖拽刷新事件
-(void)listView:(id)sender reloadData:(id)param;
-(void)listView:(id)sender loadMoreData:(id)param;

@end

@interface CustomNormalListView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    PullDragTableView *pullDragTableView;
    int cellDefaultHeight;
}

@property (nonatomic,assign) id<CustomNormalListViewDelegate>delegate;
@property (nonatomic,assign) UITableViewStyle tableStyle;


-(UITableViewCell*)createDefaultCell:(int)index;
-(void)setDataArray:(NSMutableArray *)dataarr;
-(NSMutableArray *)dataArray;

@end
