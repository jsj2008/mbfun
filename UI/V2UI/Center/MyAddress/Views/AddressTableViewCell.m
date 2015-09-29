//
//  AddressTableViewCell.m
//  BanggoPhone
//
//  Created by issuser on 14-6-24.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changes:(id)sender {
    if (self.addressObject!=nil) {
        [self.addressObject changeAddress:self.indexPath];
    }
}
@end
