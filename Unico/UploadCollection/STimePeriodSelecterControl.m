//
//  STimePeriodSelecterControl.m
//  Wefafa
//
//  Created by chencheng on 15/8/26.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "STimePeriodSelecterControl.h"

@interface STimePeriodSelecterControl()
{
    UIView  *_bgView;
}

@property(retain, readwrite, nonatomic)UIImageView *startImageView;
@property(retain, readwrite, nonatomic)UIImageView *endImageView;
@property(retain, readwrite, nonatomic)UILabel *currentSelectionLabel;

@end


@implementation STimePeriodSelecterControl

- (id)initWithFrame:(CGRect)frame totalDuration:(float)totalDuration miniSelecterDuration:(float)miniSelecterDuration maxSelecterDuration:(float)maxSelecterDuration
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.bounds.size.width-10, self.bounds.size.height)];
        _bgView.backgroundColor = [UIColor blackColor];
        //_bgView.alpha = 0.4;
        
        _bgView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _bgView.layer.borderWidth = 3;
        
        _bgView.layer.cornerRadius = 6;
        _bgView.layer.masksToBounds = YES;
        
        [self addSubview:_bgView];
        
        self.currentSelectionLabel = [[UILabel alloc] init];
        self.currentSelectionLabel.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:209.0/255.0 blue:56.0/255.0 alpha:1];
        self.currentSelectionLabel.textAlignment = NSTextAlignmentCenter;
        self.currentSelectionLabel.font = [UIFont systemFontOfSize:13];
        self.currentSelectionLabel.textColor = [UIColor colorWithRed:251.0/255.0 green:239.0/255.0 blue:197.0/255.0 alpha:1];
        self.currentSelectionLabel.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:251.0/255.0 alpha:1].CGColor;
        self.currentSelectionLabel.layer.borderWidth = 3;
        self.currentSelectionLabel.layer.cornerRadius = 6;
        
        self.currentSelectionLabel.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer *currentSelectionLabelPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(currentSelectionLabelPan:)];
        [self.currentSelectionLabel addGestureRecognizer:currentSelectionLabelPanGestureRecognizer];
        
        
        [self addSubview:self.currentSelectionLabel];
        
        self.startImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/thumb_icon"]];
        self.startImageView.userInteractionEnabled = YES;
        self.startImageView.frame = CGRectMake(0, 0, 10, self.bounds.size.height);
        UIPanGestureRecognizer *startImageViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(startImageViewPan:)];
        [self.startImageView addGestureRecognizer:startImageViewPanGestureRecognizer];
        
        [self addSubview:self.startImageView];
        
        self.endImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/thumb_icon"]];
        self.endImageView.userInteractionEnabled = YES;
        self.endImageView.frame = CGRectMake(0, 0, 10, self.bounds.size.height);
        
        UIPanGestureRecognizer *endImageViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(endImageViewPan:)];
        [self.endImageView addGestureRecognizer:endImageViewPanGestureRecognizer];
        
        [self addSubview:self.endImageView];
        
        [self setStartSelecterTime:0.0 endSelecterTime:maxSelecterDuration totalDuration:totalDuration miniSelecterDuration:miniSelecterDuration maxSelecterDuration:maxSelecterDuration];
    }
    return self;
}

- (void)currentSelectionLabelPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [panGestureRecognizer translationInView:self];
        
        if (point.x + self.startImageView.center.x < 5)
        {
            point.x = 5 - self.startImageView.center.x;
        }
        
        if (point.x + self.endImageView.center.x > self.bounds.size.width-5)
        {
            point.x = (self.bounds.size.width-5) -self.endImageView.center.x;
        }
        
        [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self];
        
        self.startImageView.center = CGPointMake(self.startImageView.center.x + point.x, self.startImageView.center.y);
        self.endImageView.center = CGPointMake(self.endImageView.center.x + point.x, self.endImageView.center.y);
        self.currentSelectionLabel.center = CGPointMake(self.currentSelectionLabel.center.x + point.x, self.currentSelectionLabel.center.y);

        
        _startSelecterTime = ((self.startImageView.center.x-_bgView.frame.origin.x)/_bgView.bounds.size.width) * _totalDuration;
        
        _endSelecterTime = ((self.endImageView.center.x-_bgView.frame.origin.x)/_bgView.bounds.size.width) * _totalDuration;
        
        
        [self performSelectorWithallTargets];
    }
}

