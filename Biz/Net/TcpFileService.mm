//
//  TcpFileService.m
//  Wefafa
//
//  Created by fafa  on 13-9-5.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "TcpFileService.h"
#import "Hash.h"
#import "Utils.h"
#import "WeFaFaGet.h"
#import "AppSetting.h"

@implementation TcpFileService

-(id) initWithServer:(NSString *)server Port:(int)port
{
    self=[super init];
    if ( !self )
		return nil;
    
    _onComplete = [[CommonEventHandler alloc] init];
    _onFailed = [[CommonEventHandler alloc] init];
    _onProgress = [[CommonEventHandler alloc] init];
    
    isCancel = false;
    PackageIsSend = false;
    FileSizeOnServer = 0;
    RcvOffSet = 0;
    SendTokenString = @"";
    RcvTokenString = @"";
    
    
    IPServer_Address=[[NSString alloc] initWithFormat:@"%@",server];
    IPServer_Port=port;
    BUFFERSIZE = 1024;
    
    return self;
}

- (void)dealloc
{  
}

/**
 * 上传文件
 * @param FilePath
 */
-(void) UploadFile:(NSString *) FilePath
{
    NSThread *uploadThread = [[NSThread alloc] initWithTarget:self selector:@selector(UploadFileThread:) object:FilePath];
    [uploadThread setName:@"TcpFileServiceUploadThread"];
    [uploadThread start];
}

