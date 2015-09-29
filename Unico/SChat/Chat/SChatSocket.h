//
//  SChatSocket.h
//  Wefafa
//
//  Created by Ryan on 15/6/9.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
int UNREAD_ALL_NUMBER;  //全局未读消息
int MAIL_COUNT; //系统消息 聊天消息

int COMMENT_COUNT, LIKE_COUNT, MESS_COUNT, SYS_COUNT;   //评论搭配 喜欢搭配 private message, system message
@interface SChatSocket : NSObject

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *token;

+(SChatSocket*)shared;
-(void)initSocket;
-(void)logout;
-(void)call:(NSString*)func val:(NSDictionary*)v;
@end
