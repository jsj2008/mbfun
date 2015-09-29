//
//  SActivityDiscountHeaderView.m
//  Wefafa
//
//  Created by unico_0 on 6/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SActivityDiscountHeaderView.h"
#import "SUtilityTool.h"
#import "SActivityListModel.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"
#import "SMBNewActivityListModel.h"

@interface SActivityDiscountHeaderView ()
{
    long long int _endTime;
    NSTimer *showDateTimer;
}

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIButton *showStateButton;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation SActivityDiscountHeaderView

- (instancetype)init
{
    CGRect frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 175 * UI_SCREEN_WIDTH/ 375.0 + 50);
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    self.backgroundColor = [UIColor whiteColor];
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, 175 * UI_SCREEN_WIDTH/ 375.0);
    _contentImageView = [[UIImageView alloc]initWithFrame:frame];
    _contentImageView.image = [UIImage imageNamed:@"pic_loading@3x.png"];
    _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    _contentImageView.layer.masksToBounds = YES;
    [self addSubview:_contentImageView];
    _contentImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    
    frame = CGRectMake(13.0 * UI_SCREEN_WIDTH/ 375.0, CGRectGetMaxY(_contentImageView.frame), 60, 45);
    _showStateButton = [[UIButton alloc]initWithFrame:frame];
    _showStateButton.userInteractionEnabled = NO;
    [_showStateButton setImage:[UIImage imageNamed:@"Unico/count_down_red.png"] forState:UIControlStateNormal];
    [_showStateButton setTitle:@"倒计时" forState:UIControlStateNormal];
    _showStateButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    [_showStateButton setTitleColor:COLOR_C2 forState:UIControlStateNormal];
    _showStateButton.titleLabel.font = FONT_t6;
    [self addSubview:_showStateButton];
    
    frame.origin.x = CGRectGetMaxX(frame) + 5;
    frame.size.width = 150;
    _dateLabel = [[UILabel alloc]initWithFrame:frame];
    _dateLabel.font = FONT_T6;
    _dateLabel.textColor = COLOR_C10;
    [self addSubview:_dateLabel];
    
    frame = CGRectMake(self.frame.size.width - 85, frame.origin.y + 15/ 2, 75, 30);
    _receiveButton = [[UIButton alloc]initWithFrame:frame];
    [_receiveButton addTarget:self action:@selector(activityReceiveButton:) forControlEvents:UIControlEventTouchUpInside];
    _receiveButton.backgroundColor = COLOR_C1;
    _receiveButton.layer.masksToBounds = YES;
    _receiveButton.layer.cornerRadius = 3.0;
    [_receiveButton setTitle:@"领取范票" forState:UIControlStateNormal];
    [_receiveButton setTitleColor:COLOR_C2 forState:UIControlStateNormal];
    _receiveButton.titleLabel.font = FONT_T4;
    _receiveButton.hidden = YES;
    [self addSubview:_receiveButton];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 10, self.frame.size.width, 10)];
    view.backgroundColor = COLOR_C4;
    [self addSubview:view];
}

- (void)setContentModel:(SMBNewActivityListModel *)contentModel{
    _contentModel = contentModel;
//    _receiveButton.hidden = !contentModel.coupoN_FLAG.boolValue;
    _receiveButton.hidden=YES;
    NSString *imgSt =[contentModel.img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_contentImageView sd_setImageWithURL:[NSURL URLWithString:imgSt] placeholderImage:[UIImage imageNamed:@"pic_loading@3x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    }];
    [self convertDate:contentModel.end_time];

}

- (void)showDate:(NSTimer*)timer{

    long long int current = [[NSDate date]timeIntervalSince1970];
//    long long int current = [self longLongFromDate:[NSDate date]];
    
    if (_endTime <= current) {
        if ([self.delegate respondsToSelector:@selector(activityReceiveEndNavigation)]) {
            [self.delegate activityReceiveEndNavigation];
        }
        _dateLabel.text = @"活动已结束！";
        [_showStateButton setImage:[UIImage imageNamed:@"Unico/activity_clock.png"] forState:UIControlStateNormal];
        [timer invalidate];
        timer = nil;
        return;
    }
    NSMutableString *dateString = [NSMutableString stringWithString:@""];
//    NSDate *date =[NSDate dateWithTimeIntervalSince1970:_endTime];
    NSDate *date = [self dateFromString:_contentModel.end_time];
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendarstart = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendarstart components: NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:currentDate  toDate:date options:0];//NSMonthCalendarUnit |
    if (dateComponents.day > 0) {
        [dateString appendFormat:@"%02d天",(int)dateComponents.day];
    }
    [dateString appendFormat:@"%02d:%02d:%02d", (int)dateComponents.hour, (int)dateComponents.minute, (int)dateComponents.second];
    _dateLabel.text = dateString;
}

- (void)convertDate:(NSString*)string{
//    if (string.length>1 && [[string substringToIndex:1] isEqualToString:@"/"])
//    {
//        NSArray *arr=[string componentsSeparatedByString:@"/Date("];
//        NSString *s=[arr lastObject];
//        arr=[s componentsSeparatedByString:@")/"];
//        
//        s=[arr firstObject];
//        arr=[s componentsSeparatedByString:@"-"];
//        s=[arr firstObject];
//        _endTime = [s longLongValue]/1000;
    
//#warning  时间 计算有错误
//
    
         NSDate *date = [self dateFromString:string];
        _endTime = [self longLongFromDate:date];

        if (showDateTimer) return;
        showDateTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(showDate:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:showDateTimer forMode:NSRunLoopCommonModes];
        [showDateTimer fire];
//    }
}

- (void)activityReceiveButton:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(activityReceiveButton:)]) {
        [self.delegate activityReceiveButton:sender];
    }
}
- (long long)longLongFromDate:(NSDate*)date{
    return [date timeIntervalSince1970];//convertDate
}
- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
//    NSLocale* local =[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSLocale* local =[NSLocale currentLocale];
    
    
    [dateFormatter setLocale: local];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}
- (void)dealloc{
    [showDateTimer invalidate];
}

@end
