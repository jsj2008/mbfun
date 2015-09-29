//
//  SMineFollowViewController.h
//  Wefafa
//
//  Created by Funwear on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMineDesignerTableView.h"
@interface SMineFollowFollowerViewController : SBaseViewController

@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSString *person_id;
@property (strong, nonatomic) SMineDesignerTableView *attentionTableView;

@end
