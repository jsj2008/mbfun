//
//  ViewController.h
//  newdesigner
//
//  Created by Miaoz on 14-9-11.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class GesturesImageView;

@interface PolyvoreViewController : BaseViewController

- (IBAction)rightBarButtonItemClickevent:(id)sender;
- (IBAction)leftBarButtonItemClickevent:(id)sender;
- (IBAction)centerTopButtonClickevent:(id)sender;

//草稿 、 搭配
-(void)callBackMyViewControllerWithServiceCollocationInfo:(id)sender;
@end
