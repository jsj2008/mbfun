//
//  CommonEventListener.h
//  Wefafa
//
//  Created by fafa  on 13-7-9.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonEventListener : NSObject
{
#if __has_feature(objc_arc_weak)
    __weak id _target;
#else
    __unsafe_unretained id _target;
#endif
    SEL _sel;
}

#if __has_feature(objc_arc_weak)
-(id)initWithTarget:(__weak id)target withSEL:(SEL)sel;
#else
-(id)initWithTarget:(__unsafe_unretained id)target withSEL:(SEL)sel;
#endif

#if __has_feature(objc_arc_weak)
+(id)listenerWithTarget:(__weak id)target withSEL:(SEL)sel;
#else
+(id)listenerWithTarget:(__unsafe_unretained id)target withSEL:(SEL)sel;
#endif

-(void)onEvent:(id)sender eventData:(id)eventData;

@end
