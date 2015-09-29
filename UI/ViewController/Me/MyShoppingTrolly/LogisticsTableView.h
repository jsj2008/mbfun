//
//  LogisticsTableView.h
//  Wefafa
//
//  Created by wave on 15/5/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^myBlock)();
@interface LogisticsTableView : UITableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withDic:(NSDictionary *)dic;
@property (nonatomic, assign) myBlock clickCellBlock;
@end
