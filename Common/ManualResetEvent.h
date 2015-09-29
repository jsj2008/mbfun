//
//  ManualResetEvent.h
//  FaFa
//
//  Created by mac on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManualResetEvent : NSObject
{
    NSCondition *syn;
}

-(void)reset;
-(void)set;
-(void)waitOne;
-(void)waitOne:(int)millisecondsTimeout;
@end
