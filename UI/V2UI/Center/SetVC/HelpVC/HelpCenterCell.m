//
//  HelpCenterCell.m
//  Designer
//
//  Created by Juvid on 15/1/21.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "HelpCenterCell.h"

@implementation HelpCenterCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //将Custom.xib中的所有对象载入
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:nil options:nil];
        //第一个对象就是CustomCell了
        self = [nib objectAtIndex:0];
        self.backgroundColor=[UIColor whiteColor];
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
