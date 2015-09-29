//
//  AttachedCell.m
//  NT
//
//  Created by Kohn on 14-5-27.
//  Copyright (c) 2014年 Pem. All rights reserved.
//

#import "AttachedCell.h"

@implementation AttachedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}
- (IBAction)btnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            NSLog(@">>>>>>>>>>B1");
        }
            break;
        case 2:
        {
            NSLog(@">>>>>>>>>>B2");
        }
            break;
        case 3:
        {
            NSLog(@">>>>>>>>>>B3");
        }
            break;
        case 4:
        {
            NSLog(@">>>>>>>>>>B4");
        }
            break;
        case 5:
        {
            NSLog(@">>>>>>>>>>B5");
        }
            break;
        case 6:
        {
            NSLog(@">>>>>>>>>>B6");
        }
            break;
        case 7:
        {
            NSLog(@">>>>>>>>>>B7");
        }
            break;
            
        default:
            break;
    }
    
    
}

@end
