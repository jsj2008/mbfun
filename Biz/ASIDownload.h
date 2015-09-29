//
//  ASIDownload.h
//  Wefafa
//
//  Created by mac on 13-12-3.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"

//@protocol ASIDownloadDelegate <NSObject>
//
//@optional
//
//- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders ;
//- (void)requestFinished:(ASIHTTPRequest *)request ;
//- (void)requestFailed:(ASIHTTPRequest *)request ;
//
//@end


@interface ASIDownload : NSObject

@property(nonatomic,assign) id <ASIHTTPRequestDelegate> request_delegate;
@property(nonatomic,assign) id userparam;
@property(nonatomic,retain) UIProgressView *downloadProgress;

+(ASINetworkQueue*)downloadNetworkQueue;

-(void)download:(NSString *)fileUrl savePath:(NSString *)savePath tempPath:(NSString *)tempPath fileID:(NSString *)fileID;
- (void)pause:(NSString *)fileID;

@end
