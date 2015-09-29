//
//  GoodsOrderMemoTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsOrderBaseTableViewCell.h"

@interface GoodsOrderMemoTableViewCell : GoodsOrderBaseTableViewCell

@property (strong, nonatomic) IBOutlet UITextField *txtMemo;

- (IBAction)textDidEndOnExit:(id)sender;
- (IBAction)textEditingDidBegin:(id)sender;
- (IBAction)textEditingChanged:(id)sender;

@end
