//
//  TcpService.m
//  Wefafa
//
//  Created by fafa  on 13-9-5.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "TcpService.h"

@implementation TcpService

-(void) SendTCPData:(BufferedSocket *) ns PackageData:(TcpPackageData *) pkgData
{
    @try
    {
        Byte * b = new Byte[pkgData.PackageLen + 6];
        NSData *adata=[pkgData.Command dataUsingEncoding: NSUTF8StringEncoding];
        memcpy(b, [adata bytes], 2);
        
        int length1=htonl(pkgData.PackageLen);
        memcpy(b+2, &length1, 4);
        
        memcpy(b+6, pkgData.Data, pkgData.PackageLen);
        
        
        [ns writeData:b Length:pkgData.PackageLen+6];
        delete b;
    }
    @catch (NSException *e)
    {
        NSLog(@">>>TcpService:  NSException: %@:%@",e.name,e.reason);
    }
}

/**
 * 默认30秒超时
 * @param ns
 * @param pkgData
 * @return
 */
-(BOOL) ReadTCPData:(BufferedSocket *)ns PackageData:(TcpPackageData *)pkgData
{
    return [self ReadTCPData:ns PackageData:pkgData TimeOut:30 * 1000];
}
/**
 *
 * @param ns
 * @param pkgData
 * @param timeout ms
 * @return
 */
-(BOOL) ReadTCPData:(BufferedSocket *)ns PackageData:(TcpPackageData *)pkgData TimeOut:(int) timeout
{
    BOOL re = NO;
    
    @try
    {
        //timeout秒超时
        [ns setTimeReceiveOut:timeout];
        
        NSData *m_Buffer = [ns readData:6];
        Byte* bHead = (Byte *)[m_Buffer bytes];
        
        if ([m_Buffer length] == 6)
        {
            NSData *adata = [[NSData alloc] initWithBytes:bHead length:2];
            pkgData.Command = [[[NSString alloc] initWithData:adata encoding:NSUTF8StringEncoding] autorelease];
            
            int length_host;
            memcpy(&length_host, bHead+2, 4);
            pkgData.PackageLen=ntohl(length_host);
            
            m_Buffer=[ns readData:pkgData.PackageLen];
            pkgData.Data=(Byte *)[m_Buffer bytes];
            if ([m_Buffer length] == pkgData.PackageLen)
                re = true;
            else
                pkgData.PackageLen=[m_Buffer length];
            [adata release];
        }
    }
    @catch (NSException *e)
    {
        NSLog(@">>>TcpService:  NSException: %@:%@",e.name,e.reason);
    }
    
    return re;
}

-(void) SendTCPData:(BufferedSocket *)ns PackageData:(TcpPackageData *)pkgData TimeOut:(int) timeout
{
    @try
    {
        Byte * b = new Byte[pkgData.PackageLen + 6];
        
        NSData *aData = [pkgData.Command dataUsingEncoding: NSUTF8StringEncoding];
        memcpy(b, [aData bytes], 2);
        
        int length1=htonl(pkgData.PackageLen);
        memcpy(b+2, &length1, 4);
        memcpy(b+6, pkgData.Data, pkgData.PackageLen);
        
        while([ns isConnected]==YES)
        {
            [ns writeData:b Length:pkgData.PackageLen + 6 ];
        }
        delete b;
    }
    @catch (NSException * e)
    {
        NSLog(@">>>TcpService:  NSException: %@:%@",e.name,e.reason);
    }
}

@end
