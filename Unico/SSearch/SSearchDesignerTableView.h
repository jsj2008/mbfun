//
//  SSearchAttentionTableView.h
//  Wefafa
//
//  Created by unico_0 on 5/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SMineTableViewDelegate <NSObject>

- (void)listViewDidScroll:(UIScrollView *)scrollView;

@end

@interface SSearchDesignerTableView : UITableView

@property (nonatomic, assign) id<SMineTableViewDelegate> tableViewDelegate;

@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) NSMutableArray *contentModelArray;
@property (nonatomic, copy) void (^opration)(NSIndexPath *indexPath, NSArray *array);
@property (nonatomic, strong) NSNumber *isAbandonRefresh;
@property (nonatomic, strong) NSNumber *isHotData;

@end
