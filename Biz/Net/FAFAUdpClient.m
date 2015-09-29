//
//  FAFAUdpClient.m
//  Wefafa
//
//  Created by fafa  on 13-10-14.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "FAFAUdpClient.h"
#import "InetAddress.h"

FAFAUdpClient *g_fafaUdpClient;

@implementation FUdpPackageData

-(id)init
{
    if (self = [super init])
    {
        _Data = [[NSMutableData alloc] initWithCapacity:256];
    }
    return self;
}

-(void)dealloc { 
}

@end

@implementation FUDPData

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void)dealloc { 
}

@end

@implementation FUProcFuncHandleListener

#if __has_feature(objc_arc_weak)
-(id)initWithTarget:(__weak id)target withSEL:(SEL)sel;
#else
-(id)initWithTarget:(__unsafe_unretained id)target withSEL:(SEL)sel;
#endif
{
    if (self = [super init])
    {
        _target = target;
        _sel = sel;
    }
    return self;
    
}

-(void)dealloc
{
}

#if __has_feature(objc_arc_weak)
+(id)listenerWithTarget:(__weak id)target withSEL:(SEL)sel;
#else
+(id)listenerWithTarget:(__unsafe_unretained id)target withSEL:(SEL)sel;
#endif
{
    return [[self alloc] initWithTarget:target withSEL:sel];
}

-(FUdpPackageData*)onEvent:(id)sender data:(FUdpPackageData*)data
{
    FUdpPackageData *re = nil;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    re = [_target performSelector:_sel withObject:sender withObject:data];
#pragma clang diagnostic pop
    
    return re;
}

@end

@implementation FAFAUdpClient

-(id)init
{
    if (self = [super init])
    {
        fafaudpGCDAsyncSocketQueue = dispatch_queue_create("fafaudpGCDAsyncSocketQueue", NULL);
        
        //修改语音连接端口问题
        _ListenPort = 14478 + (int)(arc4random() % 10);
        
        // 线程间信号量
        mreRecv = [[ManualResetEvent alloc] init];
        mreProcData = [[ManualResetEvent alloc] init];
        mreSend = [[ManualResetEvent alloc] init];
        
        // 接收数据队列
        qRecvData = [[NSMutableQueue alloc] init];
        qSendData = [[NSMutableQueue alloc] init];
        
        /**
         * 数据处理函数，在服务初始化需要加入处理函数
         */
        _htProcFunc = [[NSMutableDictionary alloc] init];
        
        mreSTUN = [[ManualResetEvent alloc] init];
        isFAFAUdpClientConnected = NO;
        mreTestFAFAUdpClientConnected = [[ManualResetEvent alloc] init];
        TestConnectedData = @"000000";
        
        FUProcFuncHandleListener* pfh_11 = [FUProcFuncHandleListener listenerWithTarget:self withSEL:@selector(OnProcFunc_11_Sender:PackageData:)];
        [self AddProcFunc:FAFAUdpCommand_Command_11 ProcFuncHandleListener:pfh_11];
        
        [self startThread];
        
#if TARGET_OS_IPHONE
		[[NSNotificationCenter defaultCenter] addObserver:self
		                                         selector:@selector(applicationWillEnterForeground:)
		                                             name:UIApplicationWillEnterForegroundNotification
		                                           object:nil];
#endif
    }
    return self;
}

-(void)dealloc {
#if TARGET_OS_IPHONE
	[[NSNotificationCenter defaultCenter] removeObserver:self];
#endif
#if !OS_OBJECT_USE_OBJC
	dispatch_release(fafaudpGCDAsyncSocketQueue);
#endif
}

- (void)startThread
{
    NSThread *listenThread = [[NSThread alloc] initWithTarget:self selector:@selector(Listen) object:nil];
    [listenThread setName:@"FAFAUdpClient侦听线程"];
    [listenThread start]; 
    
    NSThread *procThread = [[NSThread alloc] initWithTarget:self selector:@selector(ProcessData) object:nil];
    [procThread setName:@"FAFAUdpClient数据处理线程"];
    [procThread start]; 
    
    NSThread *sendThread = [[NSThread alloc] initWithTarget:self selector:@selector(SendData) object:nil];
    [sendThread setName:@"FAFAUdpClient数据发送线程"];
    [sendThread start]; 
}

-(void)Listen
{@autoreleasepool {
    NSError *err = nil;
    @try {
        ucListen = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:fafaudpGCDAsyncSocketQueue];
        if (![ucListen bindToPort:_ListenPort error:&err])
        {
            [ucListen bindToPort:0 error:&err];
            _ListenPort = ucListen.localPort;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        
    }
    
    err = nil;
    if (![ucListen beginReceiving:&err])
    {
        NSLog(@"%@", err);
    }
    
}}

