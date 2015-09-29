//
//  GoodsOrderMemoTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "GoodsOrderMemoTableViewCell.h"
#import "utils.h"

@implementation GoodsOrderMemoTableViewCell

- (void)awakeFromNib
{
    [self innerInit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)innerInit
{
}

-(void)setData:(id)data1
{
    _txtMemo.text=data1;
}

- (IBAction)textDidEndOnExit:(id)sender {
    [_txtMemo resignFirstResponder];
}

- (IBAction)textEditingDidBegin:(id)sender {
    if (self.onTextFieldScroll) {
        [self.onTextFieldScroll fire:self eventData:@(self.rownum)];
    }
}

- (IBAction)textEditingChanged:(id)sender {
    if (self.onTextChanged) {
        [self.onTextChanged fire:self eventData:_txtMemo.text];
    }
}

+(int)getCellHeight:(id)data1
{
    return 53;
}

@end
