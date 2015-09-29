//
//  TcpService.h
//  Wefafa
//
//  Created by fafa  on 13-9-5.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BufferedSocket.h"
#import "TcpPackageData.h"

//------多人流交换-------
/**
 * 00	传输数据
 */
#define FAFATcpCommand_Command_00 @"00"
/**
 * 01	注册请求
 */
#define FAFATcpCommand_Command_01 @"01"
/**
 * 99	心跳
 */
#define FAFATcpCommand_Command_99 @"99"
//------多人流交换-------

//------上传与下载文-------
/**
 * 40	申请上传文件
 */
#define FAFATcpCommand_Command_40 @"40"
/**
 * 41	上传文件内容
 */
#define FAFATcpCommand_Command_41 @"41"
/**
 * 42	上传完毕
 */
#define FAFATcpCommand_Command_42 @"42"
/**
 * 43	申请下载文件
 */
#define FAFATcpCommand_Command_43 @"43"
/**
 * 44	下载文件内容
 */
#define FAFATcpCommand_Command_44 @"44"
/**
 * 45	下载完毕
 */
#define FAFATcpCommand_Command_45 @"45"

//------上传与下载文-------

@interface TcpService : NSObject

-(void) SendTCPData:(BufferedSocket *) ns PackageData:(TcpPackageData *) pkgData;
-(BOOL) ReadTCPData:(BufferedSocket *)ns PackageData:(TcpPackageData *)pkgData;
-(BOOL) ReadTCPData:(BufferedSocket *)ns PackageData:(TcpPackageData *)pkgData TimeOut:(int) timeout;
-(void) SendTCPData:(BufferedSocket *)ns PackageData:(TcpPackageData *)pkgData TimeOut:(int) timeout;

@end
