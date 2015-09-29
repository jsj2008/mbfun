//
//  GoodsDispatchMethodCell.m
//  Wefafa
//
//  Created by Miaoz on 15/2/6.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "GoodsDispatchMethodCell.h"

@implementation GoodsDispatchMethodCell

- (void)awakeFromNib {
    // Initialization code10 7
//    self.frame= CGRectMake(0, 0, UI_SCREEN_WIDTH, self.frame.size.height);
    self.backgroundColor=[UIColor whiteColor];
    // CGRectMake(UI_SCREEN_WIDTH-10-10 , _rightImagView.frame.origin.y, 10, 7)
    [_rightImagView setFrame:CGRectMake(UI_SCREEN_WIDTH-22-10 , (43-22)/2, 22, 22)];
    _rightImagView.image = [UIImage imageNamed:@"Unico/uncheck_zero"];
    [_leftLab setFrame:CGRectMake(_leftLab.frame.origin.x, _leftLab.frame.origin.y, UI_SCREEN_WIDTH-20-10, _leftLab.frame.size.height)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
