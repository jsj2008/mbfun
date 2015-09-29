//
//  SearchZXSViewController.h
//  Wefafa
//
//  Created by su on 15/1/28.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 *搜索造型师
 */

@interface SearchDesignerViewController : SBaseViewController
@property(nonatomic,strong)NSString *searchKey;
// 注意：这里在创建单品标签时候使用到了。
@property (nonatomic,strong) SDataTagSelectFunc completeFunc __deprecated_msg("Use `SSearchController`");
@end
