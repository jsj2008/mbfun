//
//  SChatSystemListModel.m
//  Wefafa
//
//  Created by wave on 15/6/11.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SChatSystemListModel.h"

@implementation SChatSystemListCreateUserInfo

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self == [super init]) {
        [self     setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end

@implementation SChatSystemListBannerInfo

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self == [super init]) {
        [self     setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation SChatSystemListModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
//'head_img' => $userInfo['head_img'],
//'user_id' => $userId,
//'mess_id' => $newId,
//'message' => $messageInfo,
//'type' => 17,
//'jump' => array(
//                'jump_id' => "0",
//                "jump_type" => 17,
//                "is_h5" => "0",
//                "url" => "0",
//                "tid" => $newId

/*
banner =     {
    id = 0;
    "is_h5" = 0;
    tid = 6533;
    type = 2;
    url = 0;
};
"create_time" = "2015-07-10 11:47:14";
"create_user" =     {
    "head_img" = "http://img.mixme.cn/sources/designer/Head/MD00000425/20150320101143.jpg";
    "nick_name" = tonny;
    "user_id" = "4b12f24a-30ef-4f70-bffc-5720e08b970a";
};
"create_user_id" = "4b12f24a-30ef-4f70-bffc-5720e08b970a";
id = 3872;
img = "http://metersbonwe.qiniucdn.com/FprYbkHmT8yLOEYeFZBIEivibWRs";
"is_read" = 0;
"jump_id" = 2;
message = "tonny\U559c\U6b22\U4e86\U4f60\U7684\U642d\U914d\U3002";
tid = 6533;
title = tonny;
type = 2;
*/
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"banner"]) {
        _SChatSystemListBannerInfo = [[SChatSystemListBannerInfo alloc]initWithDic:value];
    }if ([key isEqualToString:@"create_user"]) {
        _SChatSystemListCreateUserInfo = [[SChatSystemListCreateUserInfo alloc]initWithDic:value];
    }if ([key isEqualToString:@"id"]) {
        self.aid = value;
    }
}

@end
