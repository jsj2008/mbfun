//
//  MBStoreShowDataView.m
//  Wefafa
//
//  Created by Jiang on 5/4/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBStoreShowDataView.h"
#import "MBStorePopupDataView.h"
#import "MBStoreVisitorModel.h"
#import "Utils.h"

@interface MBStoreShowDataView ()

@property (nonatomic, strong) MBStorePopupDataView *popupDataView;

@end

@implementation MBStoreShowDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShowPopupData:)];
    [self addGestureRecognizer:tap];
}

- (void)tapShowPopupData:(UITapGestureRecognizer*)tap{
    CGPoint touchLocation = [tap locationInView:self];
//    点击到弹出View时，隐藏View
    if(CGRectContainsPoint(self.popupDataView.frame, touchLocation) && ![self.popupDataView isHidden]){
        [UIView animateWithDuration:0.15 animations:^{
            self.popupDataView.hidden = YES;
        }];
        return;
    }
    self.popupDataView.hidden = NO;
//    获得点击位置对应的数据
    int index = (touchLocation.x + 5.0)/ kShowPointLocation_X;
    if (index >= _contentModelArray.count) return;
    MBStoreVisitorModel *model = _contentModelArray[index];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"MM"];
    NSString *monthString = [formatter stringFromDate:model.create_date];
    [formatter setDateFormat:@"dd"];
    NSString *dayString = [formatter stringFromDate:model.create_date];
//    设置弹出View数据机是否翻转、及箭头对应比例位置
    [self.popupDataView setSubViewsDataWithShareCount:model.sharedCount.intValue visitorCount:model.clickCount.intValue month:monthString day:dayString];
    CGFloat y = self.frame.size.height - (CGFloat)(model.clickCount.intValue + model.sharedCount.intValue)/ (self.maxVisitorCount) * (self.frame.size.height - 10) - 5;
    CGPoint popupCenter = CGPointMake(15 + index * kShowPointLocation_X, y);
    if (popupCenter.y < self.popupDataView.frame.size.height) {
        [self.popupDataView setDirection:topDirection];
    }else{
        [self.popupDataView setDirection:bottomDirection];
    }
    CGFloat popup_Width = self.popupDataView.frame.size.width;
    if (popupCenter.x < popup_Width/ 2){
        self.popupDataView.apicoLocation_X = popupCenter.x;
    }else if(popupCenter.x > self.frame.size.width - popup_Width/ 2){
        self.popupDataView.apicoLocation_X = popup_Width - (self.frame.size.width - popupCenter.x);
    }else{
        self.popupDataView.apicoLocation_X = popup_Width/ 2;
    }
    self.popupDataView.center = popupCenter;
    self.popupDataView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.25 animations:^{
        self.popupDataView.transform = CGAffineTransformIdentity;
    }];
}

- (MBStorePopupDataView *)popupDataView{
    if(!_popupDataView){
        _popupDataView = [[MBStorePopupDataView alloc]initWithShareCount:0 visitorCount:0 month:@"0" day:@"0"];
        self.popupDataView.apicoLocation_X = 20;
        [self addSubview:self.popupDataView];
    }
    return _popupDataView;
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    CGRect frame = self.frame;
    frame.size.width = kShowPointLocation_X * (contentModelArray.count - 1) + 30;
    self.frame = frame;
    _popupDataView.hidden = YES;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 2);
    
    CGContextSetStrokeColorWithColor(context, [Utils HexColor:0xffde00 Alpha:1].CGColor);
    CGContextSetFillColorWithColor(context, [Utils HexColor:0xffde00 Alpha:1].CGColor);
    CGContextBeginPath(context);
    for (int i = 0; i < self.contentModelArray.count; i ++) {
        MBStoreVisitorModel *model = _contentModelArray[i];
        CGFloat y = self.frame.size.height - (CGFloat)(model.clickCount.intValue + model.sharedCount.intValue)/ (self.maxVisitorCount) * (self.frame.size.height - 10) - 5;
        if (i == 0) {
            CGContextMoveToPoint(context, i * kShowPointLocation_X + 15, y);
        }else{
            CGContextAddLineToPoint(context, i * kShowPointLocation_X + 15, y);
        }
        CGContextAddArc(context, i * kShowPointLocation_X + 15, y, 2, 0, M_PI * 2, 0);
    }
    CGContextDrawPath(context, kCGPathStroke);
}

@end
