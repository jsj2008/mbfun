//
//  BinDingBankCardStepViewController.h
//  Wefafa
//
//  Created by Jiang on 2/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SubClassBaseViewController.h"
@class BaseBankFilterModel;

@interface BinDingBankCardStepViewController : SubClassBaseViewController

@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *bankCardNumber;
@property (nonatomic, strong) BaseBankFilterModel *baseBankFilterModel;

@end
