//
//  ASIDownload.m
//  Wefafa
//
//  Created by mac on 13-12-3.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "ASIDownload.h"
#import "ASIHTTPRequest.h"

static ASINetworkQueue *netWorkQueue=nil;

@implementation ASIDownload

+(ASINetworkQueue*)downloadNetworkQueue
{
    //////////////////////////////
    //ASINetworkQueue是NSOperationQueue子类，
    //iPhone 提供了 NSOperation 接口进行任务对象的封装，而通过将任务对象加入到 NSOperationQueue 队列.
    //NSOperationQueue 队列会分配线程进行任务对象的执行.
    if (netWorkQueue==nil)
    {
        netWorkQueue  = [[ASINetworkQueue alloc] init];
        [netWorkQueue reset];
        [netWorkQueue setShowAccurateProgress:YES];
        [netWorkQueue go];
    }
    return netWorkQueue;
}

- (id)init
{
    self = [super init];
    if (self) {
        [ASIDownload downloadNetworkQueue];
    }
    return self;
}

-(void)download:(NSString *)fileUrl savePath:(NSString *)savePath tempPath:(NSString *)tempPath fileID:(NSString *)fileID
{
    //初始下载路径
	NSURL *url = [NSURL URLWithString:fileUrl];
	//设置下载路径
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
	//设置ASIHTTPRequest代理
	request.delegate = _request_delegate;
	//设置文件保存路径
	[request setDownloadDestinationPath:savePath];
	//设置临时文件路径
	[request setTemporaryFileDownloadPath:tempPath];
	//设置进度条的代理,
    if (_downloadProgress)
        [request setDownloadProgressDelegate:_downloadProgress];
	//设置是是否支持断点下载
	[request setAllowResumeForFileDownloads:YES];
	//设置基本信息
	[request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:_request_delegate,@"request_delegate",fileID,@"fileID",_userparam,@"userparam",nil]];
	//添加到ASINetworkQueue队列去下载
	[netWorkQueue addOperation:request];
}
- (void)pause:(NSString *)fileID {//暂停下载
	
	for (ASIHTTPRequest *request in [netWorkQueue operations]) {//查找暂停的对象
		
		NSString * pauseFileID = [request.userInfo objectForKey:@"fileID"] ;//查看userinfo信息
		if ([fileID isEqualToString: pauseFileID]) {//判断ID是否匹配
			//暂停匹配对象
			[request clearDelegatesAndCancel];
		}
	}
}
//#pragma mark -
//#pragma mark ASIHTTPRequestDelegate method
//
////ASIHTTPRequestDelegate,下载之前获取信息的方法,主要获取下载内容的大小
//- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
//    
////	//NSLog(@"didReceiveResponseHeaders-%@",[responseHeaders valueForKey:@"Content-Length"]);
////	for (MyBookView *temp in [self.view subviews]) {//循环出具体对象
////		
////		if (temp.bookID == [[request.userInfo objectForKey:@"bookID"] intValue]) {
////			//查找以前是否保存过 具体对象 内容的大小
////			NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
////			float tempConLen = [[userDefaults objectForKey:[NSString stringWithFormat:@"book_%d_contentLength",temp.bookID]] floatValue];
////			
////			if (tempConLen == 0 ) {//如果没有保存,则持久化他的内容大小
////				
////				[userDefaults setObject:[NSNumber numberWithFloat:request.contentLength/1024.0/1024.0] forKey:[NSString stringWithFormat:@"book_%d_contentLength",temp.bookID]];
////			}
////		}
////	}
//    if (_request_delegate && [_request_delegate respondsToSelector:@selector(request:didReceiveResponseHeaders:)])
//    {
//        [_request_delegate request:request didReceiveResponseHeaders:responseHeaders];
//    }
//}
////ASIHTTPRequestDelegate,下载完成时,执行的方法
//- (void)requestFinished:(ASIHTTPRequest *)request {
//    
////	for (MyBookView *temp in [self.view subviews]) {//循环出具体对象
////		
////		if ([temp respondsToSelector:@selector(bookID)]) {
////			
////			if (temp.bookID == [[request.userInfo objectForKey:@"bookID"] intValue]) {//判断是否与下载完成的对象匹配
////				
////				temp.downloadCompleteStatus = YES;//如果匹配,则设置他的下载状态为YES
////				
////				//重绘
////				[temp setNeedsDisplay];
////			}
////		}
////	}
//    if (_request_delegate && [_request_delegate respondsToSelector:@selector(requestFinished:)])
//    {
//        [_request_delegate requestFinished:request];
//    }
//}
////ASIHTTPRequestDelegate,下载失败
//- (void)requestFailed:(ASIHTTPRequest *)request {
//    
////	NSLog(@"down fail.....");
////	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(300, 220, 200, 100)];
////	label.text = @"down fail,请检查网络是否连接!";
////	[self.view addSubview:label];
//    if (_request_delegate && [_request_delegate respondsToSelector:@selector(requestFailed:)])
//    {
//        [_request_delegate requestFailed:request];
//    }
//}

@end
