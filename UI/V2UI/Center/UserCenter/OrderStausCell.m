//
//  OrderStausCell.m
//  Designer
//
//  Created by Juvid on 15/1/22.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "OrderStausCell.h"

@implementation OrderStausCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    // Initialization code
}
-(void)SetCellTilte:(NSIndexPath *)indexPath{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)checkOrder:(UIButton *)sender {
    
}
- (IBAction)PressOrder:(UIButton *)sender {
    OrderStatus status = sender.tag;
    if (self.mDelegate&&[self.mDelegate respondsToSelector:@selector(checkOrderOfOrderStatus:)]) {
        [self.mDelegate checkOrderOfOrderStatus:status];
    }
}
@end
