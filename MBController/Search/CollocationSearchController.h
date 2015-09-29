//
//  CollocationSearchController.h
//  Wefafa
//
//  Created by su on 15/1/27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollocationSearchController : UIViewController
@property (nonatomic)BOOL isCollocation;
@property (nonatomic,strong)NSString *searchKey;
@property (nonatomic,strong)NSString *naviTitle;
// 注意：这里在创建单品标签时候使用到了。
@property (nonatomic,strong) SDataTagSelectFunc completeFunc __deprecated_msg("Use `SSearchController`");
@end
