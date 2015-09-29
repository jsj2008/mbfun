//
//  GoodsOrderAddressTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//
#import "GoodsOrderAddressTableViewCell.h"
#import "Utils.h"
#import "SUtilityTool.h"

static const int TableViewCellHeight=70;//94
static const int LabelHeight=14;
static const int LabelWidth=274;//230

@implementation GoodsOrderAddressTableViewCell

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
    _lbAddress.numberOfLines=0;
}

//{"id":19,"accounT_ORIGINAL_CODE":"gh_d6e75bc5e759","opeN_ID":"o2AHRjqrSHwGZIhGJ_0Js0xnZj44","name":"扈静静","country":"","province":"上海市","city":"上海市","county":"浦东新区","address":"上海市上海市浦东新区测试数据","mobileno":"13052227879","isdefault":"1","posT_CODE":"","creatE_DATE":"\/Date(1400490775723-0000)\/","lasT_MODIFIED_DATE":"\/Date(1400836504920-0000)\/","creatE_USER":"牛牛呼噜","lasT_MODIFIED_USER":"牛牛呼噜"}
-(void)setData:(NSDictionary *)data1
{
    _data=data1;
    _lbName.text=[Utils getSNSString:_data[@"name"]];
    _lbMobile.text=[NSString stringWithFormat:@"电话: %@",[Utils getSNSString:_data[@"mobileno"]]];
    if (![data1[@"noaddress"] isEqualToString:@"1"])
    {
        NSString *isDefault=[NSString stringWithFormat:@"%@",_data[@"is_default"]];
        NSString *oldIsDefault=[NSString stringWithFormat:@"%@",_data[@"isdefault"]];
        NSString *moren=@"";
        if([isDefault integerValue]==1||[oldIsDefault integerValue]==1)
        {
           moren =[NSString stringWithFormat:@"[默认] "];
        }

        _lbAddress.text=[NSString stringWithFormat:@"%@%@ %@ %@ %@",moren,[Utils getSNSString:_data[@"province"]],[Utils getSNSString:_data[@"city"]],[Utils getSNSString:_data[@"county"]],[Utils getSNSString:_data[@"address"]]];
        //收货地址:
        _lbAddress.textColor=COLOR_C2;
        _lbAddress.font=FONT_t4;
        
        _lbName.textColor=COLOR_C2;
        _lbName.font=FONT_t4;
        
        _lbMobile.textColor=COLOR_C2;
        _lbMobile.font=FONT_t4;
        
        _nLable.textColor=COLOR_C2;
        _nLable.font=FONT_t4;
        
        _lbName.hidden=NO;
        _lbMobile.hidden=NO;
        _nLable.hidden=NO;
        [_lbAddress setFrame:CGRectMake(_lbAddress.frame.origin.x, 54-15,_lbAddress.frame.size.width, 14)];
//        _lbAddress.numberOfLines=2;
        
    }
    else
    {
        _lbAddress.text=[Utils getSNSString:_data[@"address"]];
        _lbAddress.textColor=COLOR_C2;
        _lbAddress.font=FONT_t3;
        
//        
        _lbName.hidden=YES;
        _lbMobile.hidden=YES;
        _nLable.hidden=YES;
        [_lbAddress setFrame:CGRectMake(_lbAddress.frame.origin.x, (_lbAddress.frame.size.height+_lbAddress.frame.origin.y)/2, _lbAddress.frame.size.width, _lbAddress.frame.size.height+_lbAddress.frame.origin.x)];
        
    }

    [Utils resizeLabel:_lbAddress defaultHeight:LabelHeight defaultWidth:LabelWidth];
    self.frame=CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,_lbAddress.frame.size.height);
    
    
}

+(int)getCellHeight:(NSDictionary*)data1
{
    NSString *data=@"abc";
    if (![data1[@"noaddress"] isEqualToString:@"1"])
        data=[NSString stringWithFormat:@"收货地址: %@ %@ %@ %@",[Utils getSNSString:data1[@"province"]],[Utils getSNSString:data1[@"city"]],[Utils getSNSString:data1[@"county"]],[Utils getSNSString:data1[@"address"]]];
    else
        data=[Utils getSNSString:data1[@"address"]];

    if (data.length==0)
        return TableViewCellHeight;

//    CGSize size=[data sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(LabelWidth, MAXFLOAT)];
    CGSize size = [data boundingRectWithSize:CGSizeMake(LabelWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:11] forKey:NSFontAttributeName] context:nil].size;
    
    int height=size.height>LabelHeight?size.height:LabelHeight;
    return TableViewCellHeight+(height);
    
//    return TableViewCellHeight+(height-LabelHeight);
}


@end
