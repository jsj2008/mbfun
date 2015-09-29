//
//  CommonEventHandler.h
//  Wefafa
//
//  Created by fafa  on 13-7-9.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonEventListener.h"

@interface CommonEventHandler : NSObject
{
    NSMutableArray *listeners;
}

-(BOOL)existListener;
-(void)addListener:(CommonEventListener*)commonEventListener;
-(void)addListener:(id)sender selector:(SEL)selector;
-(void)removeListener:(CommonEventListener*)commonEventListener;
-(void)fire:(id)sender eventData:(id)eventData;

+(CommonEventHandler *)instance:(id)sender selector:(SEL)selector;

@end
