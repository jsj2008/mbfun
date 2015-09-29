//
//  JSWebViewController.h
//  Wefafa
//
//  Created by su on 15/2/15.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSWebViewController : SBaseViewController
@property (nonatomic,strong)NSString *naviTitle;
@property (nonatomic,strong)NSString *shareImgStr;
@property (nonatomic, assign)BOOL isPayResult;
- (id)initWithUrl:(NSString *)urlString;

@end
