//
//  GoodsOrderSendRequestTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "GoodsOrderSendRequestTableViewCell.h"

@implementation GoodsOrderSendRequestTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(id)data1
{
    _txtRequest.text=data1;
}

- (IBAction)textDidEndOnExit:(id)sender {
    [_txtRequest resignFirstResponder];
}

- (IBAction)textEditingDidBegin:(id)sender {
    if (self.onTextFieldScroll) {
        [self.onTextFieldScroll fire:self eventData:@(self.rownum)];
    }
}

- (IBAction)textEditingChanged:(id)sender {
    if (self.onTextChanged) {
        [self.onTextChanged fire:self eventData:_txtRequest.text];
    }
}

+(int)getCellHeight:(id)data1
{
    return 53;
}

@end
