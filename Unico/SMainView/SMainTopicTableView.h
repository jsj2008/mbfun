//
//  SMainTopicTableView.h
//  Wefafa
//
//  Created by unico_0 on 7/9/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMainTopicTableView : UITableView

@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSArray *headerArray;
@property (nonatomic, assign) UIViewController *target;

@end
