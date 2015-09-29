//
//  myRedPackTableViewCell.m
//  Wefafa
//
//  Created by metesbonweios on 15/6/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MyRedPackTableViewCell.h"
#import "MyRedPacketModel.h"
#import "Utils.h"
#import "OrderRedPacketModel.h"

@implementation MyRedPackTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_showImgView setImage:[UIImage imageNamed:@"Unico/present_alluncheck"]];
    [_chooseBtn setImage:[UIImage imageNamed:@"Unico/unico_seleted_btn"] forState:UIControlStateSelected];
    [_chooseBtn setImage:[UIImage imageNamed:@"Unico/uncheck_zero"] forState: UIControlStateNormal];
    [_checkDetailBtn setImage:[UIImage imageNamed:@"Unico/present_checkout.png"] forState:UIControlStateNormal];
    
    [_allMoneyLabel setAdjustsFontSizeToFitWidth:YES];
    [_chooseBtn setSelected:NO];
}
//通过个人中心
-(void)setCellModel:(MyRedPacketModel *)cellModel
{
    _cellModel = cellModel;
//    NSString *moneyNum = [NSString stringWithFormat:@"%@元", [Utils getSNSRMBMoneyWithoutMark:_cellModel.coupoN_AMOUNT]];
//    _allMoneyLabel.text= moneyNum;

//   
//    NSString *beginTime = [Utils getdate:_cellModel.valiD_BEG_TIME];
//    NSString *endTime =[Utils getdate:_cellModel.valiD_END_TIME];
    NSString *beginTime = _cellModel.start_time;
    NSString *endTime= _cellModel.end_time;
    
    NSString *beginYear=@"";
    NSString *endYear=@"";
    if(beginTime.length>0&&endTime.length>0)
    {
        NSArray *beginArray = [beginTime componentsSeparatedByString:@" "];
        NSArray *endArray = [endTime componentsSeparatedByString:@" "];
        beginYear =[beginArray firstObject];
        endYear = [endArray firstObject];
    }
    _packetNameLabe.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:_cellModel.info]];;

    _timeLabel.text= [NSString stringWithFormat:@"%@-%@",beginYear,endYear];
    //以前的限制现在变为名字  以前的名字leabel展示 消费多少使用多少
    _restrictionLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:_cellModel.name]];
