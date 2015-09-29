//
//  SMBCouponActivityCell.m
//  Wefafa
//
//  Created by Miaoz on 15/6/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SMBCouponActivityCell.h"
#import "Utils.h"
@implementation SMBCouponActivityCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SMBCouponActivityCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UITableViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UITableViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        
        
    }
    return self;
}
-(void)setActivityOrdermodel:(ActivityOrderModel *)activityOrdermodel
{
    _activityOrdermodel =activityOrdermodel;
//    NSMutableString *tmpString = [NSMutableString stringWithFormat:@"%@",_activityOrdermodel.name];
    NSString *activityName = [NSString stringWithFormat:@"%@",_activityOrdermodel.tag_img];
    NSArray *activityNameArray = [activityName componentsSeparatedByString:@"|"];
    
    NSMutableString *tmpString = [NSMutableString new];
    for (NSInteger  i = 0;  i <activityNameArray.count;i++ ) {

        if (i != activityNameArray.count -1) {
            [tmpString appendString:[NSString stringWithFormat:@"%@\n",[Utils getSNSString:activityNameArray[i]]]];
        }else{
            [tmpString appendString:[NSString stringWithFormat:@"%@",[Utils getSNSString:activityNameArray[i]]]];
        }
        
        switch (i) {
            case 0:
                _oneLab.text =  [Utils getSNSString:activityNameArray[i]];
                
                break;
            case 1:
                _twoLab.text = [Utils getSNSString:activityNameArray[i]];
                break;
            case 2:
                _threeLab.text =[Utils getSNSString:activityNameArray[i]];
                break;
            default:
                break;
        }
    }
    
    _textView.text = [Utils getSNSString:tmpString];

    
//    _textView.text =[Utils getSNSString:activityName];
    
    NSString *startTime=[NSString stringWithFormat:@"%@",_activityOrdermodel.start_time];
    
    NSString *date = [NSString stringWithFormat:@"使用日期:%@ - %@",[self getDateYearWithSting:startTime],[self getDateYearWithSting:_activityOrdermodel.end_time]];
    _dateLab.text = date;
    NSString *trigger_type=[NSString stringWithFormat:@"%@",_activityOrdermodel.trigger_type];
//    1.指定商品  2.指定品牌  3.全场',
    if ([trigger_type isEqualToString:@"3"]) {//全场
        _bgImageView.image = [[UIImage imageNamed:@"Unico/shopcar_fullnuncheck"] stretchableImageWithLeftCapWidth:150 topCapHeight:0];
        
        if (_activityOrdermodel.can_use.integerValue == 0) {
            
            _bgImageView.image = [[UIImage imageNamed:@"Unico/shopcar_fullonused"] stretchableImageWithLeftCapWidth:150 topCapHeight:0];
            _selectImgView.hidden = YES;
        }
        
    }
    if ([trigger_type isEqualToString:@"2"]) {//品牌
        
        _bgImageView.image = [[UIImage imageNamed:@"Unico/shopcar_branduncheck"] stretchableImageWithLeftCapWidth:150 topCapHeight:0];
        if (_activityOrdermodel.can_use.integerValue == 0) {
            
            _bgImageView.image = [[UIImage imageNamed:@"Unico/shopcar_brandonused"] stretchableImageWithLeftCapWidth:150 topCapHeight:0];
            _selectImgView.hidden = YES;
        }
    }
    
    if ([trigger_type isEqualToString:@"1"]) {//商品
        _bgImageView.image = [[UIImage imageNamed:@"Unico/shopcar_goodsnuncheck"] stretchableImageWithLeftCapWidth:150 topCapHeight:0];
        if (_activityOrdermodel.can_use.integerValue == 0) {
            
            _bgImageView.image = [[UIImage imageNamed:@"Unico/shopcar_goodsonused"]stretchableImageWithLeftCapWidth:150 topCapHeight:0];
            _selectImgView.hidden = YES;
        }
        
    }
    
    
    if ([trigger_type isEqualToString:@"COLLOATION"]) {//搭配
        _bgImageView.image = [[UIImage imageNamed:@"Unico/shopcar_collocationuncheck"] stretchableImageWithLeftCapWidth:150 topCapHeight:0];
        
        if (_activityOrdermodel.can_use.integerValue == 0) {
            
            _bgImageView.image = [[UIImage imageNamed:@"Unico/shopcar_collocationonused"] stretchableImageWithLeftCapWidth:150 topCapHeight:0];
            _selectImgView.hidden = YES;
        }
        
    }
}
-(NSString *)getDateYearWithSting:(NSString *)str
{
    NSString *yearStr=nil;
    NSString *string = [NSString stringWithFormat:@"%@",str];
    NSArray *yearArray=[string componentsSeparatedByString:@" "];
    yearStr = [yearArray firstObject];
    
    return [Utils getSNSString:yearStr];

}

