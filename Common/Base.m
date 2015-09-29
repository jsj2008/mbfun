//
//  Base.m
//  Wefafa
//

#import "Base.h"

bool IS_IOS5_LATER = false;

//////////////////////////////////////

@implementation NSArray (FirstObject)
- (id)firstObject
{
    if ([self count] > 0)
    {
        return [self objectAtIndex:0];
    }
    return nil;
}
@end


