//
//  SWaterAdvertCollectionViewCell.m
//  Wefafa
//
//  Created by unico_0 on 6/17/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SWaterAdvertCollectionViewCell.h"
#import "SUtilityTool.h"
#import "LNGood.h"

@interface SWaterAdvertCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *showDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *showWeekLabel;

@property (weak, nonatomic) IBOutlet UILabel *showDateMonthLabel;

@end

@implementation SWaterAdvertCollectionViewCell

- (void)awakeFromNib {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0;
}

- (void)setContentGoodsModel:(LNGood *)contentGoodsModel{
    _contentGoodsModel = contentGoodsModel;
    
    NSDate *nowdate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];//alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit fromDate:nowdate];
    
    _showDayLabel.text = [NSString stringWithFormat:@"%02d", (int)components.day];
    _showDateMonthLabel.text = [NSString stringWithFormat:@"/%ld", (long)components.month];
    NSString *dateString = nil;
    switch (components.weekday - 1) {
        case 1:
            dateString = @"周一";
            break;
        case 2:
            dateString = @"周二";
            break;
        case 3:
            dateString = @"周三";
            break;
        case 4:
            dateString = @"周四";
            break;
        case 5:
            dateString = @"周五";
            break;
        case 6:
            dateString = @"周六";
            break;
        case 0:
            dateString = @"周日";
            break;
            
        default:
            break;
    }
    _showWeekLabel.text = dateString;
    [_contentImageView sd_setImageWithURL:[NSURL URLWithString:contentGoodsModel.img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
}

//_dayLabel.text = [NSString stringWithFormat:@"%ld", (long)components.day];
//_monthLabel.text = [NSString stringWithFormat:@"/%ld", (long)components.month];
////TODO:WEEKDAY AND WEEK ORIDINAL

@end