-(void)setPlatFormBasicInfo:(PlatFormBasicInfo *)platFormBasicInfo{
    /*
    _platFormBasicInfo = platFormBasicInfo;

    NSMutableString *tmpString = [NSMutableString new];
    for (NSInteger  i = 0;  i < _platFormBasicInfo.productList.count;i++ ) {
        ProductListModel *tempProductlistInfo=_platFormBasicInfo.productList[i];
        
        PromPlatComDtlInfo *tmpPromPlatComDtlInfo =  _platFormBasicInfo.promPlatComDtlFilterList[i];
        if ([[Utils getSNSString:tempProductlistInfo.activity_name] isEqualToString:@""]) {
            tempProductlistInfo.activity_name = _platFormBasicInfo.name;
        }
        if (i != _platFormBasicInfo.productList.count -1) {
            [tmpString appendString:[NSString stringWithFormat:@"%@\n",tempProductlistInfo.activity_name]];
        }else{
        [tmpString appendString:[NSString stringWithFormat:@"%@",tempProductlistInfo.activity_name]];
        }
        
        switch (i) {
            case 0:
                _oneLab.text = tmpPromPlatComDtlInfo.name;
                
                break;
            case 1:
                _twoLab.text = tmpPromPlatComDtlInfo.name;
                break;
            case 2:
                _threeLab.text = tmpPromPlatComDtlInfo.name;
                break;
            default:
                break;
        }
    }

    _textView.text = tmpString;
     */
    
    /*
    NSString *date = [NSString stringWithFormat:@"使用日期:%@ - %@",[Utils getYearDaydate:_platFormBasicInfo.beG_TIME],[Utils getYearDaydate:_platFormBasicInfo.enD_TIME]];
//
    _dateLab.text = date;
    
    if ([_platFormBasicInfo.promotioN_RANGE isEqualToString:@"ALL"]) {//全场
        _bgImageView.image = [UIImage imageNamed:@"Unico/shopcar_fullnuncheck"];
        
        if (_platFormBasicInfo.isVaild.integerValue == 0) {
            
              _bgImageView.image = [UIImage imageNamed:@"Unico/shopcar_fullonused"];
            _selectImgView.hidden = YES;
        }

    }
    if ([_platFormBasicInfo.promotioN_RANGE isEqualToString:@"BRAND"]) {//品牌
      
        _bgImageView.image = [UIImage imageNamed:@"Unico/shopcar_branduncheck"];
        if (_platFormBasicInfo.isVaild.integerValue == 0) {
            
            _bgImageView.image = [UIImage imageNamed:@"Unico/shopcar_brandonused"];
            _selectImgView.hidden = YES;
        }
    }
    
    if ([_platFormBasicInfo.promotioN_RANGE isEqualToString:@"PROD"]) {//商品
        _bgImageView.image = [UIImage imageNamed:@"Unico/shopcar_goodsnuncheck"];
        if (_platFormBasicInfo.isVaild.integerValue == 0) {
            
            _bgImageView.image = [UIImage imageNamed:@"Unico/shopcar_goodsonused"];
            _selectImgView.hidden = YES;
        }

    }
    
    
    if ([_platFormBasicInfo.promotioN_RANGE isEqualToString:@"COLLOATION"]) {//搭配
        _bgImageView.image = [UIImage imageNamed:@"Unico/shopcar_collocationuncheck"];
        if (_platFormBasicInfo.isVaild.integerValue == 0) {

            _bgImageView.image = [UIImage imageNamed:@"Unico/shopcar_collocationonused"];
            _selectImgView.hidden = YES;
        }
        
    }

   */
}
/*
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    if (_remarkLabArray == nil) {
        _remarkLabArray = [NSMutableArray new];
        [_remarkLabArray addObject:_oneLab];
        [_remarkLabArray addObject:_twoLab];
        [_remarkLabArray addObject:_threeLab];
    }
    
    NSArray *promPlatComDtlFilterList = _dataDic[@"platFormBasicInfo"][@"promPlatComDtlFilterList"];
   
    for (NSInteger  i = 0;  i < promPlatComDtlFilterList.count;i++ ) {
        UILabel *lab = _remarkLabArray[i];
        lab.text = promPlatComDtlFilterList[i][@"remark"];
    }
    
//    _oneLab.text = _dataDic[@"platFormBasicInfo"][@"name"];
//    _twoLab.text = @"";
//    _threeLab.text = @"";
    NSString *date = [NSString stringWithFormat:@"使用日期:%@-%@",[Utils getdate:_dataDic[@"platFormBasicInfo"][@"beG_TIME"]],[Utils getdate:_dataDic[@"platFormBasicInfo"][@"enD_TIME"]]];
    
    _dateLab.text = date;
    
    if ([_dataDic[@"platFormBasicInfo"][@"promotioN_RANGE"] isEqualToString:@"ALL"]) {
         _bgImageView.image = [UIImage imageNamed:@"Unico/present_alluncheck"];
    }
    if ([_dataDic[@"platFormBasicInfo"][@"promotioN_RANGE"] isEqualToString:@"BRAND"]) {
        
         _bgImageView.image = [UIImage imageNamed:@"Unico/present_brand"];
    }
    
}
 */
- (void)awakeFromNib {
    // Initialization code
    
    _selectImgView.image = [UIImage imageNamed:@"Unico/uncheck_zero"];
    _textView.contentInset = UIEdgeInsetsMake(-5, 0, -5, 0);
    _textView.text = @"";
    _oneLab.text = @"";
    _twoLab.text = @"";
    _threeLab.text = @"";
    
//    if (WINDOWW > 320) {
//        _selectImgView.center = CGPointMake(_selectImgView.center.x -7, _selectImgView.center.y);
//    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
