//
//  ManualResetEvent.m
//  FaFa
//
//  Created by mac on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ManualResetEvent.h"

@implementation ManualResetEvent


-(id)init
{
    self=[super init];
    if ( !self )
		return nil;

    syn=[[NSCondition alloc] init];
    
    return self;
}

- (void)dealloc
{
    [syn release];
    [super dealloc];
}

-(void)reset
{
}

-(void)set
{
    [syn lock];
    [syn broadcast];
    [syn unlock];
}

-(void)waitOne
{
    [syn lock];
    [syn wait];
    [syn unlock];
}

-(void)waitOne:(int)millisecondsTimeout
{
    [syn lock];
    NSDate *dTimeout = [NSDate dateWithTimeIntervalSinceNow:millisecondsTimeout/1000.0];
    [syn waitUntilDate:dTimeout];
    [syn unlock];
}
@end
