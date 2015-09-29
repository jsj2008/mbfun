//
//  GoodsOrderPayFeeTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "GoodsOrderPayFeeTableViewCell.h"
#import "Utils.h"

@implementation GoodsOrderPayFeeTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary *)data1
{
    //@{@"haulage":@(haulage),@"disamount":@(disamount),@"summery":@(summery)}
    _lbDisAmount.text=[[NSString alloc] initWithFormat:@"优惠: ￥%0.2f",[data1[@"disamount"] floatValue]];
    _lbFee.text=[[NSString alloc] initWithFormat:@"运费: ￥%0.2f",[data1[@"haulage"] floatValue]];
    _lbSummery.text=[[NSString alloc] initWithFormat:@"合计支付: ￥%0.2f",[data1[@"summery"] floatValue]];
}

+(int)getCellHeight:(NSDictionary*)data1
{
    GoodsOrderPayFeeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsOrderPayFeeTableViewCell" owner:self options:nil] objectAtIndex:0];
    return cell.frame.size.height;
}
@end
