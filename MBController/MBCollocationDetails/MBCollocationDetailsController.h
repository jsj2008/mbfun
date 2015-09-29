//
//  MBCollocationDetailsController.h
//  Wefafa
//
//  Created by Jiang on 5/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    succeed = 0,
    failure,
    cancel,
} ShareStatus;

@interface MBCollocationDetailsController : UIViewController

@property (nonatomic, copy) NSString *collocationID;

@end
