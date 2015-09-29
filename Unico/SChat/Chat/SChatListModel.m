//
//  SChatListModel.m
//  chat
//
//  Created by Ryan on 15/6/6.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import "SChatListModel.h"
#import "SUtilityTool.h"
@implementation SChatListModel
- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"message"]) {
        id something = [SUTIL getObject:value];
        if ([something isKindOfClass:NSClassFromString(@"NSString")] || [something isKindOfClass:NSClassFromString(@"NSNumber")]) {
            self.type = UUMessageTypeText;
            NSData *data = [[NSData alloc] initWithBase64EncodedString:value options:0];
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            self.lastMsg = text;
            return;
        }
        NSDictionary *dictionary = something;
        for (NSString *akey in [dictionary allKeys]) {
            if ([akey isEqualToString:@"msg"]) {
                self.type = UUMessageTypeText;
                NSData *data = [[NSData alloc] initWithBase64EncodedString:dictionary[@"msg"] options:0];
                NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                self.lastMsg = text;
            }else if ([akey isEqualToString:@"img_url"]) {
                self.type = UUMessageTypePicture;
            }else if ([akey isEqualToString:@"voice_url"]) {
                self.type = UUMessageTypeVoice;
            }
        }
    }
    else if ([key isEqualToString:@"create_time"]) {
        self.lastTime = value;
    }else if ([key isEqualToString:@"head_img"]) {
        self.img = value;
    }else if ([key isEqualToString:@"nick_name"]) {
        self.name = value;
    }else if ([key isEqualToString:@"un_read_num"]) {
        self.num = value;
    }else if ([key isEqualToString:@"user_id"]) {
        self.targetUserId = value;
    }
}

@end
