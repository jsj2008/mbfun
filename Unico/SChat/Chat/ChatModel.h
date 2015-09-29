//
//  ChatModel.h
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic) BOOL isGroupChat;

- (void)initDataSource;


// 添加自己的消息
- (void)addSpecifiedItem:(NSDictionary *)dic;

// 添加他人的dic
- (void)addOtherItem:(NSDictionary *)dic;
- (void)addOtherItem:(NSDictionary *)dic withNum:(int)num pageOne:(BOOL)isOne;
// socket push
- (void)addSocketPushItem:(NSDictionary *)dic;

@end