//    NSString * saleAmount = [Utils getSNSRMBMoneyWithoutMark:_cellModel.salE_AMOUNT];
//    NSString * coupoN_AMOUNT = [Utils getSNSRMBMoneyWithoutMark:_cellModel.coupoN_AMOUNT];
//    NSString *showStr;
//    if([saleAmount floatValue] < [coupoN_AMOUNT floatValue])
//    {
//    
//          showStr = [NSString stringWithFormat:@"抵用券"];
//    }
//    else
//    {
//        showStr = [NSString stringWithFormat:@"满 %@ 元减", saleAmount];
// 
//    }
//    CGSize size = [showStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
//    
//    CGRect frame = _allMoneyLabel.frame;
//    _allMoneyLabel.frame = frame;
//    _packetNameLabe.text=showStr;
    
    _chooseBtn.hidden= YES;
    _chooseBtn.userInteractionEnabled=NO;

    NSArray *picNameArray;
    NSString *usE_RULEStr = [NSString stringWithFormat:@"%@",_cellModel.use_rule];
    //present_checkout@2x  指定单品 搭配 会跳转 下一层页面

    if ([usE_RULEStr isEqualToString:@"ALL"]) {
        
         picNameArray = @[@"Unico/present_fullunused",@"Unico/present_fullunused",@"Unico/present_fullused",@"Unico/present_fullovertime",@"Unico/present_fulllock",@"Unico/all_unstart"];
        
        
    }
    else if ([usE_RULEStr isEqualToString:@"BRAND"])
    {
        picNameArray = @[@"Unico/present_brandunused",@"Unico/present_brandunused",@"Unico/present_brandused_red",@"Unico/present_brandovertime",@"Unico/present_brandlock",@"Unico/brand_unstart"];
        _checkDetailBtn.hidden=NO;
    }
    else if ([usE_RULEStr isEqualToString:@"COLLOATION"])
    {
        picNameArray = @[@"Unico/present_collocationunused",@"Unico/present_collocationunused",@"Unico/present_collocationused",@"Unico/present_collocationovertime",@"Unico/present_collocationlock",@"Unico/collocation_unstart"];
        
        _checkDetailBtn.hidden=NO;
    }
    else if ([usE_RULEStr isEqualToString:@"PROD"])
    {
        picNameArray = @[@"Unico/present_productunused",@"Unico/present_productunused",@"Unico/present_productused",@"Unico/present_productovertime",@"Unico/present_productlock",@"Unico/product_unstart"];
        _checkDetailBtn.hidden=NO;
        
    }
    else
    {
        picNameArray = @[@"Unico/present_fullunused",@"Unico/present_fullunused",@"Unico/present_fullused",@"Unico/present_fullovertime",@"Unico/present_fullunused",@"Unico/all_unstart"];
        
    }
    switch ([_cellModel.status integerValue]) {
        case 1://初始化 已锁定 已使用 已过期
        {
          [_showImgView setImage:[UIImage imageNamed:picNameArray[0]]];
          [_chooseBtn setSelected:NO];
        }
            break;
        case 2:// 已锁定
        {
            [_showImgView setImage:[UIImage imageNamed:picNameArray[4]]];
            _chooseBtn.hidden=YES;
            _checkDetailBtn.hidden=YES;
            
            
        }
            break;
        case 3://已使用
        {
            [_showImgView setImage:[UIImage imageNamed:picNameArray[2]]];
            _checkDetailBtn.hidden=YES;
            
        }
            break;
        case 4://已过期
        {
             [_showImgView setImage:[UIImage imageNamed:picNameArray[3]]];
            _checkDetailBtn.hidden=YES;
            
        }
            break;
            case 5://未使用
        {
            [_showImgView setImage:[UIImage imageNamed:picNameArray[5]]];
            _checkDetailBtn.hidden=YES;
        }
            
        default:
            break;
    }
    _checkDetailBtn.hidden=YES;
    
    
}
// 通过订单
-(void)setOrderCellModel:(OrderRedPacketModel *)orderCellModel
{
    _orderCellModel = orderCellModel;

//    _allMoneyLabel.text=[NSString stringWithFormat:@"%@元",[Utils getSNSRMBMoneyWithoutMark:_orderCellModel.couponuserFilterList.coupoN_AMOUNT]];
    _packetNameLabe.text=[Utils getSNSString:_orderCellModel.info];
    
    
//    NSString *beginTime = [Utils getdate:_orderCellModel.couponuserFilterList.valiD_BEG_TIME];
//    NSString *endTime =[Utils getdate:_orderCellModel.couponuserFilterList.valiD_END_TIME];
    NSString *beginTime = _orderCellModel.start_time;
    NSString *endTime= _orderCellModel.end_time;
    NSString *beginYear=@"";
    NSString *endYear=@"";
    if(beginTime.length>0&&endTime.length>0)
    {
        NSArray *beginArray = [beginTime componentsSeparatedByString:@" "];
        NSArray *endArray = [endTime componentsSeparatedByString:@" "];
        beginYear =[beginArray firstObject];
        endYear = [endArray firstObject];
        
    }
    _timeLabel.text= [NSString stringWithFormat:@"%@ - %@",beginYear,endYear];

    
    _restrictionLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:_orderCellModel.name]];
