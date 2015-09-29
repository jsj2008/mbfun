//
//  FAFAUdpClient.h
//  Wefafa
//
//  Created by fafa  on 13-10-14.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
#import "ManualResetEvent.h"
#import "NSMutableQueue.h"

/**
 * 传输数据包
 * 包格式定义如下：
 * UDP包体
 * 2Byte	4Byte	    NByte
 * 命令		内容长度		具体内容
 * @author User
 *
 */
@interface FUdpPackageData : NSObject

@property (strong, nonatomic) NSData *IPRemote;
@property (strong, nonatomic) NSString *IPRemoteHost;
@property (assign, nonatomic) uint16_t IPRemotePort;

@property (strong, nonatomic) NSString* Command;
@property (assign, nonatomic) int PackageLen;
@property (strong, readonly, nonatomic) NSMutableData *Data;

@end

@interface FUDPData : NSObject

@property (strong, nonatomic) GCDAsyncUdpSocket *UDPListen;
@property (strong, nonatomic) FUdpPackageData *PkgData;

@end

@interface FUProcFuncHandleListener : NSObject
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

-(FUdpPackageData*)onEvent:(id)sender data:(FUdpPackageData*)data;

@end

//---------多人流交换-------------
/**
 * 00	传输数据
 */
#define FAFAUdpCommand_Command_00 @"00"
/**
 * 01	注册请求
 */
#define FAFAUdpCommand_Command_01 @"01"
/**
 * 99	心跳
 */
#define FAFAUdpCommand_Command_99 @"99"
//---------多人流交换-------------

//---------p2p流交换-------------
/**
 * 10	传输数据
 */
#define FAFAUdpCommand_Command_10 @"10"
/**
 * 11	连接测试
 */
#define FAFAUdpCommand_Command_11 @"11"
//---------p2p流交换-------------

//---------p2p流代理-------------
/**
 * 20	传输数据
 */
#define FAFAUdpCommand_Command_20 @"20"
/**
 * 21	获取外部地址
 */
#define FAFAUdpCommand_Command_21 @"21"
//---------p2p流代理-------------

//---------上传与下载文-------------
/**
 * 30	申请上传文件
 */
#define FAFAUdpCommand_Command_30 @"30"
/**
 * 31	上传文件内容
 */
#define FAFAUdpCommand_Command_31 @"31"
/**
 * 32	上传完毕
 */
#define FAFAUdpCommand_Command_32 @"32"
/**
 * 33	申请下载文件
 */
#define FAFAUdpCommand_Command_33 @"33"
/**
 * 34	下载文件内容
 */
#define FAFAUdpCommand_Command_34 @"34"
/**
 * 35	下载完毕
 */
#define FAFAUdpCommand_Command_35 @"35"
//---------上传与下载文-------------

@interface FAFAUdpClient : NSObject
{    
    dispatch_queue_t fafaudpGCDAsyncSocketQueue;
    
    GCDAsyncUdpSocket *ucListen;
    
    // 线程间信号量
    ManualResetEvent* mreRecv;
    ManualResetEvent* mreProcData;
    ManualResetEvent* mreSend;
    
    // 接收数据队列
    NSMutableQueue* qRecvData;
    NSMutableQueue* qSendData;
        
    ManualResetEvent* mreSTUN;
    BOOL isFAFAUdpClientConnected;
    ManualResetEvent* mreTestFAFAUdpClientConnected;
    NSString *TestConnectedData;
}

/// <summary>
/// 默认侦听端口
/// </summary>
@property (nonatomic, assign) int ListenPort;
/// <summary>
/// 数据处理函数，在服务初始化需要加入处理函数
/// </summary>
@property (nonatomic, retain) NSMutableDictionary *htProcFunc;
/// <summary>
/// 无效包处理事件
/// </summary>
@property (nonatomic, retain) FUProcFuncHandleListener *InvaildPackge;

-(void)Send:(FUDPData *)udpData;
-(void) AddProcFunc:(NSString *) cmd ProcFuncHandleListener:(FUProcFuncHandleListener *) pfh;
-(void) DelProcFunc:(NSString *) cmd ProcFuncHandleListener:(FUProcFuncHandleListener *) pfh;

@property (nonatomic, strong) NSString *ExternalIP;
@property (nonatomic, assign) int ExternalPort;

-(void) RefreshExternalIPAndPort:(NSString *) Server Port:(int) Port;
-(BOOL) TestFAFAUdpClientConnected:(NSString *)host Port:(int) port;

@end

extern FAFAUdpClient *g_fafaUdpClient;

