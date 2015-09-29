//
//  NSMutableQueue.m
//  FaFa
//
//  Created by fafa  on 13-5-25.
//
//

#import "NSMutableQueue.h"

@implementation NSMutableQueue

-(id)init
{
    if (self = [super init])
    {
        _data = [[NSMutableArray alloc] initWithCapacity:10];
        _ReadWriteLock = [[NSLock alloc] init];
    }
    return self;
}

-(void)dealloc {
#if ! __has_feature(objc_arc)
    [_data release];
    [_ReadWriteLock release];
    [super dealloc];
#endif
}

-(NSUInteger)count
{
    return [_data count];
}

-(void)Enqueue:(id)item
{
    if (item == nil) return;
    
    [_ReadWriteLock lock];
    [_data addObject:item];
    [_ReadWriteLock unlock];
}

-(id)Dequeue
{
    id re = nil;    
    
    [_ReadWriteLock lock];
    if (_data.count > 0)
    {
#if ! __has_feature(objc_arc)
        re = [[_data objectAtIndex:0] retain];
#else
        re = [_data objectAtIndex:0];
#endif
        [_data removeObjectAtIndex:0];
    }
    [_ReadWriteLock unlock];
    
#if ! __has_feature(objc_arc)
    return [re autorelease];
#else
    return re;
#endif
}

@end
