//
//  GeneralVCCell.m
//  Designer
//
//  Created by Juvid on 15/1/15.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "GeneralVCCell.h"

@implementation GeneralVCCell
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
        self.labRight.textColor=kUIColorFromRGB(0x333333);
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)OrderStatus:(NSInteger)orderStatus{
     self.labRight.font=[UIFont boldSystemFontOfSize:12];
    switch (orderStatus) {
        case 0:
            
            break;
            
        case 1:
            self.labRight.text=@"待付款";
            break;
        case 2:
          self.labRight.text=@"买家已付款";
            break;
        case 3:
           self.labRight.text=@"卖家已发货";
            break;
        case 4:
            self.labRight.text=@"交易成功";
            break;
        default:
            break;
    }
}
-(void)SetLeftTitle:(NSInteger)orderStatus{
    switch (orderStatus) {
        case 0:
            
            break;
            
        case 1:
            self.labLeft.text=@"未支付";
            break;
        case 2:
            self.labLeft.text=@"买家已付款";
            break;
        case 3:
            self.labLeft.text=@"卖家已发货";
            break;
        case 4:
            self.labLeft.text=@"交易成功";
            break;
        default:
            break;
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
