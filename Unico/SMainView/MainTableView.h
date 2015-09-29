//
//  MainTableView.h
//  Wefafa
//
//  Created by su on 15/6/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kTableViewType) {
    kTableViewTypeTopic,
    kTableViewTypeHot,
    kTableViewTypeAttention,
    kTableViewTypeAll,
    kTableViewTypeNone
};

@interface MainTableView : UITableView
@property(nonatomic,weak)UIViewController *ownerVC;
@property(nonatomic,assign)BOOL needUpload;
- (void)requestDataWithType:(kTableViewType)type;
- (void)refrashTableLogout;
@end
