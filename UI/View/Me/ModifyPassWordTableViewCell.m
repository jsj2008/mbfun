//
//  ModifyPassWordTableViewCell.m
//  Wefafa
//
//  Created by metesbonweios on 15/6/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "ModifyPassWordTableViewCell.h"
#import "Utils.h"

@implementation ModifyPassWordTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _headLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
    _writeTextField.secureTextEntry = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
