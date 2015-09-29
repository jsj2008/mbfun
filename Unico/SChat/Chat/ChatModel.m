//
//  ChatModel.m
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "ChatModel.h"

#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "WeFaFaGet.h"
#import "SUtilityTool.h"

@implementation ChatModel
{
    BOOL _isOnePage;
    int _num;
    NSMutableArray *_temptArray;
}
// 添加聊天item（一个cell内容）
static NSString *previousTime = nil;

- (void)initDataSource {
    self.dataSource = [NSMutableArray array];
}

// 本地发送立即显示的，特殊处理
- (void)addSpecifiedItem:(NSDictionary *)dic
{
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = sns.myStaffCard.photo_path;
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    
    NSDate *date = [NSDate date];
    NSTimeInterval timeoffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
    date = [date dateByAddingTimeInterval:timeoffset];
    
    [dataDic setObject:[date description] forKey:@"strTime"];
    [dataDic setObject:sns.myStaffCard.nick_name forKey:@"strName"];
    [dataDic setObject:URLStr forKey:@"strIcon"];
    [dataDic setObject:dic[@"user_id"] forKey:@"strId"];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if ([dic[@"type"] intValue] == UUMessageTypeVoiceUrl) {
        message.voiceUrl = dic[@"voice_url"];
    }else if ([dic[@"type"] intValue] == UUMessageTypeText) {
        
    }else if ([dic[@"type"] intValue] == UUMessageTypePictureUrl) {
        message.pictureUrl = dic[@"photo_path"];
    }
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    [self.dataSource addObject:messageFrame];
}



// Socket Push的特殊处理
- (void)addSocketPushItem:(NSDictionary *)dic{
    
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [dataDic setObject:@(UUMessageFromOther) forKey:@"from"];
    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
    if(dic[@"nick_name"])[dataDic setObject:dic[@"nick_name"] forKey:@"strName"];
    if(dic[@"photo_path"])[dataDic setObject:dic[@"photo_path"] forKey:@"strIcon"];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    [self.dataSource addObject:messageFrame];
}

- (void)addSelfItem:(NSDictionary*)dic{

    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    [dataDic setObject:dic[@"create_time"] forKey:@"strTime"];
    [dataDic setObject:dic[@"nick_name"] forKey:@"strName"];
    [dataDic setObject:dic[@"head_img"] forKey:@"strIcon"];
    [dataDic setObject:dic[@"user_id"] forKey:@"strId"];
    
    dataDic[@"strContent"] = dic[@"message"];
    dataDic[@"type"] = @(UUMessageTypeText);
    
    // 识别类型
    [self addMessage:dataDic withInfo:dic[@"message"] ];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }

    //服务器pageindex ！= 0 返回的数据是正序 需要从【0】插入数组
    if (!_isOnePage) {
        [_temptArray addObject:messageFrame];
        if (_temptArray.count == _num) {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:
                                   NSMakeRange(0,[_temptArray count])];
            [self.dataSource insertObjects:_temptArray atIndexes:indexSet];
        }
    }else {
        [self.dataSource addObject:messageFrame];
    }
}

// 添加自己的item
- (void)addOtherItem:(NSDictionary *)dic{
    
    if ( [sns.myStaffCard.ldap_uid isEqualToString:dic[@"user_id"] ]) {
        [self addSelfItem:dic];
        return;
    }
    
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [dataDic setObject:@(UUMessageFromOther) forKey:@"from"];
    [dataDic setObject:dic[@"create_time"] forKey:@"strTime"];
    [dataDic setObject:dic[@"nick_name"] forKey:@"strName"];
    [dataDic setObject:dic[@"head_img"] forKey:@"strIcon"];
    
    dataDic[@"strContent"] = dic[@"message"];
    dataDic[@"type"] = @(UUMessageTypeText);
    
    // 识别类型
    [self addMessage:dataDic withInfo:dic[@"message"] ];
    
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    [self.dataSource addObject:messageFrame];
//    [self.dataSource insertObject:messageFrame atIndex:0];
}

- (void)addOtherItem:(NSDictionary *)dic withNum:(int)num pageOne:(BOOL)isOne {
    _isOnePage = isOne;
    _num = num;
    if (!_temptArray && isOne) {
        _temptArray = [NSMutableArray arrayWithCapacity:(NSUInteger)num];
    }
    if ( [sns.myStaffCard.ldap_uid isEqualToString:dic[@"user_id"] ]) {
        [self addSelfItem:dic];
        return;
    }
    
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [dataDic setObject:@(UUMessageFromOther) forKey:@"from"];
    [dataDic setObject:dic[@"create_time"] forKey:@"strTime"];
    [dataDic setObject:dic[@"nick_name"] forKey:@"strName"];
    [dataDic setObject:dic[@"head_img"] forKey:@"strIcon"];
    
    dataDic[@"strContent"] = dic[@"message"];
    dataDic[@"type"] = @(UUMessageTypeText);
    
    // 识别类型
    [self addMessage:dataDic withInfo:dic[@"message"] ];
    
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }

    //服务器pageindex ！= 0 返回的数据是正序 需要从【0】插入数组
    if (!isOne) {
        [_temptArray addObject:messageFrame];
        if (_temptArray.count == num) {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:
                                    NSMakeRange(0,[_temptArray count])];
            [self.dataSource insertObjects:_temptArray atIndexes:indexSet];
        }
    }else {
         [self.dataSource addObject:messageFrame];
    }
}

-(void)addMessage:(NSMutableDictionary*)dataDic withInfo:(NSString*)json{
    NSDictionary *info = [SUTIL getObject:json];
    
    if (info && [info isKindOfClass:[NSDictionary class]]) {
        if (info[@"img_url"]) {
            dataDic[@"img_url"] = info[@"img_url"];
            dataDic[@"type"] = @(UUMessageTypePictureUrl);
        } else if (info[@"voice_url"]) {
            dataDic[@"voice_url"] = info[@"voice_url"];
            dataDic[@"strVoiceTime"]=info[@"voice_time"];
            dataDic[@"type"] = @(UUMessageTypeVoiceUrl);
        } else if (info[@"msg"]) {
            NSData *data = [[NSData alloc] initWithBase64EncodedString:info[@"msg"] options:0];
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            dataDic[@"strContent"] = text ? text : @"";
            dataDic[@"type"] = @(UUMessageTypeText);
        }
    } else{
        NSLog(@"Message JSON Error:%@",json);
    }
    
}

@end