- (void)startImageViewPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [panGestureRecognizer translationInView:self];
        
        if (point.x + self.startImageView.center.x < 5)
        {
            point.x = 5 - self.startImageView.center.x;
        }
        
        
        float minL = (_miniSelecterDuration / _totalDuration) * _bgView.bounds.size.width;
        BOOL  belowTheMinimum = NO;
        if (self.endImageView.centerX - (point.x + self.startImageView.center.x) < minL)
        {
            //已经低于最小值时、endImageView也跟着动，所以检查一下endImageView不要越界
            if (point.x + self.endImageView.center.x > self.bounds.size.width-5)
            {
                point.x = (self.bounds.size.width-5) -self.endImageView.center.x;
            }
            
            belowTheMinimum = YES;
        }
        
        float maxL = (_maxSelecterDuration / _totalDuration) * _bgView.bounds.size.width;
        BOOL  exceedingTheMaximum = NO;
        if (self.endImageView.center.x - (self.startImageView.center.x+point.x) > maxL)
        {
            //已经大于最最大值时、endImageView也跟着动，但不需要检查一下endImageView是否越界，因为endImageView在startImageView的右边。
            exceedingTheMaximum = YES;
        }
        
        [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self];
        
        self.startImageView.center = CGPointMake(self.startImageView.center.x + point.x, self.startImageView.center.y);
        if (exceedingTheMaximum || belowTheMinimum)
        {
            self.endImageView.center = CGPointMake(self.endImageView.center.x + point.x, self.endImageView.center.y);
        }
        self.currentSelectionLabel.frame = CGRectMake(self.startImageView.center.x, 0, self.endImageView.center.x - self.startImageView.center.x, _bgView.bounds.size.height);
        
        
        
        _startSelecterTime = ((self.startImageView.center.x-_bgView.frame.origin.x)/_bgView.bounds.size.width) * _totalDuration;
        
        _endSelecterTime = ((self.endImageView.center.x-_bgView.frame.origin.x)/_bgView.bounds.size.width) * _totalDuration;
        
        
        float cropTime = _endSelecterTime - _startSelecterTime;
        
        if (cropTime > _maxSelecterDuration - 0.05)
        {
            cropTime = _maxSelecterDuration;
        }
        else if (cropTime < _miniSelecterDuration + 0.05)
        {
            cropTime = _miniSelecterDuration;
        }
        
        
        int value1 = cropTime;
        int value2 = ((cropTime) - value1)*100;
        
        self.currentSelectionLabel.text = [NSString stringWithFormat:@"%02d:%02d", value1, value2];
        
        CGSize textSize = [self.currentSelectionLabel.text sizeWithAttributes:@{NSFontAttributeName:self.currentSelectionLabel.font}];
        if (textSize.width > self.currentSelectionLabel.frame.size.width - 10)
        {
            self.currentSelectionLabel.text = @"";
        }
        
        [self performSelectorWithallTargets];
    }
    
}

