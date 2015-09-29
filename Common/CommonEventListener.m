//
//  CommonEventListener.m
//  Wefafa
//
//  Created by fafa  on 13-7-9.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "CommonEventListener.h"

@implementation CommonEventListener

#if __has_feature(objc_arc_weak)
-(id)initWithTarget:(__weak id)target withSEL:(SEL)sel;
#else
-(id)initWithTarget:(__unsafe_unretained id)target withSEL:(SEL)sel;
#endif
{
    if (self = [super init])
    {
        _target = target;
        _sel = sel;
    }
    return self;
    
}

-(void)dealloc
{
}

#if __has_feature(objc_arc_weak)
+(id)listenerWithTarget:(__weak id)target withSEL:(SEL)sel;
#else
+(id)listenerWithTarget:(__unsafe_unretained id)target withSEL:(SEL)sel;
#endif
{
    return [[self alloc] initWithTarget:target withSEL:sel];
}

-(void)onEvent:(id)sender eventData:(id)eventData;
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_target performSelector:_sel withObject:sender withObject:eventData];
#pragma clang diagnostic pop
}

@end
