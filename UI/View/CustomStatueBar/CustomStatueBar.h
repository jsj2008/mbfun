#import <Foundation/Foundation.h>
#import "BBCyclingLabel.h"

@interface CustomStatueBar : UIWindow
{
    BBCyclingLabel *defaultLabel;
    
    NSCondition *messagelock;
    id _callbackObj;
    SEL _callbackMethod;
    NSObject *_callbackPara;
}
- (void)show;
- (void)hide;
- (void)changeMessge:(NSString *)message;
- (void)changeMessge:(NSString *)message callbackObj:(id)callbackObj callbackMethod:(SEL)callbackMethod callbackPara:(NSObject*)callbackPara;

@end