- (void)endImageViewPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [panGestureRecognizer translationInView:self];
        
        
        
        if (point.x + self.endImageView.center.x > self.bounds.size.width-5)
        {
            point.x = (self.bounds.size.width-5) -self.endImageView.center.x;
        }
        
        float minL = (_miniSelecterDuration / _totalDuration) * _bgView.bounds.size.width;
        BOOL  belowTheMinimum = NO;
        if (point.x + self.endImageView.center.x - self.startImageView.center.x < minL)
        {
            //已经低于最小值时、startImageView也跟着动，所以检查一下startImageView不要越界
            if (point.x + self.startImageView.center.x < 5)
            {
                point.x = 5 - self.startImageView.center.x;
            }
            belowTheMinimum = YES;
        }
        
        float maxL = (_maxSelecterDuration / _totalDuration) * _bgView.bounds.size.width;
        BOOL  exceedingTheMaximum = NO;
        if (point.x + self.endImageView.center.x - self.startImageView.center.x > maxL)
        {
            //已经大于最最大值时、startImageView也跟着动，但不需要检查一下startImageView是否越界，因为startImageView在endImageView左边边。
            exceedingTheMaximum = YES;
        }
        
        
        [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self];
        
        if (exceedingTheMaximum || belowTheMinimum)
        {
            self.startImageView.center = CGPointMake(self.startImageView.center.x + point.x, self.startImageView.center.y);
        }
        
        self.endImageView.center = CGPointMake(self.endImageView.center.x + point.x, self.endImageView.center.y);
        
        self.currentSelectionLabel.frame = CGRectMake(self.startImageView.center.x, 0, self.endImageView.center.x - self.startImageView.center.x, _bgView.bounds.size.height);
        
        _startSelecterTime = ((self.startImageView.center.x-_bgView.frame.origin.x)/_bgView.bounds.size.width) * _totalDuration;
        
        _endSelecterTime = ((self.endImageView.center.x-_bgView.frame.origin.x)/_bgView.bounds.size.width) * _totalDuration;
        
        float cropTime = _endSelecterTime - _startSelecterTime;
        
        if (cropTime > (_maxSelecterDuration - 0.05))
        {
            cropTime = _maxSelecterDuration;
        }
        else if (cropTime < _miniSelecterDuration+0.05)
        {
            cropTime = _miniSelecterDuration;
        }
        
        //self.currentSelectionLabel.text = [NSString stringWithFormat:@"%0.02fs", cropTime];
        
        int value1 = cropTime;
        int value2 = ((cropTime) - value1)*100;
        
        //self.currentSelectionLabel.text = [NSString stringWithFormat:@"%0.02fs", _endSelecterTime - _startSelecterTime];
        self.currentSelectionLabel.text = [NSString stringWithFormat:@"%02d:%02d", value1, value2];

        CGSize textSize = [self.currentSelectionLabel.text sizeWithAttributes:@{NSFontAttributeName:self.currentSelectionLabel.font}];
        if (textSize.width > self.currentSelectionLabel.frame.size.width - 10)
        {
            self.currentSelectionLabel.text = @"";
        }

        
        [self performSelectorWithallTargets];
    }
}


- (void)setStartSelecterTime:(float)startSelecterTime endSelecterTime:(float)endSelecterTime totalDuration:(float)totalDuration miniSelecterDuration:(float)miniSelecterDuration maxSelecterDuration:(float)maxSelecterDuration
{
    _startSelecterTime = startSelecterTime;
    _endSelecterTime = endSelecterTime;
    _totalDuration = totalDuration;
    _miniSelecterDuration = miniSelecterDuration;
    _maxSelecterDuration = maxSelecterDuration;
    
    //NSLog(@"startTime = %f endTime = %f totalTime = %f", startTime, endTime, totalTime);
    
    if (self.totalDuration > 0 && _startSelecterTime < self.totalDuration)
    {
        float k = _startSelecterTime/self.totalDuration;
        
        self.startImageView.center = CGPointMake(_bgView.bounds.size.width*k  + _bgView.frame.origin.x, _bgView.bounds.size.height/2.0);
    }
    
    if (self.totalDuration > 0 && _endSelecterTime < self.totalDuration && _endSelecterTime > _startSelecterTime)
    {
        float k = _endSelecterTime/self.totalDuration;
        
        self.endImageView.center = CGPointMake(_bgView.bounds.size.width*k  + _bgView.frame.origin.x, _bgView.bounds.size.height/2.0);
    }
    
    self.currentSelectionLabel.frame = CGRectMake(self.startImageView.center.x, 0, self.endImageView.center.x - self.startImageView.center.x, _bgView.bounds.size.height);
    

    int value1 = _endSelecterTime - _startSelecterTime;
    int value2 = ((_endSelecterTime - _startSelecterTime) - value1)*100;
    
    self.currentSelectionLabel.text = [NSString stringWithFormat:@"%02d:%02d", value1, value2];
    
    CGSize textSize = [self.currentSelectionLabel.text sizeWithAttributes:@{NSFontAttributeName:self.currentSelectionLabel.font}];
    if (textSize.width > self.currentSelectionLabel.frame.size.width - 10)
    {
        self.currentSelectionLabel.text = @"";
    }

}


- (void)performSelectorWithallTargets
{
    NSUInteger allTargetsCount = [[self.allTargets allObjects] count];
    
    for (int i=0; i<allTargetsCount; i++)
    {
        id target = [[self.allTargets allObjects] objectAtIndex:i];
        NSArray *actions = [self actionsForTarget:target forControlEvent:UIControlEventValueChanged];
        
        for (NSString *actionString in actions)
        {
            SEL action = NSSelectorFromString(actionString);
            
            if ([target respondsToSelector:action])
            {
                [target performSelector:action withObject:self];
            }
        }
    }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (controlEvents & UIControlEventValueChanged)
    {
        [super addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    }
}


@end