/*
    NSString * saleAmount = [Utils getSNSRMBMoneyWithoutMark:_orderCellModel.couponuserFilterList.salE_AMOUNT];
    NSString * coupoN_AMOUNT = [Utils getSNSRMBMoneyWithoutMark:_orderCellModel.couponuserFilterList.coupoN_AMOUNT];
    NSString *showStr;
    if([saleAmount floatValue] < [coupoN_AMOUNT floatValue])
    {
        showStr =@"抵用券";
    }
    else
    {
        showStr = [NSString stringWithFormat:@"满 %@ 元减",saleAmount];
        
    }
    CGRect frame = _allMoneyLabel.frame;
    _allMoneyLabel.frame = frame;
    
    _packetNameLabe.text=showStr;
    */

    NSArray *picNameArray;
    NSString *coupoN_RULE_RANGE = [NSString stringWithFormat:@"%@",_orderCellModel.use_rule];
    //最后一个为不可使用
    if ([coupoN_RULE_RANGE isEqualToString:@"ALL"]) {

            picNameArray = @[@"Unico/present_fullunused",@"Unico/present_fullunused",@"Unico/present_fullused",@"Unico/present_fullovertime",@"Unico/present_fullcannot",@"Unico/all_unstart"];
    }
    else if ([coupoN_RULE_RANGE isEqualToString:@"BRAND"])
    {
        
        picNameArray = @[@"Unico/present_brandunused",@"Unico/present_brandunused",@"Unico/present_brandused_red",@"Unico/present_brandovertime",@"Unico/present_brandcannot",@"Unico/brand_unstart"];

    }
    else if ([coupoN_RULE_RANGE isEqualToString:@"COLLOATION"])
    {
        picNameArray = @[@"Unico/present_collocationunused",@"Unico/present_collocationunused",@"Unico/present_collocationused",@"Unico/present_collocationovertime",@"Unico/present_collocationcannot",@"Unico/collocation_unstart"];
    }
    else if ([coupoN_RULE_RANGE isEqualToString:@"PROD"])
    {
        picNameArray = @[@"Unico/present_productunused",@"Unico/present_productunused",@"Unico/present_productused",@"Unico/present_productovertime",@"Unico/present_productcannot",@"Unico/product_unstart"];
    
    }
    else
    {
            picNameArray = @[@"Unico/present_fullunused",@"Unico/present_fullunused",@"Unico/present_fullused",@"Unico/present_fullovertime",@"Unico/present_fullcannot",@"Unico/all_unstart"];
    }
    switch ([_orderCellModel.status integerValue]) {
        case 1://初始化 已锁定 已使用 已过期
        {
            [_showImgView setImage:[UIImage imageNamed:picNameArray[0]]];
            [_chooseBtn setSelected:NO];
        }
            break;
        case 2:// 已锁定
        {
            [_showImgView setImage:[UIImage imageNamed:picNameArray[2]]];
        }
            break;
        case 3://已使用
        {
            [_showImgView setImage:[UIImage imageNamed:picNameArray[2]]];
        }
            break;
        case 4://已过期
        {
            [_showImgView setImage:[UIImage imageNamed:picNameArray[3]]];
        }
            break;
        case 5://未开始
        {
            [_showImgView setImage:[UIImage imageNamed:picNameArray[5]]];
        }
            break;
            
        default:
            break;
    }
    //暂时无不可使用
//    if  ([[NSString stringWithFormat:@"%d",_orderCellModel.canUse] isEqualToString:@"1"])
//    {
//      
//        [_chooseBtn setSelected:NO];
//        _chooseBtn.hidden=NO;
//    }
//    else
//    {
//        [_showImgView setImage:[UIImage imageNamed:picNameArray[4]]];
//        _chooseBtn.hidden=YES;
//    }

}
-(void)setIsComeFromOrder:(BOOL)isComeFromOrder
{
    _isComeFromOrder = isComeFromOrder;
    if (_isComeFromOrder) {
        _chooseBtn.hidden=NO;
    }
    else
    {
        _chooseBtn.hidden=YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//从订单确认页选中的进来后 在定位到哪个选中
-(void)setChoosePacketId:(NSString *)choosePacketId
{
  
    _choosePacketId = choosePacketId;
    
    if([[NSString stringWithFormat:@"%@",_choosePacketId] isEqualToString:[NSString stringWithFormat:@"%@",_orderCellModel.idStr]])
    {
       [_chooseBtn setSelected:YES];
    }
    
}
- (IBAction)clickBtn:(id)sender {
    
    _chooseBtn.selected=!_chooseBtn.selected;
    
    if ([self.redPacketDelete respondsToSelector:@selector(mbCell_OnDidSelectedWithMessage:)]) {
        [self.redPacketDelete mbCell_OnDidSelectedWithMessage:_orderCellModel];
    }
  
}

- (IBAction)gotoDetail:(id)sender {
    
    if ([self.redPacketDelete respondsToSelector:@selector(mbCell_OnDidSelectedGoDetailWithMessage:)]) {
        [self.redPacketDelete mbCell_OnDidSelectedGoDetailWithMessage:_cellModel];
    }
    
}

@end
