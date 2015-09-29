//
//  SSearchTopicTableView.h
//  Wefafa
//
//  Created by unico_0 on 6/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StopicListModel;

@protocol SSearchTopicTableViewDelegate <NSObject>

- (void)listViewDidScroll:(UIScrollView *)scrollView;

@end

@interface SSearchTopicTableView : UITableView

@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, assign) id<SSearchTopicTableViewDelegate> topicDelegate;
@property (nonatomic, copy) void (^opration)(StopicListModel *model);
@property (nonatomic, weak) UIViewController *targetController;
@property (nonatomic, strong) NSNumber *isAbandonRefresh;
@property (nonatomic, strong) NSNumber *isHotData;

@end
