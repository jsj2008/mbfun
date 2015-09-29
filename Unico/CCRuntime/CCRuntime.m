//
//  CCRuntime.m
//  陈诚
//
//  Created by 陈诚 on 14-1-27.
//  Copyright (c) 2014年 陈诚. All rights reserved.
//

#import "CCRuntime.h"
#import <objc/runtime.h>


#pragma mark - 安全的数组

@interface NSArray(Safe)
@end

@implementation NSArray(Safe)

- (id)xxAtIndex:(NSUInteger)index
{
    if (index < self.count)
    {
        id ret = [self xxAtIndex:index];
        return ret;
    }
    
    //NSAssert(NO, @"Crash:NSArray数组越界了[%d], array=%@", index, self);
    return NULL;
}

@end

#pragma mark - 安全的可变数组

@interface NSMutableArray(MSafe)
@end

@implementation NSMutableArray(MSafe)

- (id)mmAtIndex:(NSUInteger)index {
    if (index < self.count)
    {
        id ret = [self mmAtIndex:index];
        return ret;
    }
    
    //NSAssert(NO, @"Crash:NSMutableArray数组越界了[%d], array=%@", index, self);
    return NULL;
}

- (void)mmAddObject:(id)anObject
{
    if (anObject != nil)
    {
        [self mmAddObject:anObject];
    }
    else
    {
        //NSAssert(NO, @"Crash:Add到数组的Object为空, array=%@", self);
    }
}

@end

#pragma mark - 安全的可变字典

@interface NSMutableDictionary(MSafe)

@end

@implementation NSMutableDictionary(MSafe)

- (void)nnSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (aKey != NULL && anObject != NULL)
    {
        [self nnSetObject:anObject forKey:aKey];
    }
    else
    {
        //NSAssert(NO, @"Crash:SetObject:forKey: object为空, key=%@", aKey);
    }
}


@end

//@interface UIApplication(URL)
//@end
//
//@implementation UIApplication(URL)
//
//- (void)mOpenURL:(NSURL*)url {
//    NSString *urlStr = [url.scheme lowercaseString];
//    BOOL isNeedRedirect = NO;
//    
//    if ([urlStr isEqualToString:kCtripWirelessUrlSchemeString])
//    {
//        NSString *host = [url host];
//        
//        if ([host isEqualToString:kCtripWirelessUrlHostString] || [host isEqualToString:@"h5"])
//        {
//            isNeedRedirect = YES;
//            //NOTE:check dispatchURL函数中，不能直接调用openURL:否则死循环，应该试用mOpenURL:替换
//            [CTURLDispatcher dispatchURL:url];
//        }
//    }
//    
//    if (!isNeedRedirect) {
//        [self mOpenURL:url];
//    }
//}
//
//@end


#pragma mark - 方法替换函数

static void exchangeSelector(Class c, SEL originalSEL, SEL newSEL)
{
    Method originalMethod = class_getInstanceMethod(c, originalSEL);
    Method newMethod = class_getInstanceMethod(c, newSEL);
    
    if(class_addMethod(c, originalSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
    {
        class_replaceMethod(c, newSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}


static void replaceMethod()
{
    {
        NSArray *sArr = [NSArray array];
        exchangeSelector([sArr class], @selector(objectAtIndex:), @selector(xxAtIndex:));
    }
    
    {
        NSMutableArray *mArr = [NSMutableArray array];
        exchangeSelector([mArr class], @selector(objectAtIndex:), @selector(mmAtIndex:));
        exchangeSelector([mArr class], @selector(addObject:), @selector(mmAddObject:));
    }
    
    {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        exchangeSelector([mDict class], @selector(setObject:forKey:), @selector(nnSetObject:forKey:));
    }
    
    {
        //if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
        {
            //exchangeSelector([CCNavigationBar class], @selector(drawRect:), @selector(customDrawRect:));
        }
    }
    
    {
       // exchangeSelector([UIApplication class], @selector(openURL:), @selector(mOpenURL:));
    }
}


#pragma mark - CCRuntime的实现

@implementation CCRuntime

+ (void)replaceMethods
{
    replaceMethod();
}

@end
