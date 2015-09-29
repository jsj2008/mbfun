//
//  OrderOtherTableViewCell.m
//  Wefafa
//
//  Created by fafatime on 14-12-6.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "OrderOtherTableViewCell.h"

@implementation OrderOtherTableViewCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    _stepNumTextField.isComeFromOrder=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}
- (IBAction)textValueChanged:(id)sender {
//    [self setGoodsNumber:_stepNumTextField.text];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postValue" object:nil];
    
}
@end
