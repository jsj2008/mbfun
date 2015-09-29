//
//  SlideCoolMainViewController.h
//  Designer
//
//  Created by Samuel on 1/14/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLSwipeableView.h"
#import "BaseViewController.h"
@interface SlideCoolMainViewController : BaseViewController<ZLSwipeableViewDataSource,
ZLSwipeableViewDelegate, UIActionSheetDelegate>

@property (nonatomic,strong)ZLSwipeableView *swipeableView;




- (IBAction)leftDel:(id)sender;
- (IBAction)rightSav:(id)sender;

- (IBAction)Okay:(id)sender;
- (IBAction)unOkay:(id)sender;

- (IBAction)finish:(id)sender;

@end
