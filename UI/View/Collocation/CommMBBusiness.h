//
//  CommMBBusiness.h
//  Wefafa
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeFaFaGet.h"
#import "SNSDataClass.h"

typedef enum
{
    STAFF_TYPE_OPENID,
    STAFF_TYPE_JID,
    STAFF_TYPE_LOGINACCOUNT
}STAFF_TYPE;

@interface CommMBBusiness : NSObject

+(BOOL)isMyAttenDesigner:(NSString *)login_acc;
+(void)getStaffInfoByStaffID:(NSString *)staffid staffType:(STAFF_TYPE)staffType defaultProcess:(void (^)(void))defaultProcessFunc complete:(void (^)(SNSStaffFull *staff, BOOL success))complete;
+(void)judgeDesigner:(NSString *)staffid staffType:(STAFF_TYPE)staffType isDesigner:(void (^)(BOOL result))isDesigner;
+(NSString *)changeStringWithurlString:(NSString *)imageurl width:(int)width height:(int)height;
+(NSString *)changeStringWithurlString:(NSString *)imageurl size:(IMAGE_SIZE)size;
+(NSString *)getdate:(NSString *)datestr; 
@end
