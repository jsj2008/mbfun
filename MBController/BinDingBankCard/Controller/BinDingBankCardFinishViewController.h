//
//  BinDingBankCardViewController.h
//  Wefafa
//
//  Created by Jiang on 2/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SubClassBaseViewController.h"

@interface BinDingBankCardFinishViewController : SubClassBaseViewController

@property (nonatomic, assign, getter=isBindingSucceed) BOOL bindingSucceed;
@property (nonatomic, copy) NSString *errorContent;

@end
