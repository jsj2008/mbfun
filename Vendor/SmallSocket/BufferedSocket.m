//
// BufferedSocket.m
// BufferedSocket
//
// Created by Rainer Kupke (rkupke@gmx.de) on Thu Jul 26 2001.
// Copyright (c) 2001 Rainer Kupke.
//
// Additional modifications by Steven Frank (stevenf@panic.com)
//
// This software is provided 'as-is', without any express or implied 
// warranty. In no event will the authors be held liable for any damages 
// arising from the use of this software.
//
// Permission is granted to anyone to use this software for any purpose, 
// including commercial applications, and to alter it and redistribute it 
// freely, subject to the following restrictions:
//
//     1. The origin of this software must not be misrepresented; you must 
//        not claim that you wrote the original software. If you use this 
//        software in a product, an acknowledgment in the product 
//        documentation (and/or about box) would be appreciated but is not 
//        required.
//
//     2. Altered source versions must be plainly marked as such, and must
//        not be misrepresented as being the original software.
//
//     3. This notice may not be removed or altered from any source 
//        distribution.
//        

#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>

#import "BufferedSocket.h"
#import "MutableData+Extension.h"

@implementation BufferedSocket


+ (BufferedSocket*)bufferedSocket
//
// Convenience constructor
//
{
    return [[[BufferedSocket alloc] init] autorelease];
}


- (id)init
//
// Designated initializer
//
{
    self=[super init];
    if ( !self )
		return nil;
    connectTimeout = 10; // 10 seconds is default
		
    buffer = [[NSMutableData alloc] init];
    return self;
}


- (id)initWithFD:(int)fd remoteAddress:(struct sockaddr_in*)remoteAddress 
//
// Private initializer, do not use
//
{
    self=[super initWithFD:fd remoteAddress:remoteAddress];
	if ( !self )
		return nil;

    buffer = [[NSMutableData alloc] init];
    return self;
}


- (void) dealloc
//
// Destructor, do not call.  Use -release instead
//
{
    [buffer release];
    [super dealloc];
}


- (BufferedSocket*)acceptConnectionAndKeepListening
//
// This works exactly like the method of the same name in the Socket
// class, but is modified to return a BufferedSocket instead of a plain
// Socket
//
{
    struct sockaddr_in acceptAddr;
    int socketfd2 = SOCKET_INVALID_DESCRIPTOR;
    int addrSize = sizeof(acceptAddr);
  
    // Socket must be created, not connected, and listening
    
    if ( socketfd == SOCKET_INVALID_DESCRIPTOR )
        [NSException raise:SOCKET_EX_BAD_SOCKET_DESCRIPTOR 
                        format:SOCKET_EX_BAD_SOCKET_DESCRIPTOR];

    if ( connected )
        [NSException raise:SOCKET_EX_ALREADY_CONNECTED 
                        format:SOCKET_EX_ALREADY_CONNECTED];

    if ( !listening )
        [NSException raise:SOCKET_EX_NOT_LISTENING 
                        format:SOCKET_EX_NOT_LISTENING];
   
    // Accept a remote connection.  Raise on failure
    
    socketfd2 = accept(socketfd, (struct sockaddr*)&acceptAddr, (socklen_t *)&addrSize);
    
    if ( socketfd2 < 0 )
        [NSException raise:SOCKET_EX_ACCEPT_FAILED 
                    format:SOCKET_EX_ACCEPT_FAILED_F, strerror(errno)];
    
    return [[[BufferedSocket alloc] initWithFD:socketfd2 
					remoteAddress:&acceptAddr] autorelease];
}

-(long) getConnectTimeout
{
    return connectTimeout;
}

-(void)setConnectTimeout:(long )connectTimeout_v
{
    struct timeval timeo = {3, 0};
    timeo.tv_sec=connectTimeout;
    timeo.tv_usec=0;
    setsockopt(socketfd, SOL_SOCKET, SO_SNDTIMEO, &timeo, sizeof(timeo));
    
    connectTimeout = connectTimeout_v;
}
-(BOOL)isTimeOut
{
    if (errno != EINPROGRESS) {
        return NO;
    }
    return YES;
}


-(void)setTimeReceiveOut:(long)recieveTimeOut
{
    struct timeval timeo = {3, 0};
    timeo.tv_sec=recieveTimeOut;
    timeo.tv_usec=0;
    setsockopt(socketfd, SOL_SOCKET, SO_RCVTIMEO, &timeo, sizeof(timeo));
}

- (NSMutableData*)readData:(int)n
{
    if ( socketfd == SOCKET_INVALID_DESCRIPTOR )
        [NSException raise:SOCKET_EX_BAD_SOCKET_DESCRIPTOR 
                    format:SOCKET_EX_BAD_SOCKET_DESCRIPTOR];
    
    if ( !connected )
        [NSException raise:SOCKET_EX_NOT_CONNECTED 
                    format:SOCKET_EX_NOT_CONNECTED];
    
    // Request a read of as much as we can.  Should return immediately if no data.
    int count=0;
    Byte *readBuffer1 = malloc(n);
    [buffer setLength:0];
    while ( count < n )
    {
        int len= recv(socketfd, readBuffer1, n-count, 0);
        if ( len > 0 )
        {
            // Got some data, append it to user's buffer
            
            [buffer appendBytes:readBuffer1 length:len];
        }
        else if ( len == 0 )
        {
            // Other side has disconnected, so close down our socket
            break;
        }
        else if ( len < 0 )
        {
            // recv() returned an error. 
            
            if ( errno == EAGAIN )
            {
                // No data available to read (and socket is non-blocking)
                count = 0;
            }
            else
                [NSException raise:SOCKET_EX_RECV_FAILED 
                            format:SOCKET_EX_RECV_FAILED_F, strerror(errno)];
        }
        count+=len;
    }
    
    free(readBuffer1);
    return [buffer getBytes:count];
}

- (NSMutableData*)readDataUpToData:(NSData*)d
{
    while ( ![buffer containsData:d] )
    {
        int len;
        len = [super readData:buffer];
		
        if ( len == 0 ) 
			return nil; // socket closed or nonblocking socket && not enough data   
    }
    
    return [buffer getBytesUpToData:d];
}


- (NSMutableData*)readDataUpToString:(NSString*)s
{
    return [self readDataUpToData:[s dataUsingEncoding:NSUTF8StringEncoding]];
}


@end
