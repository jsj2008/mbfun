//
//  SChatSystemListCellTableViewCell.m
//  Wefafa
//
//  Created by wave on 15/6/15.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SChatSystemListCellTableViewCell.h"
#import "Utils.h"
#import "SUtilityTool.h"
@implementation SChatSystemListCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _num.layer.cornerRadius = _num.frame.size.height/2;
    _num.layer.masksToBounds = YES;
    _num.textColor = COLOR_C10;
    _num.backgroundColor = COLOR_C10;//[Utils HexColor:0xfb5b4e Alpha:1];//COLOR_C12;
    
    _name.font = FONT_t4;
    _name.textColor = COLOR_C2;
    
    _msg.font = FONT_t6;
    _msg.textColor = COLOR_C6;
    _msg.numberOfLines = 0;
    
    _img.layer.cornerRadius = _img.frame.size.height/2;
    _img.layer.masksToBounds = YES;
    
    _head_v_view.layer.cornerRadius= _head_v_view.frame.size.height/2;
    _head_v_view.layer.masksToBounds=YES;
    _head_v_view.layer.borderWidth = 1.0;
    _head_v_view.layer.borderColor = [UIColor whiteColor].CGColor;
    [_head_v_view setImage:[UIImage imageNamed:@"peoplevip@2x"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SChatSystemListModel *)model {
    NSString *head_v_type=[NSString stringWithFormat:@"%@",model.SChatSystemListCreateUserInfo.head_v_type];
    
    switch ([head_v_type integerValue]) {
        case 0:
        {
            _head_v_view.hidden=YES;
        }
            break;
        case 1:
        {
            _head_v_view.hidden=NO;
            [_head_v_view setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
        case 2:
        {
            [_head_v_view setImage:[UIImage imageNamed:@"peoplevip@2x"]];
            _head_v_view.hidden=NO;
        }
            break;
        default:
            break;
    }
    self.name.text = model.SChatSystemListCreateUserInfo.nick_name;
    if (!IS_STRING(model.SChatSystemListCreateUserInfo.head_img)) {
        [self.img sd_setImageWithURL:[NSURL URLWithString:DEFAULT_HEADIMG]];
    }else {
        [self.img sd_setImageWithURL:[NSURL URLWithString:model.SChatSystemListCreateUserInfo.head_img] completed:nil];
    }
    
    self.msg.text = model.message;
    [self.msg setPreferredMaxLayoutWidth:UI_SCREEN_WIDTH - 12 - 8 -10 -15 - 50 -10];
    self.msg.numberOfLines = 2;
    [self.msg intrinsicContentSize];
    
    [self.detailImg sd_setImageWithURL:[NSURL URLWithString:model.img]];
    
    NSString *createDateStr = [self getdate:model.create_time];
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
        self.time.text = [NSString stringWithFormat:@"%d年%d月%d日", (int)components2.year, (int)components2.month, (int)components2.day];
    }else {
        if (components.month > 1) {
            self.time.text = [NSString stringWithFormat:@"%d月前", (int)components.month];
        }else {
            if (components.weekOfYear > 1) {
                self.time.text = [NSString stringWithFormat:@"%d星期前", (int)components.weekOfYear];
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
    
    // 红色数字 is_read == 1 已经读取 is_read == 0 没有读取
    if ([model.is_read intValue] == 1) {
        self.num.hidden = YES;
    } else {
        self.num.hidden = NO;
    }
    
    self.num.text = @"1";
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
