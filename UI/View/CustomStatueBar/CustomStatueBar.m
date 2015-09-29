#import "CustomStatueBar.h"

@implementation CustomStatueBar

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 20)];
    if (self)
    {
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        CGRect rect = [UIApplication sharedApplication].statusBarFrame;
        rect = CGRectMake(rect.size.width - 125, rect.origin.y, 100, rect.size.height);
        self.frame = rect; 
        
        rect = CGRectMake(0, 0, self.frame.size.width, rect.size.height);
        defaultLabel = [[BBCyclingLabel alloc]initWithFrame:rect andTransitionType:BBCyclingLabelTransitionEffectScrollUp];
        defaultLabel.backgroundColor = [UIColor clearColor];
        defaultLabel.bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"statusbarbg.png"]];
        [defaultLabel setText:@"" animated:NO];
        defaultLabel.transitionDuration = 0.75;
        defaultLabel.shadowOffset = CGSizeMake(0, 1);
        defaultLabel.font = [UIFont systemFontOfSize:13];
        defaultLabel.textColor = [UIColor whiteColor];
        defaultLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.75];
        defaultLabel.clipsToBounds = YES; 
        defaultLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:defaultLabel];

        [defaultLabel addTarget:self action:@selector(DoOnClick) forControlEvents:UIControlEventTouchUpInside];
        
        messagelock = [[NSCondition alloc] init];
    }
    return self;
}
-(void)DoOnClick
{
    [messagelock lock];
    if (_callbackObj != nil)
    {
        [_callbackObj performSelector:_callbackMethod withObject:_callbackPara];
    }
    [messagelock unlock];
}

- (void)show
{
    self.hidden = NO;
    self.alpha = 1.0f;
    [defaultLabel setText:@"" animated:NO];
}
- (void)hide
{
    _callbackObj = nil;
    _callbackMethod = nil;
    _callbackPara = nil;
    
    self.alpha = 0.0f;    
    defaultLabel.text = @"";
    self.hidden = YES;

}
- (void)changeMessge:(NSString *)message
{
    [messagelock lock];
    _callbackObj = nil;
    _callbackMethod = nil;
    _callbackPara = nil;
    [defaultLabel setText:message animated:YES];
    [messagelock unlock];
}
- (void)changeMessge:(NSString *)message callbackObj:(id)callbackObj callbackMethod:(SEL)callbackMethod callbackPara:(NSObject*)callbackPara
{
    [messagelock lock];
    _callbackObj = callbackObj;
    _callbackMethod = callbackMethod;
    _callbackPara = callbackPara;
    [defaultLabel setText:message animated:YES];
    [messagelock unlock];
}

- (void)dealloc{
    [messagelock release];
    [defaultLabel release];
    [super dealloc];
}
@end
