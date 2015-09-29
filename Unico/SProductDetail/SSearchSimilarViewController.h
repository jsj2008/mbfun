//
//  SSearchSimilarViewController.h
//  Wefafa
//
//  Created by Jiang on 15/9/8.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"
typedef void (^returnTokenblock) (NSString *token);
@interface SSearchSimilarViewController : SBaseViewController

@property (nonatomic, copy) returnTokenblock returnblock;            //设置回调
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, strong) NSMutableDictionary *chooseDic;

@end
