//
//  TcpFileService.h
//  Wefafa
//
//  Created by fafa  on 13-9-5.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "TcpService.h"
#import "CommonEventHandler.h"

@interface TcpFileService : TcpService
{
    int BUFFERSIZE;
    BOOL isCancel;
	/**
	 * 服务器地址
	 */
	NSString* IPServer_Address;
    int IPServer_Port;
	BufferedSocket* tcpClient;
    
    NSString* uploadFileHashValue;
	    
    BOOL PackageIsSend;
    long long FileSizeOnServer;
    Byte * RcvRawData;
    long long RcvOffSet;
    NSString* SendTokenString ;
    NSString* RcvTokenString;
}

/**
 * 完成事件
 * eventData object数组 [消息 string、FileHashValue string、FileName string]
 */
@property (strong, nonatomic) CommonEventHandler *onComplete;
/**
 * 失败事件
 * eventData object数组 [消息 string、Exception、null]
 */
@property (strong, nonatomic) CommonEventHandler *onFailed;
/**
 * 处理进度事件
 * eventData 传输字节 long
 */
@property (strong, nonatomic) CommonEventHandler *onProgress;

+ (unsigned long long) fileSizeAtPath:(NSString*) filePath;

-(id) initWithServer:(NSString *)server Port:(int)port;
-(void) UploadFile:(NSString *) FilePath;
-(unsigned long long) RequestDownloadFile:(NSString *)FileHashValue;
-(void) StartDownloadFile:(NSString*) FileHashValue FilePath:(NSString*) FilePath;

@end
