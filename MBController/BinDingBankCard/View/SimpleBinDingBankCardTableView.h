//
//  AlreadyBinDingBankCardTableView.h
//  Wefafa
//
//  Created by Jiang on 2/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyBankCardModel;

@protocol SimpleBinDingBankCardTableViewDelegate <NSObject>

- (void)alreadyTableDeleteCellWithMode:(MyBankCardModel*)model;
- (void)alreadyTableSettingDefalutCell:(MyBankCardModel*)model;
    

@end

@interface SimpleBinDingBankCardTableView : UITableView

@property (nonatomic, assign) id<SimpleBinDingBankCardTableViewDelegate> alreadyTableViewDelegate;

@property (nonatomic, strong) NSArray *myBankCardModelArray;

@end
