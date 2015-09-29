//
//  SChatListModel.h
//  chat
//
//  Created by Ryan on 15/6/6.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MessageType) {
    UUMessageTypeText     = 0 , // 文字
    UUMessageTypePicture  = 1 , // 图片
    UUMessageTypeVoice    = 2 ,  // 语音
    UUMessageTypePictureUrl,
    UUMessageTypeVoiceUrl
};

@interface SChatListModel : NSObject
@property (nonatomic,strong) NSString *targetUserId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *img;
@property (nonatomic,strong) NSString *lastMsg;
@property (nonatomic,strong) NSString *lastTime;
@property (nonatomic,strong) NSNumber *num;
@property (nonatomic,strong) NSNumber *head_v_type;
@property (nonatomic, assign) MessageType type;
- (id)initWithDict:(NSDictionary *)dict;
@end
