//
//  ChooseAddressViewController.h
//  Designer
//
//  Created by Samuel on 1/19/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ChooseAddressViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableViews;
- (void)chooseAddress:(NSIndexPath*)indexPath;

@end