+ (unsigned long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

-(void) UploadFileThread:(NSObject *) Data
{
    @autoreleasepool {    
        NSString* FilePath = (NSString *)Data;
        NSArray* arr_filepath = [FilePath componentsSeparatedByString:@"/"];
        NSString* FileName = [arr_filepath objectAtIndex:[arr_filepath count]-1];
        FILE *fp=NULL;
        @try
        {
            Byte * buffer = new Byte[BUFFERSIZE];
            TcpPackageData *pkgData;
            
            //连接到服务器
            tcpClient = [[BufferedSocket alloc] init];
            [tcpClient connectToHostName:IPServer_Address port:IPServer_Port];
            
            
            NSString *FileHashValue = [Hash fileMD5:FilePath];
            
//            NSDictionary *dict=@{@"type":@"CHAT",
//                                 @"to":_toJid,
//                                 @"filename":fileName,
//                                 @"hashvalue":fileName,
//                                 @"filedata":filedata};
//            
//            returnDic =  [sns sendePic:nil withValue:dict withFileName:nil];

            NSString *tmpstr22=[NSString stringWithFormat:@"文件%@发送完毕",FileName];
            [_onComplete fire:nil eventData:@[tmpstr22, FileHashValue, FileName]];
            return;
            
            //打开文件
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath=[paths objectAtIndex:0];
            NSString *filePath2 = [documentPath stringByAppendingPathComponent:FilePath];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath2] )
            {
            }
            
            //        NSData* fileData = [NSData dataWithContentsOfFile:FilePath];
            // 注意 这里用文件长度不应该用int 不要强制转换
            int fileLength=[TcpFileService fileSizeAtPath:FilePath];
            //申请上传
            pkgData = [[TcpPackageData alloc] init];
            pkgData.Command = [[NSString alloc ] initWithFormat:@"%@",FAFATcpCommand_Command_40];
            NSString *strdata = [[NSString alloc ] initWithFormat:@"%@|%d|%@", FileHashValue, fileLength, FileName];
            NSData *aData = [strdata dataUsingEncoding: NSUTF8StringEncoding];
            pkgData.Data=(Byte *)[aData bytes];
            pkgData.PackageLen=[aData length];
            [self setUploadFileHashValue:FileHashValue];
            [self SendTCPData:tcpClient PackageData:pkgData];
            FileSizeOnServer = 0;
//            [pkgData.Command release];
//            [strdata release];
//            [pkgData release];
            
            pkgData = [[TcpPackageData alloc] init];
            if ([self ReadTCPData:tcpClient PackageData:pkgData]==YES)
            {
                NSData *adata=[[NSData alloc ]initWithBytes:pkgData.Data length:pkgData.PackageLen];
                NSString* s = [[NSString alloc] initWithData:adata encoding:NSUTF8StringEncoding];
                NSArray *ss = [s componentsSeparatedByString:@"|"];
                if ([ss count] >= 2)
                {
                    @try
                    {
                        FileSizeOnServer = [[ss objectAtIndex:1] intValue];
                    }
                    @catch (NSException *e)
                    {
                    }
                }
//                [adata release];
//                [s release];
            }
            else
            {
                NSLog(@"读取超时！");
            }
//            [pkgData release];
                         
            //上传内容write:ab+, read:rb
            fp =fopen([FilePath UTF8String],"rb");
            if (FileSizeOnServer > 0 && FileSizeOnServer <= fileLength) fseek(fp,FileSizeOnServer,SEEK_SET);
            long offset = (FileSizeOnServer == 0 ? 0 : FileSizeOnServer - 1);//fs.Position;
            
            [_onProgress fire:nil eventData:@[@(offset)]];             
            
            int len = fread(buffer, 1, BUFFERSIZE, fp);
            while (len > 0)
            {
                if (isCancel) break;
                
                NSString *strdata = [NSString stringWithFormat:@"%@|%ld|", FileHashValue, offset];
                NSData *aData = [strdata dataUsingEncoding: NSUTF8StringEncoding];
                Byte * DataPre=(Byte *)[aData bytes];
                pkgData = [[TcpPackageData alloc] init];
                pkgData.Command = [[NSString alloc] initWithFormat:@"%@",FAFATcpCommand_Command_41];
                pkgData.Data = new Byte[[strdata length] + len];
                pkgData.PackageLen=[strdata length] + len;
                memcpy(pkgData.Data, DataPre,[strdata length]);
                memcpy(pkgData.Data+[strdata length], buffer, len);
                [self SendTCPData:tcpClient PackageData:pkgData];
                 
                [_onProgress fire:nil eventData:@[@(len)]]; 
                
                offset += len;
                
                len = fread(buffer, 1, BUFFERSIZE, fp);
//                [pkgData.Command release];
                delete pkgData.Data;
//                [pkgData release];
            }
            delete buffer;
            
            //上传完毕
            pkgData = [[TcpPackageData alloc] init];
            pkgData.Command = [[NSString alloc] initWithFormat:@"%@",FAFATcpCommand_Command_42];
            NSString *strdata2 = [[NSString alloc] initWithFormat:@"%@|%d", FileHashValue, fileLength];
            NSData *aData2 = [strdata2 dataUsingEncoding: NSUTF8StringEncoding];
            pkgData.Data=(Byte *)[aData2 bytes];
            pkgData.PackageLen=[aData2 length];
            [self SendTCPData:tcpClient PackageData:pkgData];
//            [pkgData.Command release];
//            [strdata2 release];
//            [pkgData release];
            FileSizeOnServer = 0;
            
            pkgData=[[TcpPackageData alloc] init];
            if ([self ReadTCPData:tcpClient PackageData:pkgData]==YES)
            {
                NSData *adata=[[NSData alloc ]initWithBytes:pkgData.Data length:pkgData.PackageLen];
                NSString* s = [[NSString alloc] initWithData:adata encoding:NSUTF8StringEncoding];
                NSArray *ss = [s componentsSeparatedByString:@"|"];
                if ([ss count] >= 2)
                {
                    @try
                    {
                        FileSizeOnServer = [[ss objectAtIndex:1] intValue];
                    }
                    @catch (NSException *e)
                    {
                    }
                }
//                [adata release];
//                [s release];
            }
            else
            {
                NSLog(@"读取超时！");
            }
            fclose(fp);
            fp=NULL;
//            [pkgData release];
            
            
            //        if (!isCancel) OnComplete.fire(new Object[]{"文件" + FileName + "发送完毕", FileHashValue, FileName});
            //todo
            NSLog(@"发送完毕");
            /*
            NSString *tmpstr22=[NSString stringWithFormat:@"文件%@发送完毕",FileName];
            [_onComplete fire:nil eventData:@[tmpstr22, FileHashValue, FileName]];
             */
        }
        @catch (NSException *e)
        {
            //        OnFailed.fire(new Object[]{"文件" + FileName + "发送失败", ex, null});
            //todo
            NSString *tmpstr=[NSString stringWithFormat:@"文件%@发送失败",FileName];
            [_onFailed fire:nil eventData:@[tmpstr, e, NSNull.null]];
        }
        @finally
        {
            @try
            {
                if (fp != NULL) fclose(fp);
                if (tcpClient != nil)
                {
                    [tcpClient close];
//                    [tcpClient release];
                    tcpClient=NULL;
                }
            }
            @catch (NSException *e)
            {
            }
        }
        
    }

}

