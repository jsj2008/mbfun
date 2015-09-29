//
//  SActivityReceiveTableViewCell.m
//  Wefafa
//
//  Created by unico_0 on 6/9/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SActivityReceiveTableViewCell.h"
#import "SUtilityTool.h"
#import "Utils.h"
#import "SActivityReceiveModel.h"
#import "SActivityReceiveBatchModel.h"

@interface SActivityReceiveTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showFanTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *fanRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanConditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *receviveFanButton;
@property (weak, nonatomic) IBOutlet UILabel *fanQuantityLabel;
@property (weak, nonatomic) IBOutlet UIView *fanQuantityContentView;
- (IBAction)receiveFanButtonAction:(UIButton *)sender;

@property (nonatomic, strong) CALayer *fanProgressLayer;

@end

@implementation SActivityReceiveTableViewCell

- (void)awakeFromNib {
    _fanQuantityContentView.layer.borderWidth = 1;
    _fanQuantityContentView.layer.borderColor = COLOR_C1.CGColor;
    _fanQuantityContentView.layer.cornerRadius = 3.0;
    _fanQuantityContentView.layer.masksToBounds = YES;
    
    _fanProgressLayer = [CALayer layer];
    _fanProgressLayer.backgroundColor = [Utils HexColor:0xFFF2A9 Alpha:1].CGColor;
    _fanProgressLayer.frame = _fanQuantityLabel.bounds;
    [_fanQuantityContentView.layer insertSublayer:_fanProgressLayer atIndex:0];
    
    _receviveFanButton.layer.cornerRadius = 3.0;
    _receviveFanButton.layer.masksToBounds = YES;
}
- (NSString*)getDate:(NSString*)string{
    NSString *dateString = @"";
    if (string.length>1 && [[string substringToIndex:1] isEqualToString:@"/"])
    {
        NSArray *arr=[string componentsSeparatedByString:@"/Date("];
        NSString *s=[arr lastObject];
        arr=[s componentsSeparatedByString:@")/"];
        
        s=[arr firstObject];
        arr=[s componentsSeparatedByString:@"-"];
        s=[arr firstObject];
        NSDate *date =[NSDate dateWithTimeIntervalSince1970:[s longLongValue]/1000];
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy.MM.dd"];
        dateString = [NSString stringWithFormat:@"%@",[format stringFromDate:date]];
        
    }
    return dateString;
}
- (void)setContentModel:(SActivityVouchersListModel *)contentModel{
    _contentModel = contentModel;
    SActivityVouchersListModel *model = _contentModel;
    CGRect frame = _fanProgressLayer.frame;
    
    CGFloat prohress = model.right_num.floatValue/ model.total_num.floatValue;
    frame.size.width = prohress * _fanQuantityLabel.frame.size.width;
  
    _fanProgressLayer.frame = frame;

    NSArray *startTime = [model.use_start_time componentsSeparatedByString:@" "];
    NSArray *endTime = [model.use_end_time componentsSeparatedByString:@" "];
    
    NSString *send_Beg_Time = [startTime firstObject];
    NSString *send_End_Time = [endTime firstObject];
    _fanDateLabel.text =[NSString stringWithFormat:@"使用期限：%@-%@", send_Beg_Time,send_End_Time];
    if([model.right_num integerValue]>[model.total_num integerValue])
    {
        _fanQuantityLabel.text = [NSString stringWithFormat:@"已领取%@/%@",model.total_num , model.total_num];
    }
    else
    {
        _fanQuantityLabel.text = [NSString stringWithFormat:@"已领取%@/%@",model.right_num , model.total_num];
    }

    _fanConditionLabel.text = model.info;
    _fanRangeLabel.text= model.name;
    
    [self setShowImageName:model.trigger_type];
//    isget  1代表可以领取 0 代表不可以领
    if (!contentModel.isGet.boolValue) {
        _receviveFanButton.selected = YES;
        _receviveFanButton.userInteractionEnabled = NO;
        _receviveFanButton.backgroundColor = COLOR_C11;
       
    }else if([[NSString stringWithFormat:@"%@",model.right_num] integerValue] >= [[NSString stringWithFormat:@"%@",model.total_num] integerValue] ){// //已领取的与总量
        _receviveFanButton.enabled = NO;
        _receviveFanButton.selected = NO;
        _receviveFanButton.backgroundColor = COLOR_C11;
    }else if (model.isEndActivity.boolValue){
        _receviveFanButton.userInteractionEnabled = NO;
        [_receviveFanButton setTitle:@"已结束" forState:UIControlStateNormal];
        [_receviveFanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _receviveFanButton.enabled = YES;
        _receviveFanButton.selected = NO;
        _receviveFanButton.backgroundColor = COLOR_C11;
    }else if ([[NSString stringWithFormat:@"%@",model.part_num] integerValue] >= [[NSString stringWithFormat:@"%@",model.user_num] integerValue])//已经领取到的 与可以领的做比较
    {
        _receviveFanButton.enabled = NO;
        _receviveFanButton.selected = NO;
        _receviveFanButton.backgroundColor = COLOR_C11;
    }
    else {
        _receviveFanButton.userInteractionEnabled = YES;
        [_receviveFanButton setTitle:@"领取范票" forState:UIControlStateNormal];
        [_receviveFanButton setTitleColor:COLOR_C2 forState:UIControlStateNormal];
        _receviveFanButton.enabled = YES;
        _receviveFanButton.selected = NO;
        _receviveFanButton.backgroundColor = COLOR_C1;
    }
}

- (void)setShowImageName:(NSString*)string{
    NSString *name = @"";//1.指定商品  2.指定品牌  3.全场',
    if ([string isEqualToString:@"3"]) {
        name = @"Unico/ticket_quanchangfanpiao";
    }else if ([string isEqualToString:@"1"]) {
        name = @"Unico/ticket_danpinfanpiao";
    }else if ([string isEqualToString:@"4"]) {
        name = @"Unico/ticket_dapeifanpiao";
    }else if ([string isEqualToString:@"2"]) {
        name = @"Unico/ticket_pinpaifanpiao";
    }
    
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 100, 5, 20)];
    self.showFanTypeImageView.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (IBAction)receiveFanButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(activityReceiveFanButton:model:)]) {
        [self.delegate activityReceiveFanButton:sender model:_contentModel];
    }
}
@end
