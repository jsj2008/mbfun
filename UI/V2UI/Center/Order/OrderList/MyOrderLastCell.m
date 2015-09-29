//
//  MyOrderLastCell.m
//  Designer
//
//  Created by Juvid on 15/1/19.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "MyOrderLastCell.h"

@implementation MyOrderLastCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //将Custom.xib中的所有对象载入
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:nil options:nil];
        //第一个对象就是CustomCell了
        self = [nib objectAtIndex:0];
        self.backgroundColor=[UIColor whiteColor];
        self.labLeft.textColor=kUIColorFromRGB(0x333333);
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)OrderStatus:(NSInteger)orderStatus{
    switch (orderStatus) {
        case 0:
            
            break;
         
        case 1:
            self.btnLeft.hidden=YES;
            [self.btnRight setTitle:@"去付款" forState:UIControlStateNormal];
            break;
        case 2:
            self.btnRight.hidden=YES;
            self.btnLeft.hidden=YES;
            break;
        case 3:
            [self.btnLeft setTitle:@"查看物流" forState:UIControlStateNormal];
            [self.btnRight setTitle:@"确认收货" forState:UIControlStateNormal];
            break;
        case 4:
            self.btnLeft.hidden=YES;
            [self.btnRight setTitle:@"评价订单" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
- (IBAction)PressTure:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(PressBtnTitle:)]) {
       [ self.delegate PressBtnTitle:sender.currentTitle];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