/**
 * 申请下载离线文件
 * @param FileHashValue
 * @return FileSize
 */
-(unsigned long long) RequestDownloadFile:(NSString *)FileHashValue
{
    TcpPackageData *pkgData;
    BOOL isConnected = (tcpClient != nil && [tcpClient isConnected]==YES);
    
    try
    {
        if (!isConnected)
        {
            tcpClient = [[BufferedSocket alloc] init];
            [tcpClient connectToHostName:IPServer_Address port:IPServer_Port];
        }
        
        pkgData = [[TcpPackageData alloc] init];
        pkgData.Command = [[NSString alloc] initWithFormat:@"%@",FAFATcpCommand_Command_43];
        NSString *strdata = [[NSString alloc] initWithFormat:@"%@", FileHashValue];
        NSData *aData = [strdata dataUsingEncoding: NSUTF8StringEncoding];
        pkgData.Data=(Byte *)[aData bytes];
        pkgData.PackageLen=[aData length];
        [self SendTCPData:tcpClient PackageData:pkgData];
//        [pkgData.Command release];
//        [strdata release];
//        [pkgData release];
        
        FileSizeOnServer = 0;
        pkgData = [[TcpPackageData alloc] init];
        if ([self ReadTCPData:tcpClient PackageData:pkgData]==YES)
        {
            NSData *adata=[[NSData alloc ]initWithBytes:pkgData.Data length:pkgData.PackageLen];
            NSString* s = [[NSString alloc] initWithData:adata encoding:NSUTF8StringEncoding];
            NSArray *ss = [s componentsSeparatedByString:@"|"];
            if ([ss count] >= 2)
            {
                @try
                {
                    FileSizeOnServer = [[ss objectAtIndex:1] longLongValue];
                }
                @catch (NSException *e)
                {
                }
            }
//            [adata release];
//            [s release];
        }
        
        if (!isConnected)
        {
            if (tcpClient != nil)
            {
                [tcpClient close];
//                [tcpClient release];
                tcpClient=NULL;
            }
        }
//        [pkgData release];
    }
    catch (NSException* e)
    {
        //e.printStackTrace();
    }
    
    return FileSizeOnServer;
}

/**
 * 开始下载离线文件
 * @param FileHashValue
 * @param FilePath 存储路径
 */
-(void) StartDownloadFile:(NSString*) FileHashValue FilePath:(NSString*) FilePath
{
    NSArray *arr=[[NSArray alloc] initWithObjects:FileHashValue,FilePath, nil];
    NSThread *uploadThread = [[NSThread alloc] initWithTarget:self selector:@selector(StartDownloadFileThread:) object:arr];
    [uploadThread setName:@"TcpFileServiceDownloadThread"];
    [uploadThread start];
}

