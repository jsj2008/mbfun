//
//  MyShareViewController.h
//  Wefafa
//
//  Created by fafatime on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"
@class ImageWaterView;

@interface MyShareViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) NSString *user_Id;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) ImageWaterView *waterView;
@property (strong, nonatomic) ImageWaterView *goodWaterView;
@property (assign,nonatomic) BOOL isMy;

@end
