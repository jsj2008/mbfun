//
//  SMineDesignerTableView.h
//  Wefafa
//
//  Created by unico_0 on 6/6/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBOtherUserInfoModel;

@protocol SMineDesignerTableViewDelegate <NSObject>

- (void)listViewDidScroll:(UIScrollView *)scrollView;
- (void)listViewWillBeginDraggingScroll:(UIScrollView *)scrollView;
- (void)needRequestLoadData:(UITableView*)tableView;

@end

@interface SMineDesignerTableView : UITableView
@property (nonatomic, assign) id<SMineDesignerTableViewDelegate> tableViewDelegate;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, copy) void (^opration)(NSIndexPath *indexPath, NSArray *array);
@property (nonatomic, strong) NSNumber *isAbandonRefresh;

@end
