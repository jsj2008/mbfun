//
//  ChangeSexTableViewCell.m
//  Designer
//
//  Created by Jiang on 1/20/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "ChangeSexTableViewCell.h"

@implementation ChangeSexTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"icon_profile_checkmark.png"];
        self.accessoryView = [[UIImageView alloc]initWithImage:image];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
    self.accessoryView.hidden = !selected;
}

@end
