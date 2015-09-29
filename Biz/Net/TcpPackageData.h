//
//  TcpPackageData.h
//  Wefafa
//
//  Created by fafa  on 13-9-5.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 传输数据包
 * 包格式定义如下：
 * UDP包体
 * 2Byte	4Byte	    NByte
 * 命令		内容长度		具体内容
 *
 */
@interface TcpPackageData : NSObject

@property (strong, nonatomic) NSString* IPRemote_Address;
@property (assign, nonatomic) int IPRemote_Port;
@property (strong, nonatomic) NSString* Command;
@property (assign, nonatomic) int PackageLen;
@property (assign, nonatomic) Byte * Data;

@end
