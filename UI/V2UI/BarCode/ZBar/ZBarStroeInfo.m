//
//  ZBarStroeInfo.m
//  Wefafa
//
//  Created by albertWang on 15-2-10.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "ZBarStroeInfo.h"

@implementation ZBarStroeInfo
+(instancetype) shareZBarStroeInfo{
    static ZBarStroeInfo * zbarStroeInfo = nil ;
    static dispatch_once_t dispatchOne ;
    dispatch_once(&dispatchOne, ^{
        zbarStroeInfo = [[ZBarStroeInfo alloc] init] ;
    });
    return zbarStroeInfo ;
}
@end
