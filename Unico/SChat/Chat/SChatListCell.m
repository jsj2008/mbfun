//
//  SChatListCell.m
//  UUChatTableView
//
//  Created by Ryan on 15/6/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "SChatListCell.h"
#import "SUtilityTool.h"
@implementation SChatListCell

- (void)awakeFromNib {
    // Initialization code
    _num.layer.cornerRadius = _num.frame.size.height/2;
    _num.layer.masksToBounds = YES;
    _num.backgroundColor = [Utils HexColor:0xfb5b4e Alpha:1];//COLOR_C12;

    _name.font = FONT_t4;
    _name.textColor = COLOR_C2;
    
    _msg.font = FONT_t6;
    _msg.textColor = COLOR_C6;
    
    _img.layer.cornerRadius = _img.frame.size.height/2;
    _img.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SChatListModel *)model {
    self.name.text = model.name;
    if (!IS_STRING(model.img)) {
        [self.img sd_setImageWithURL:[NSURL URLWithString:DEFAULT_HEADIMG]];
    }else{
        [self.img sd_setImageWithURL:[NSURL URLWithString:model.img]];
    }
    
    NSString *createDateStr = [self getdate:model.lastTime];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *createDate = [formatter dateFromString:createDateStr];
    NSTimeInterval timeoffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
    createDate = [createDate dateByAddingTimeInterval:timeoffset];
    
    NSDate *nowdate = [NSDate date];
    nowdate = [nowdate dateByAddingTimeInterval:timeoffset];
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:createDate toDate:nowdate options:0];
    
    if (components.year > 1) {
        NSCalendar *calendar2 = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components2 = [calendar2 components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:createDate];
        self.time.text = [NSString stringWithFormat:@"%d年%d月%d日", (int)components2.year, (int)components.month, (int)components.day];
    }else {
        if (components.month > 1) {
            self.time.text = [NSString stringWithFormat:@"%d月前", (int)components.month];
        }else {
            if (components.weekOfYear > 1) {
                self.time.text = [NSString stringWithFormat:@"%d星期钱", (int)components.weekOfYear];
            }else {
                if (components.day > 1) {
                    self.time.text = [NSString stringWithFormat:@"%d天前", (int)components.day];
                }else {
                    if (components.hour > 1) {
                        self.time.text = [NSString stringWithFormat:@"%d小时前", (int)components.hour];
                    }else {
                        self.time.text = [NSString stringWithFormat:@"%d分钟前", (int)components.minute];
                    }
                }
            }
        }
    }
    
    [self.time sizeToFit];
    
//    [self.msg sizeToFit];
//    [self.name sizeToFit];
//    
//    CGRect rect = self.name.frame;
//    rect.origin.y = self.name.bottom;
//    self.msg.frame = rect;
    self.msg.text = model.lastMsg;
    if (model.type == UUMessageTypePicture) {
        self.msg.text = @"[图片]";
    }else if (model.type == UUMessageTypeVoice) {
        self.msg.text = @"[语音]";
    }
    // 红色数字
    if ([model.num intValue] <= 0 ) {
        self.num.hidden = YES;
    } else {
        self.num.hidden = NO;
    }
    self.num.text = model.num.stringValue;
}

-(NSString *)getdate:(NSString *)datestr {
    NSString *dateString=datestr;
    NSDate *date ;
    if (datestr.length>1 && [[datestr substringToIndex:1] isEqualToString:@"/"])
    {
        NSArray *arr=[datestr componentsSeparatedByString:@"/Date("];
        NSString *s=[arr lastObject];
        arr=[s componentsSeparatedByString:@")/"];
        
        s=arr[0];
        arr=[s componentsSeparatedByString:@"-"];
        s=arr[0];
        date =[NSDate dateWithTimeIntervalSince1970:[s longLongValue]/1000];
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateString=[NSString stringWithFormat:@"%@",[format stringFromDate:date]];
        
    }
    return dateString;
}


@end
