//
//  CommonEventHandler.m
//  Wefafa
//
//  Created by fafa  on 13-7-9.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "CommonEventHandler.h"

@implementation CommonEventHandler

-(id)init
{
    if (self = [super init])
    {
        listeners = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

-(BOOL)existListener
{
    return [listeners count]>0;
}

-(void)addListener:(CommonEventListener*)commonEventListener
{
    [listeners addObject:commonEventListener];
}

-(void)addListener:(id)sender selector:(SEL)selector
{
    [listeners addObject:[CommonEventListener listenerWithTarget:sender withSEL:selector]];
}

-(void)removeListener:(CommonEventListener*)commonEventListener
{
    [listeners removeObject:commonEventListener];
}

-(void)fire:(id)sender eventData:(id)eventData
{
    for (CommonEventListener *commonEventListener in listeners) {
        [commonEventListener onEvent:sender eventData:eventData];
    }
}

+(CommonEventHandler *)instance:(id)sender selector:(SEL)selector
{
    CommonEventHandler *eh=[[CommonEventHandler alloc] init];
    [eh addListener:sender selector:selector];
    return eh;
}

@end
