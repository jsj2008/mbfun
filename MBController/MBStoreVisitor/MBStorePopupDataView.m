//
//  MBStorePopupDataView.m
//  Wefafa
//
//  Created by Jiang on 5/4/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBStorePopupDataView.h"
#import "Utils.h"

@interface MBStorePopupDataView ()
{
    int _sharedCount;
    int _visitorCount;
    NSString *_month;
    NSString *_day;
}

@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UILabel *percentageLable;
@property (nonatomic, strong) UILabel *visitorLabel;

@end

@implementation MBStorePopupDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViewsWithFrame:frame];
    }
    return self;
}

- (instancetype)initWithShareCount:(int)sharedCount
                      visitorCount:(int)visitorCount
                             month:(NSString*)month
                               day:(NSString*)day
{
    CGRect frame = CGRectMake(0, 0, 120, 90);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViewsWithFrame:frame];
        [self setSubViewsDataWithShareCount:sharedCount visitorCount:visitorCount month:month day:day];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                   shareCount:(int)sharedCount
                 visitorCount:(int)visitorCount
                        month:(NSString*)month
                          day:(NSString*)day
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViewsWithFrame:frame];
        [self setSubViewsDataWithShareCount:sharedCount visitorCount:visitorCount month:month day:day];
    }
    return self;
}

- (void)addSubViewsWithFrame:(CGRect)frame{
    self.layer.zPosition = 5;
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0.8;
    
    UIColor *textColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(15, 10, frame.size.width - 30, 20.0);
    _percentageLable = [[UILabel alloc]initWithFrame:rect];
    _percentageLable.textColor = textColor;
    [self addSubview:_percentageLable];
    
    rect.size.width = UI_SCREEN_WIDTH;
    rect.origin.y = CGRectGetMaxY(rect);
    _shareLabel = [[UILabel alloc]initWithFrame:rect];
    _shareLabel.textColor = textColor;
    _shareLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:_shareLabel];
    
    rect.origin.y = CGRectGetMaxY(rect);
    _visitorLabel = [[UILabel alloc]initWithFrame:rect];
    _visitorLabel.textColor = textColor;
    _visitorLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:_visitorLabel];
}

- (void)setSubViewsDataWithShareCount:(int)sharedCount
                         visitorCount:(int)visitorCount
                                month:(NSString*)month
                                  day:(NSString*)day{
    
    _sharedCount = sharedCount;
    _visitorCount = visitorCount;
    _month = month;
    _day = day;
    
    NSMutableAttributedString *percentageString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@/%@", _month, _day]];
    [percentageString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:15.0]
                             range:NSMakeRange(0, _month.length)];
    [percentageString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:12.0]
                             range:NSMakeRange(_month.length, percentageString.length - _month.length)];
    _percentageLable.attributedText = percentageString;
    NSString *shareString = [NSString stringWithFormat:@"分享次数：%d次", _sharedCount];
    NSString *visitorString = [NSString stringWithFormat:@"访客量：%d次", _visitorCount];
    _shareLabel.text = shareString;
    _visitorLabel.text = visitorString;
    NSString *string = shareString.length >= visitorString.length? shareString: visitorString;
    CGSize size = [string boundingRectWithSize:CGSizeMake(0, 20)
                                       options:NSStringDrawingUsesDeviceMetrics
                                    attributes:@{NSFontAttributeName : _shareLabel.font} context:nil].size;
    CGRect frame = self.frame;
    frame.size.width = size.width + 30;
    self.frame = frame;
    [self setNeedsDisplay];
}

- (void)setApicoLocation_X:(CGFloat)apicoLocation_X{
    if (_apicoLocation_X == apicoLocation_X) {
        return;
    }
    _apicoLocation_X = apicoLocation_X;
    self.layer.anchorPoint = CGPointMake(_apicoLocation_X/ self.frame.size.width, _direction == topDirection? 0: 1);
    [self setNeedsDisplay];
}

- (void)setDirection:(PointToDirection)direction{
    if (_direction == direction) {
        return;
    }
    _direction = direction;
    self.layer.anchorPoint = CGPointMake(_apicoLocation_X/ self.frame.size.width, _direction == topDirection? 0: 1);
    [self setNeedsDisplay];
}

- (void)setDirection:(PointToDirection)direction location_X:(CGFloat)location_X{
    if (_apicoLocation_X == location_X && direction == _direction) {
        return;
    }
    _apicoLocation_X = location_X;
    _direction = direction;
    self.layer.anchorPoint = CGPointMake(_apicoLocation_X/ self.frame.size.width, _direction == topDirection? 0: 1);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    UIColor *color = [Utils HexColor:0x333333 Alpha:1];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 5.0);
    
    rect = CGRectInset(rect, 5, 5);
    
    CGFloat insetValue;
    CGFloat oringinPoint_Y;
    CGFloat oringinPoint_X;
    CGFloat endPoint_X;
    CGFloat endPoint_Y;
    
    if (_direction == topDirection) {
        insetValue = 5.0;
        oringinPoint_Y = insetValue;
        oringinPoint_X = insetValue;
        endPoint_X = rect.size.width + insetValue;
        endPoint_Y = rect.size.height - insetValue;
    }else{
        insetValue = -5.0;
        oringinPoint_Y = rect.size.height;
        oringinPoint_X = rect.size.width - insetValue;
        endPoint_X = fabs(insetValue);
        endPoint_Y = fabs(insetValue);
    }
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, _apicoLocation_X, oringinPoint_Y);
    
    CGContextAddLineToPoint(context, _apicoLocation_X + 2 * insetValue, oringinPoint_Y + insetValue);
    
    CGContextAddLineToPoint(context, endPoint_X, oringinPoint_Y + insetValue);
    
    CGContextAddLineToPoint(context, endPoint_X, endPoint_Y);
    
    CGContextAddLineToPoint(context, oringinPoint_X, endPoint_Y);
    
    CGContextAddLineToPoint(context, oringinPoint_X, oringinPoint_Y + insetValue);
    
    CGContextAddLineToPoint(context, _apicoLocation_X - 2 * insetValue, oringinPoint_Y + insetValue);
    
    CGContextAddLineToPoint(context, _apicoLocation_X, oringinPoint_Y);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
