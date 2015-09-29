//
//  AddRessTableCell.m
//  Wefafa
//
//  Created by fafatime on 14-9-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "AddRessTableCell.h"

@implementation AddRessTableCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnModifyClicked:(id)sender {
    [_btnModifyClickEvent fire:self eventData:@(_row)];
}

@end
