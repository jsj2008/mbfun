//
//  SChatSocket.m
//  Wefafa
//
//  Created by Ryan on 15/6/9.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//  这个类处理一个简单的长链接聊天服务。
//

#import "SChatSocket.h"
#import "GCDAsyncSocket.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AppSetting.h"


@interface SChatSocket(){
    GCDAsyncSocket *asyncSocket;
    int count;
}

@end

@implementation SChatSocket
__strong static SChatSocket *instance = nil;
+(SChatSocket*)shared{
    if (!instance) {
        instance = [SChatSocket new];
    }
    return instance;
}

#pragma mark - Socket
- (void)initSocket{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    
    [self connect];
}

-(BOOL)connect{
    if (!_token || !_userId) {
        return NO;
    }
    NSError *error = nil;
    if (![asyncSocket connectToHost:MBFUN_CHAT_SERVER onPort:[MBFUN_CHAT_PORT intValue] error:&error])
    {
        NSLog(@"Error connecting: %@", error);
        return NO;
    }
    return YES;
}

-(void)send:(NSDictionary*)info{
    if (!asyncSocket.isConnected) {
        [self connect];
        return;
    }
    
    NSString *json = [self getJSON:info];
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    [asyncSocket writeData:data withTimeout:10 tag:count++];
}

-(void)call:(NSString*)func val:(NSDictionary*)v{
    NSDictionary *info = @{
                           @"f":func,@"v":v
                           };
    [self send:info];
}


#pragma mark - helper
- (NSString*)getJSON:(NSObject*)info
{
    
    if ([NSJSONSerialization isValidJSONObject:info]) {
        NSError* error;
        NSData* registerData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
        //去掉空格和换行符
        NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
        
        NSRange range = {0,jsonString.length};
        
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        
        NSRange range2 = {0,mutStr.length};
        
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
        return mutStr;
    }
    else {
        return nil;
    }
}

- (id)getObject:(NSString*)json
{
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSArray* info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return info;
}

-(void)logout{
    _userId = nil;
    _token = nil;
    [asyncSocket disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
//    NSLog(@"didConnectToHost:%@",host);
    
    [sock readDataWithTimeout:-1 tag:0];
    
    if (_userId && _token) {
        [self call:@"l" val:@{@"userId":_userId,@"token":_token}];
    }
    
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    //    DDLogInfo(@"socketDidSecure:%p", sock);
    //    self.viewController.label.text = @"Connected + Secure";
    
    //    NSString *requestStr = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nHost: %@\r\n\r\n", HOST];
    //    NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    //
    //    [sock writeData:requestData withTimeout:-1 tag:0];
    //    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //    DDLogInfo(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"On Socket Data:%@",str);
    NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
    //TYPE 1:系统 2:用户
    NSDictionary *info = [self getObject:str];
    if ([info[@"f"] isEqualToString:@"onMsg"]) {
        
        UNREAD_ALL_NUMBER++;
        MESS_COUNT++;
        
        if ([AppSetting getMsgTipViber]) {  //1 on nil/0 off
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }if ([AppSetting getMsgTipVoice]) {
            AudioServicesPlaySystemSound(1007);//1007);
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MBFUN_CHAT_MESSAGE_SOCKET" object:nil userInfo:info];
    
    [sock readDataWithTimeout:-1 tag:0];
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    // for test
    
    // reconnect here
    if ([self connect]) {
//        NSLog(@"聊天服务器中断，自动重连中...");
//        [RKDropdownAlert title:@"聊天服务器中断，自动重连中..."];
    }
}
@end
