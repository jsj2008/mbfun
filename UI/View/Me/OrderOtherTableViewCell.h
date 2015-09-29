//
//  OrderOtherTableViewCell.h
//  Wefafa
//
//  Created by fafatime on 14-12-6.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIStepperNumberField.h"
@interface OrderOtherTableViewCell : UITableViewCell
@property (nonatomic,weak)IBOutlet UITextView *writeTextView;
@property (nonatomic,weak)IBOutlet UIStepperNumberField *stepNumTextField;
@property (nonatomic,weak)IBOutlet UILabel *showTapLabel;

- (IBAction)textValueChanged:(id)sender;
@end
