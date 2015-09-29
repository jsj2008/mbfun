//
//  BuyButtonTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-11-5.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "BuyButtonTableViewCell.h"
#import "WeFaFaGet.h"
#import "Utils.h"
#import "CommMBBusiness.h"
#import "SQLiteOper.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "AppSetting.h"
//#import "GetViewControllerFile.h"

#import "BuyCollocationViewController.h"

//static const int BuyButtonTableViewCellHeight=60;48
//static const int BuyButtonTableViewCellHeight=58;
static const int BuyButtonTableViewCellHeight=50;

@implementation BuyButtonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

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
#if 0
    self.backgroundColor=COLLOCATION_TABLE_BG;
    self.frame=CGRectMake(0, 0, self.frame.size.width, BuyButtonTableViewCellHeight);
    if (_addshoppingTrolleyBtn==nil)
    {
        _addshoppingTrolleyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addshoppingTrolleyBtn.frame = CGRectMake(15, 8, 120, 29);
        [_addshoppingTrolleyBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        _addshoppingTrolleyBtn.backgroundColor = [Utils HexColor:0x353535 Alpha:1.0];
        [_addshoppingTrolleyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addshoppingTrolleyBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_addshoppingTrolleyBtn addTarget:self action:@selector(clickAddShoppingTrolleyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addshoppingTrolleyBtn];
        
        _directBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _directBuyBtn.frame = CGRectMake(SCREEN_WIDTH/2+25, 8, 120, 29);
        [_directBuyBtn setTitle:@"购买套装" forState:UIControlStateNormal];
        _directBuyBtn.backgroundColor = [Utils HexColor:0xf46c56 Alpha:1.0];
        _directBuyBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_directBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_directBuyBtn addTarget:self action:@selector(clickDirectBuyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_directBuyBtn];
    }
#endif
//    self.backgroundColor = [UIColor whiteColor];//lightGrayColor
    self.backgroundColor=[Utils HexColor:0xf2f2f2 Alpha:1];
    self.frame=CGRectMake(0, 0, self.frame.size.width, BuyButtonTableViewCellHeight);
    if (_addshoppingTrolleyBtn==nil)
    {
        _addshoppingTrolleyBtn = [UIButton buttonWithType:UIButtonTypeCustom];//9
        _addshoppingTrolleyBtn.frame = CGRectMake(45,10, 100, 30);
//        _addshoppingTrolleyBtn.frame = CGRectMake(15, 14, 120, 30);
//        _addshoppingTrolleyBtn.frame = CGRectMake(15, 14, SCREEN_WIDTH/2-30, 30);
        _addshoppingTrolleyBtn.layer.masksToBounds=YES;
        _addshoppingTrolleyBtn.layer.cornerRadius = 3;
        [_addshoppingTrolleyBtn setTitle:@"加入购物袋" forState:UIControlStateNormal];
//        _addshoppingTrolleyBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _addshoppingTrolleyBtn.backgroundColor=[UIColor blackColor];
        
        
        //[Utils HexColor:0x353535 Alpha:1.0];
//        [_addshoppingTrolleyBtn setBackgroundImage:[UIImage imageNamed:@"btn_detail_addshop"] forState:UIControlStateNormal];
        [_addshoppingTrolleyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addshoppingTrolleyBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_addshoppingTrolleyBtn addTarget:self action:@selector(clickAddShoppingTrolleyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addshoppingTrolleyBtn];
        
        _directBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _directBuyBtn.frame = CGRectMake(175, 14, 100, 30);
        _directBuyBtn.frame = CGRectMake(SCREEN_WIDTH/2+25, 10, 100, 30);
//        _directBuyBtn.frame = CGRectMake(SCREEN_WIDTH/2+15, 14, SCREEN_WIDTH/2-30, 30);
        [_directBuyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        _directBuyBtn.backgroundColor =  [Utils HexColor:0xffde00 Alpha:1];
//        [_directBuyBtn setBackgroundColor:[UIColor blackColor]];
     
        //        [_directBuyBtn setBackgroundImage:[UIImage imageNamed:@"btn_detail_mainshop"] forState:UIControlStateNormal];
        _directBuyBtn.layer.masksToBounds=YES;
        _directBuyBtn.layer.cornerRadius = 3;
        _directBuyBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_directBuyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_directBuyBtn addTarget:self action:@selector(clickDirectBuyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_directBuyBtn];
    }

}

//-(void)setCollocationInfo:(NSDictionary *)collocationDict
//{
//    _lbName.text=[Utils getSNSString:collocationDict[@"collocationInfo"][@"name"]];
//    NSDate *date=[Utils getDateTimeInterval_MS:collocationDict[@"collocationInfo"][@"creatE_DATE"]];
//    _lbTime.text=[Utils FormatDateTime:date FormatType:FORMAT_DATE_TYPE_DURATION];
//}

-(void)dealloc
{
    _retainViewController=nil;
}
-(void)clickAddShoppingTrolleyBtn:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notif_BuyButtonTableViewCell_onBuyButtonClick" object:self userInfo:@{@"buttonname":@"加入购物车",@"collocationId":_data[@"collocationId"]}];

}

-(void)clickDirectBuyBtn:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notif_BuyButtonTableViewCell_onBuyButtonClick" object:self userInfo:@{@"buttonname":@"立即购买",@"collocationId":_data[@"collocationId"]}];
}

+(int)getCellHeight:(id)data1
{
    return BuyButtonTableViewCellHeight;
}

-(void)setData:(NSDictionary *)data1
{
    _data=data1;
}

@end