-(void) StartDownloadFileThread:(NSObject*) Data
{
    @autoreleasepool {
        NSArray* arr = (NSArray *)Data;
        NSString* FileHashValue = (NSString*)[arr objectAtIndex:0];
        NSString* FilePath = (NSString*)[arr objectAtIndex:1];
        NSArray* arr_filepath = [FilePath componentsSeparatedByString:@"/"];
        NSString* FileName = [arr_filepath objectAtIndex:[arr_filepath count]-1];
        NSLog(@"fileName下载---%@",FileName);
        
        FILE *fp=NULL;
        @try
        {
            TcpPackageData* pkgData;
            
            BOOL isXC = false; // 是否续传
            //if (File.Exists(FilePath))
            {
                //if (System.Windows.Forms.MessageBox.Show("文件已存在！是否续传？", "文件传输", System.Windows.Forms.MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                {
                    isXC = true;
                }
            }
            
            //连接到服务器
            tcpClient = [[BufferedSocket alloc] init];
            [tcpClient connectToHostName:IPServer_Address port:IPServer_Port];
            [self RequestDownloadFile:FileHashValue];
            
            NSString *newfilepath = [NSString stringWithFormat:@"%@/%@",[AppSetting getRecvFilePath], FileName];
            NSData *data=[sns receivePicWithFileName:FileName withFilePathName:nil];
            if (data.length>0) {
                
                NSString *tmpstr22=[NSString stringWithFormat:@"文件%@下载完毕",FileName];
                [_onComplete fire:nil eventData:@[tmpstr22, FileHashValue, FileName]];
//                [Utils createDirectory:filepathss];
                [data writeToFile:newfilepath atomically:NO];
//                接收的时候请求下来存放位置
                UISaveVideoAtPathToSavedPhotosAlbum(newfilepath, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
             
//                NSLog(@"data------%@",data);
  
            }

            return;
            //打开文件
            NSString *path1=[FilePath substringToIndex:[FilePath length]-[FileName length]-1];
            [Utils createDirectory:path1];
            
            int fileLength=[TcpFileService fileSizeAtPath:FilePath];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:FilePath] == NO){
                [[NSFileManager defaultManager] createFileAtPath:FilePath contents:nil attributes:nil];
            }
            fp = fopen([FilePath UTF8String], "ab+");
            if (isXC && fileLength > 0)
                fseek(fp, fileLength - 1,SEEK_SET);
            
            //下载内容
            //        java.util.Date dtOld = new java.util.Date();
            NSDate *dtOld = [NSDate date];//当前时间
            
            long offset = fileLength > 0 ? fileLength - 1 : 0;
             
            [_onProgress fire:nil eventData:@[@(offset)]]; 
            
            int len = 0;
            pkgData = [[TcpPackageData alloc] init];
            pkgData.Command = [[NSString alloc] initWithFormat:@"%@",FAFATcpCommand_Command_44];
            NSString *strdata = [[NSString alloc] initWithFormat:@"%@|%ld", FileHashValue, offset];
            NSData *aData = [strdata dataUsingEncoding: NSUTF8StringEncoding];
            pkgData.Data=(Byte *)[aData bytes];
            pkgData.PackageLen=[aData length];
            [self SendTCPData:tcpClient PackageData:pkgData];
//            [pkgData.Command release];
//            [strdata release];
//            [pkgData release];
            do
            {
                if (isCancel) break;
                
                pkgData = [[TcpPackageData alloc] init];
                if ([self ReadTCPData:tcpClient PackageData:pkgData]==NO) break;
                
                int idxSplit1=[Utils indexOfArray:pkgData.Data Length:pkgData.PackageLen StartPos:0 SplitChar:'|'];
                int idxSplit2=[Utils indexOfArray:pkgData.Data Length:pkgData.PackageLen-idxSplit1-1 StartPos:idxSplit1+1 SplitChar:'|'];
                
                int count = pkgData.PackageLen - idxSplit2 - 1;
                len = 0;
                if (count > 0)
                {
                    len = count;
                    fwrite(pkgData.Data+idxSplit2 + 1, 1, len, fp);
                    
                    [_onProgress fire:nil eventData:@[@(len)]];
                }
                
                NSDate *now=[NSDate date];
                NSTimeInterval time=[now timeIntervalSinceDate:dtOld];
                
//                [pkgData release];
                if ( (time*1000)>3 * 1000)
                {
                    dtOld = [NSDate date];
                    pkgData = [[TcpPackageData alloc] init];
                    pkgData.Command = [[NSString alloc] initWithFormat:@"%@",FAFATcpCommand_Command_99];
                    pkgData.Data=nil;
                    pkgData.PackageLen=0;
                    [self SendTCPData:tcpClient PackageData:pkgData];
//                    [pkgData.Command release];
//                    [pkgData release];
                }
            } while (len > 0);
            
            pkgData = [[TcpPackageData alloc] init];
            pkgData.Command = [[NSString alloc] initWithFormat:@"%@",FAFATcpCommand_Command_45];
            NSString *strdata2 = [[NSString alloc] initWithFormat:@"%@|%d", FileHashValue, fileLength];
            NSData *aData2 = [strdata2 dataUsingEncoding: NSUTF8StringEncoding];
            pkgData.Data=(Byte *)[aData2 bytes];
            pkgData.PackageLen=[aData2 length];
            [self SendTCPData:tcpClient PackageData:pkgData];
//            [pkgData.Command release];
//            [strdata2 release];
//            [pkgData release];
            
            FileSizeOnServer = 0;
            pkgData = [[TcpPackageData alloc] init];
            if ([self ReadTCPData:tcpClient PackageData:pkgData]==YES)
            {
                NSData *adata=[[NSData alloc ]initWithBytes:pkgData.Data length:pkgData.PackageLen];
                NSString* s = [[NSString alloc] initWithData:adata encoding:NSUTF8StringEncoding];
                NSArray *ss = [s componentsSeparatedByString:@"|"];
                if ([ss count] >= 2)
                {
                    @try
                    {
                        FileSizeOnServer = [[ss objectAtIndex:1] intValue];
                    }
                    @catch (NSException *e)
                    {
                    }
                }
//                [adata release];
//                [s release];
            }
//            [pkgData release];
            
            fclose(fp);
            fp=NULL;
            
            //        if (!isCancel) OnComplete.fire(new Object[]{"文件" + FileName + "下载完毕", FileHashValue, FileName});
            //todo
            NSString *tmpstr22=[NSString stringWithFormat:@"文件%@下载完毕",FileName];
            [_onComplete fire:nil eventData:@[tmpstr22, FileHashValue, FileName]];
        }
        @catch (NSException* e)
        {
            NSLog(@">>>TcpFileService:  NSException: %@:%@",e.name,e.reason);
            //        OnFailed.fire(new Object[]{"文件" + FileName + "下载失败", ex, null});
            //todo
            NSString *tmpstr=[NSString stringWithFormat:@"文件%@下载失败",FileName];
            [_onFailed fire:nil eventData:@[tmpstr, e, NSNull.null]];                                  
        }
        @finally
        {
            try
            {
                if (fp != NULL) fclose(fp);
                if (tcpClient != nil)
                {
                    [tcpClient close];
//                    [tcpClient release];
                    tcpClient=NULL;
                }
            }
            catch (NSException* e)
            {
            }
        }
        
    }
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
//    void (^showControls)(void);
//    showControls = ^(void) {
//    };
//    
//    // Show controls
//    [UIView  animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:showControls completion:NULL];
    
}
-(void) EndDownloadFile:(NSString*) FileHashValue FileSize:(long) FileSize
{
}

-(NSString*) getUploadFileHashValue
{
    return uploadFileHashValue;
}

-(void) setUploadFileHashValue:(NSString*) uploadFileHashValue_v
{
    uploadFileHashValue = uploadFileHashValue_v;
    
}

@end
