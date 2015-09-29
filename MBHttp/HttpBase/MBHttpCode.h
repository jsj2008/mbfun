//
//  MBHttpCode.h
//  Wefafa
//
//  Created by su on 15/3/23.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#ifndef Wefafa_MBHttpCode_h
#define Wefafa_MBHttpCode_h

typedef enum : NSUInteger {
    MBHttpErrorTypeNotReachableNet = 1000,    //连不上网络
    MBHttpErrorTypeNoToken = 40003,         //需要访问令牌
    MBHttpErrorTypeInvalidToken = 40004,    //无效的访问令牌
    MBHttpErrorTypeInvalidParam = 40005,    //无效的SOA参数：例如ServiceName没有填写等
} MBHttpErrorType;

#endif
