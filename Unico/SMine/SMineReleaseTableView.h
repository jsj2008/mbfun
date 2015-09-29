//
//  SMineReleaseTableView.h
//  Wefafa
//
//  Created by unico_0 on 6/4/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMineViewController.h"
@protocol SMineTableViewDelegate <NSObject>

- (void)listViewDidScroll:(UIScrollView *)scrollView;
- (void)listViewWillBeginDraggingScroll:(UIScrollView *)scrollView;
- (void)cellDeleteAtIndex:(NSInteger)indexCell;

@end

@interface SMineReleaseTableView : UITableView
@property (nonatomic) BOOL isMine;
@property (nonatomic, assign) id<SMineTableViewDelegate> tableViewDelegate;
@property (nonatomic, assign) SMineViewController *parentVc;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, copy) void (^opration)(NSIndexPath *indexPath, NSArray *array);
@property (nonatomic, strong) NSNumber *isAbandonRefresh;

@end
