//
//  GoodsOrderAmountTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "GoodsOrderAmountTableViewCell.h"
#import "Utils.h"

//static const int TableViewCellHeight=44;

@implementation GoodsOrderAmountTableViewCell

- (void)awakeFromNib
{
    [self innerInit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)innerInit
{
}

//{"id":19,"accounT_ORIGINAL_CODE":"gh_d6e75bc5e759","opeN_ID":"o2AHRjqrSHwGZIhGJ_0Js0xnZj44","name":"扈静静","country":"","province":"上海市","city":"上海市","county":"浦东新区","address":"上海市上海市浦东新区测试数据","mobileno":"13052227879","isdefault":"1","posT_CODE":"","creatE_DATE":"\/Date(1400490775723-0000)\/","lasT_MODIFIED_DATE":"\/Date(1400836504920-0000)\/","creatE_USER":"牛牛呼噜","lasT_MODIFIED_USER":"牛牛呼噜"}
-(void)setData:(NSDictionary *)data1
{
    _lbCount.text=[[NSString alloc] initWithFormat:@"共%@件商品",[Utils getSNSInteger:data1[@"count"]]];
    _lbAmount.text=[[NSString alloc] initWithFormat:@"商品总价: ￥%0.2f",[data1[@"amount"] floatValue]];
    _lbTransFee.text=[[NSString alloc] initWithFormat:@"运费: ￥%0.2f",[data1[@"haulage"] floatValue]];
}

+(int)getCellHeight:(NSDictionary*)data1
{
    GoodsOrderAmountTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsOrderAmountTableViewCell" owner:self options:nil] objectAtIndex:0];
    return cell.frame.size.height;
}

@end