-(void)ProcessData
{@autoreleasepool {
    
    FUDPData *udpData = nil;
    while (true)
    {@autoreleasepool {
        @try
        {
            udpData = nil;
            
            if ([qRecvData count] > 0) udpData = [qRecvData Dequeue];
            else [mreProcData reset];
            
            if (udpData == nil)
            {
                [mreProcData waitOne];
            }
            else
            {
                //若包有效
                NSMutableArray *alProc;
                if (udpData.PkgData.Command != nil && udpData.PkgData.Command.length>0 && (alProc=[_htProcFunc objectForKey:udpData.PkgData.Command])!=nil)
                {
                    for (FUProcFuncHandleListener* pfh in alProc)
                    {
                        FUdpPackageData *pkgData = [pfh onEvent:nil data:udpData.PkgData];
                        if (pkgData != nil)
                        {
                            udpData.PkgData = pkgData;
                            [self Send:udpData];
                        }
                    }
                }
                else
                {
                    //如果包无效，则调用无效包处理事件
                    if (_InvaildPackge != nil)
                    {
                        FUdpPackageData *pkgData = [_InvaildPackge onEvent:nil data: udpData.PkgData];
                        if (pkgData != nil)
                        {
                            udpData.PkgData = pkgData;
                            [self Send:udpData];
                        }
                    }
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        } 
    }}
}}

-(void)Send:(FUDPData *)udpData
{
    [qSendData Enqueue:udpData];
    [mreSend set];
}

-(void)SendData
{@autoreleasepool {    
    NSMutableData *senddata = [[NSMutableData alloc] initWithCapacity:6];
    FUDPData *udpData = nil;
    while (true)
    {@autoreleasepool {
        @try
        {
            udpData = nil;
            
            if ([qSendData count] > 0) udpData = [qSendData Dequeue];
            else [mreSend reset];
            
            if (udpData == nil)
            {
                [mreSend waitOne];
            }
            else
            {
                //如果命令有效，则组包，否则直接发送
                if (udpData.PkgData.Command != nil)
                {
                    [senddata setLength:0];
                    [senddata appendBytes:[udpData.PkgData.Command UTF8String] length:2];
                    int32_t len = htonl(udpData.PkgData.Data.length);
                    [senddata appendBytes:&len length:4];
                    [senddata appendData:udpData.PkgData.Data];
                    if (udpData.PkgData.IPRemote)
                        [ucListen sendData:senddata toAddress:udpData.PkgData.IPRemote withTimeout:10 tag:1];
                    else
                        [ucListen sendData:senddata toHost:udpData.PkgData.IPRemoteHost port:udpData.PkgData.IPRemotePort withTimeout:10 tag:1];
                }
                else
                {
                    if (udpData.PkgData.IPRemote)
                        [ucListen sendData:udpData.PkgData.Data toAddress:udpData.PkgData.IPRemote withTimeout:10 tag:1];
                    else
                        [ucListen sendData:udpData.PkgData.Data toHost:udpData.PkgData.IPRemoteHost port:udpData.PkgData.IPRemotePort withTimeout:10 tag:1];
                }
            }
        }
        @catch (NSException *ex)
        {
            NSLog(@"%@", ex);
        }
    }}
}}

/**
 * 加入cmd对应的处理函数
 * @param cmd
 * @param pfh
 */
-(void) AddProcFunc:(NSString *) cmd ProcFuncHandleListener:(FUProcFuncHandleListener *) pfh
{
    NSMutableArray* alProc;
    if ((alProc=_htProcFunc[cmd])==nil)
    {
        alProc = [[NSMutableArray alloc] initWithCapacity:10];
        _htProcFunc[cmd] = alProc;
    }
    
    [alProc addObject:pfh];
}

/**
 * 删除cmd对应的处理函数
 * @param cmd
 * @param pfh
 */
-(void) DelProcFunc:(NSString *) cmd ProcFuncHandleListener:(FUProcFuncHandleListener *) pfh
{
    NSMutableArray* alProc;
    if ((alProc=[_htProcFunc objectForKey:cmd])==nil) return;
    [alProc removeObject:pfh];
}

/**
 * 访问ejabber p2p代理服务，以取得最新IP和端口存放于ExternalIP、ExternalPort属性中
 * @param Server
 * @param Port
 * @throws Exception
 */
-(void) RefreshExternalIPAndPort:(NSString *) Server Port:(int) Port
{
    [mreSTUN reset];
    
    //加入事件处理
    FUProcFuncHandleListener* pfh_21 = [FUProcFuncHandleListener listenerWithTarget:self withSEL:@selector(OnProcFunc_21:Data:)];
    [self AddProcFunc:FAFAUdpCommand_Command_21 ProcFuncHandleListener:pfh_21];
    
    //设置默认值
    _ExternalPort = _ListenPort;
    _ExternalIP = [InetAddress getLocalHost];
    
    FUDPData *udpData = [[FUDPData alloc] init];
    FUdpPackageData *tmpPkt = [[FUdpPackageData alloc] init];
    udpData.PkgData=tmpPkt;
    udpData.PkgData.Command=FAFAUdpCommand_Command_21;
    udpData.PkgData.Data.length = 0;
    udpData.PkgData.PackageLen=0;
    udpData.PkgData.IPRemote = nil;
    udpData.PkgData.IPRemoteHost = Server;
    udpData.PkgData.IPRemotePort = Port;
    
    [self Send:udpData];
    [self Send:udpData];
    [self Send:udpData];
        
    //等待收到ejabber服务返回数据，10秒超时
    [mreSTUN waitOne:10 * 1000 ];
    [self DelProcFunc:FAFAUdpCommand_Command_21 ProcFuncHandleListener:pfh_21];
}

-(FUdpPackageData*) OnProcFunc_21:(NSObject *) sender Data:(FUdpPackageData *) data
{
    @try
    {
        if (data == nil || data.Data == nil) return nil;
        
        NSString* s = [NSString stringWithUTF8String:(const char*)[data.Data bytes]];
        NSArray *ss = [s componentsSeparatedByString:@"|"];
        if ([ss count] < 2) return nil;
        
        _ExternalPort = [[ss objectAtIndex:1] intValue];
        _ExternalIP = [ss objectAtIndex:0];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@", e);
    }
    
    [mreSTUN set];
    
    return nil;
}

//-------测试对方fafaudp方式是否可连--------
//连接测试内部类
-(FUdpPackageData *)OnProcFunc_11_Sender:(NSObject *)sender PackageData:(FUdpPackageData *)data
{
    NSString *sdata = [NSString stringWithUTF8String:(const char*)[data.Data bytes]];
    
    if (sdata == nil || sdata.length == 0) return nil;
    if ([sdata characterAtIndex:0] != '0') return nil; //不是请求
    
    //直接返回
    [data.Data setLength:0];
    [data.Data appendData:[[NSString stringWithFormat:@"1|%@", [sdata substringToIndex:2]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
}

-(BOOL) TestFAFAUdpClientConnected:(NSString *)host Port:(int) port
{
    //同步，并加入处理函数
    isFAFAUdpClientConnected = NO;
    [mreTestFAFAUdpClientConnected reset];
    
    FUProcFuncHandleListener* pfh_11 = [FUProcFuncHandleListener listenerWithTarget:self withSEL:@selector(OnProcFunc_11_Receiver:PackageData:)];
    [self AddProcFunc:FAFAUdpCommand_Command_11 ProcFuncHandleListener:pfh_11];
    
    FUDPData *udpData = [[FUDPData alloc] init];
    FUdpPackageData *tmppkgdata=[[FUdpPackageData alloc] init];
    udpData.PkgData = tmppkgdata;
    tmppkgdata.IPRemoteHost = host;
    tmppkgdata.IPRemotePort = port;
    
    tmppkgdata.Command = FAFAUdpCommand_Command_11;
    [tmppkgdata.Data setLength:0];
    [tmppkgdata.Data appendData:[[NSString stringWithFormat:@"0|%@", TestConnectedData] dataUsingEncoding:NSUTF8StringEncoding]];
    [self Send:udpData]; 
    
    //等待收到返回数据，1秒超时
    [mreTestFAFAUdpClientConnected waitOne:1 * 1000];
    [self DelProcFunc:FAFAUdpCommand_Command_11 ProcFuncHandleListener:pfh_11]; 
    return isFAFAUdpClientConnected;
}

-(FUdpPackageData *) OnProcFunc_11_Receiver:(NSObject *) sender PackageData:(FUdpPackageData*) data
{
    //判断是否当前sid
    NSString *s1=[NSString stringWithFormat:@"1|%@", TestConnectedData];
    NSString *s2=[[NSString alloc] initWithData:data.Data encoding:NSUTF8StringEncoding];
    if ([s1 isEqualToString:(s2)])
    {
        isFAFAUdpClientConnected = YES;
        [mreTestFAFAUdpClientConnected set];
    } 
    return nil;
}

#pragma mark application Delegate

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    if (ucListen.isClosed)
    {
        NSThread *listenThread = [[NSThread alloc] initWithTarget:self selector:@selector(Listen) object:nil];
        [listenThread setName:@"FAFAUdpClient侦听线程"];
        [listenThread start];    
    }
}

#pragma mark GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{@autoreleasepool {
    // 如果无数据，则丢弃
    if (data.length == 0)return;
    
    Byte *bytesData = (Byte*)data.bytes;
    
    // 如果包长不正确，则按无效包进行处理
    FUdpPackageData *pkgData = [[FUdpPackageData alloc] init];
    pkgData.IPRemote = address;
    if (data.length >= 6 && (pkgData.PackageLen = ntohl(*(int32_t*)(bytesData+2))) == data.length - 6)
    {
        //有效包，按包格式进行初步解析
        pkgData.Command = [[NSString alloc ] initWithBytes:bytesData length:2 encoding:NSUTF8StringEncoding];
        [pkgData.Data setLength:0];
        [pkgData.Data appendBytes:bytesData+6 length:pkgData.PackageLen];
    }
    else
    {
        //无效包，包的Data直接存储接收到的数据，不做解析
        pkgData.Command = @"";
        [pkgData.Data setLength:0];
        [pkgData.Data appendData:data];
    }
    
    FUDPData *udpData = [[FUDPData alloc] init];
    udpData.UDPListen = ucListen;
    udpData.PkgData = pkgData;
    
    [qRecvData Enqueue:udpData];
    [mreProcData set];
}}

@end
