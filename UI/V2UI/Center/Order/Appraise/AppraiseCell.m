//
//  AppraiseCell.m
//  BanggoPhone
//
//  Created by Juvid on 14-7-14.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import "AppraiseCell.h"

@implementation AppraiseCell

- (void)awakeFromNib
{
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //将Custom.xib中的所有对象载入
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AppraiseCell" owner:nil options:nil];
        //第一个对象就是CustomCell了
        self = [nib objectAtIndex:0];
         self.imgGoods.contentMode=UIViewContentModeScaleAspectFit;

        UIView *vie=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
        self.txtAppraise.leftView=vie;
        self.txtAppraise.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(selected) {
        [(UIButton *)self.accessoryView setHighlighted:NO];
    }
    // Configure the view for the selected state
}

@end
