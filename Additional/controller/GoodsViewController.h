//
//  GoodsViewController.h
//  newdesigner
//
//  Created by Miaoz on 14-9-28.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodCategoryObj;
#import "BaseViewController.h"
@interface GoodsViewController : BaseViewController
@property(nonatomic,strong)NSString *goodSecondCategoryid;
@property(nonatomic,strong)GoodCategoryObj *goodCategoryObj;
@property(nonatomic,strong)NSMutableDictionary *getDic;//搜索的字段
@property(nonatomic,strong)NSString *descContent;
- (IBAction)rightBarButtonItemClickevent:(UIBarButtonItem *)sender;
- (IBAction)leftBarButtonItemClickevent:(id)sender;

@end
