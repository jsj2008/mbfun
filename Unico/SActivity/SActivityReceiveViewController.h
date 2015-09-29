//
//  SActivityReceiveViewController.h
//  Wefafa
//
//  Created by unico_0 on 6/9/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SActivityListModel;
@class SMBNewActivityListModel;

@interface SActivityReceiveViewController : SBaseViewController

@property (nonatomic, strong) SMBNewActivityListModel *contentModel;
@property (nonatomic, strong) NSString *activityId;

@end
