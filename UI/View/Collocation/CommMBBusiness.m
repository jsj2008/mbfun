//
//  CommMBBusiness.m
//  Wefafa
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CommMBBusiness.h"
#import "AppSetting.h"
#import "SQLiteOper.h"

//NSMutableArray *attenDesignerList;
@implementation CommMBBusiness

+(BOOL)isMyAttenDesigner:(NSString *)login_acc
{
    return [sqlite isAttenStuff:[AppSetting getFafaJid] staff_login_account:login_acc];
//    BOOL rst=NO;
//    for (int i=0;i<attenDesignerList.count;i++)
//    {
//        SNSStaff *staff=attenDesignerList[i];
//        if ([staff.login_account isEqualToString:login_acc])
//        {
//            rst=YES;
//            break;
//        }
//    }
//    return rst;
}

//+(void)reloadMyAttenList
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if (attenDesignerList==nil)
//            attenDesignerList=[[NSMutableArray alloc] initWithCapacity:5];
//        else
//            [attenDesignerList removeAllObjects];
//        NSString *ret=[sns getAttenStaffs:[AppSetting getFafaJid] Staffs:attenDesignerList];
//        if ([ret isEqualToString:SNS_RETURN_SUCCESS]==YES)
//        {
//            [sqlite saveAttenStaffs:[AppSetting getFafaJid] returnAttenList:attenDesignerList];
//        }
//    });
//}

//staffid可以是ldap_uid，loginaccount，fafajid
+(void)getStaffInfoByStaffID:(NSString *)staffid staffType:(STAFF_TYPE)staffType defaultProcess:(void (^)(void))defaultProcessFunc complete:(void (^)(SNSStaffFull *staff, BOOL success))complete
{
    BOOL needRefreshInfo=YES;
    __block SNSStaffFull *staff=[[SNSStaffFull alloc] init];
    defaultProcessFunc();
    if (staffType==STAFF_TYPE_OPENID && [sqlite getStaffFullByLdapUID:staffid stafffull:staff]==YES)
    {
        complete(staff,YES);
    }
    else if (staffType==STAFF_TYPE_JID && [sqlite getStaffFullByJid:staffid stafffull:staff]==YES)
    {
        complete(staff,YES);
    }
    else if (staffType==STAFF_TYPE_LOGINACCOUNT && [sqlite getStaffFullByEmail:staffid stafffull:staff]==YES)
    {
        complete(staff,YES);
    }
    else
    {
        needRefreshInfo=NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            staff=[[SNSStaffFull alloc] init];
            NSString *rst=[sns getStaffCard:staffid StaffCard:&staff];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([rst isEqualToString:SNS_RETURN_SUCCESS])
                {
                    if (staffType==STAFF_TYPE_OPENID)
                        staff.ldap_uid=[[NSString alloc] initWithFormat:@"%@",staffid];
                    [sqlite insertStaff:staff];
                    complete(staff,YES);
                }
                else
                {
                    complete(nil,NO);
                }
            });
        });
    }
    
//    if (needRefreshInfo)
//    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            staff=[[SNSStaffFull alloc] init];
//            NSString *rst=[sns getStaffCard:staffid StaffCard:&staff];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if ([rst isEqualToString:SNS_RETURN_SUCCESS])
//                {
//                    if (staffType==STAFF_TYPE_OPENID)
//                        staff.ldap_uid=[[NSString alloc] initWithFormat:@"%@",staffid];
//                    [sqlite insertStaff:staff];
//                }
//            });
//        });
//    }
}

+(void)judgeDesigner:(NSString *)staffid staffType:(STAFF_TYPE)staffType isDesigner:(void (^)(BOOL result))isDesigner
{
    __block SNSStaffFull *staff=[[SNSStaffFull alloc] init];
    if (staffType==STAFF_TYPE_OPENID && [sqlite getStaffFullByLdapUID:staffid stafffull:staff]==YES)
    {
        if ([staff.duty isEqualToString:@"造型师"])
            isDesigner(YES);
        else
            isDesigner(NO);
    }
    else if (staffType==STAFF_TYPE_JID && [sqlite getStaffFullByJid:staffid stafffull:staff]==YES)
    {
        if ([staff.duty isEqualToString:@"造型师"])
            isDesigner(YES);
        else
            isDesigner(NO);
    }
    else if (staffType==STAFF_TYPE_JID && [sqlite getStaffFullByEmail:staffid stafffull:staff]==YES)
    {
        if ([staff.duty isEqualToString:@"造型师"])
            isDesigner(YES);
        else
            isDesigner(NO);
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            staff=[[SNSStaffFull alloc] init];
            NSString *rst=[sns getStaffCard:staffid StaffCard:&staff];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([rst isEqualToString:SNS_RETURN_SUCCESS])
                {
                    if (staffType==STAFF_TYPE_OPENID)
                        staff.ldap_uid=[[NSString alloc] initWithFormat:@"%@",staffid];
                    [sqlite insertStaff:staff];
                    if ([staff.duty isEqualToString:@"造型师"])
                        isDesigner(YES);
                    else
                        isDesigner(NO);
                }
                else
                {
                    isDesigner(NO);
                }
            });
        });
    }
}

+(NSString *)changeStringWithurlString:(NSString *)imageurl size:(IMAGE_SIZE)size
{
    return imageurl;
    int w=100;
//    int w = size;
    
    if (size==SNS_IMAGE_ORIGINAL)
    {
        w=600;//SCREEN_WIDTH*2;
    }
    else if(size==SNS_IMAGE_SMALL)
    {
        w=300;
    }
    else if(size==SNS_IMAGE_MIDDLE)
    {
        w=500;
    }
    else if(size==3)
    {
        
    }
    
    return [CommMBBusiness changeStringWithurlString:imageurl width:w height:w];
}

+(NSString *)changeStringWithurlString:(NSString *)imageurl width:(int)width height:(int)height
{
    if (!imageurl || [imageurl isEqualToString:@""]) {
        return nil;
    }
    NSString *mainurlString = @"";
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:imageurl];
    NSRange range = [String1 rangeOfString:@"--"];
//    int location = range.location;
//    int leight = range.length;
    
    
    NSArray *arr = [String1 componentsSeparatedByString:@"."];
    NSString *fileSuffix=[[NSString alloc] initWithFormat:@".png"];
    if (arr.count>1 && [[arr lastObject] length]<5)
    {
        fileSuffix=[[NSString alloc] initWithFormat:@"%@",[arr lastObject]];
    }
    if (range.location==NSNotFound)
    {
        int pos=(int)String1.length-(int)fileSuffix.length-1;
        if (pos>0)
            mainurlString = [NSString stringWithFormat:@"%@--%dx%d.%@",[String1 substringToIndex:pos],width,height,fileSuffix];
        else
            mainurlString=[NSString stringWithFormat:@"%@",String1];
    }
    else
    {
        mainurlString = [NSString stringWithFormat:@"%@",String1];
    }
    return mainurlString;
    
    
//    if (leight == 2) {////有--400x400
//        mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location]];
//        [mainurlString appendString:[NSString stringWithFormat:@".png"]];
//        
//        
//    }else{//没有--400x400 //有后缀.png
//        NSRange range = [[String1 lowercaseString] rangeOfString:@".png"];
//        
//        int leight = range.length;
//        if (leight == 4){//有后缀.png
//            
//            mainurlString = [[NSMutableString alloc] initWithString:String1];
//            
//        }else{//没有后缀png
//            
//            //后缀jpg
//            NSRange range2 = [[String1 lowercaseString] rangeOfString:@".jpg"];
//            int location2 = range2.location;
//            int leight2 = range2.length;
//            if (leight2 == 4){//有后缀.jpg
//                
//                mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location2]];
//                [mainurlString appendString:[NSString stringWithFormat:@".jpg"]];
//            }else{//没有后缀
//                
//                mainurlString = [[NSMutableString alloc] initWithString:String1];
//                [mainurlString appendString:[NSString stringWithFormat:@".png"]];
//                
//            }
//            
//            
//        }
//        
//    }
//    
//    
//    
//    [mainurlString insertString:[NSString stringWithFormat:@"--%dx%d",width,height] atIndex:mainurlString.length -4];
//    return mainurlString;
}
+(NSString *)getdate:(NSString *)datestr;
{
    NSString *dateString=nil;
    NSDate *date ;
    if (datestr.length>1 && [[datestr substringToIndex:1] isEqualToString:@"/"])
    {
        NSArray *arr=[datestr componentsSeparatedByString:@"/Date("];
        NSString *s=[arr lastObject];
        arr=[s componentsSeparatedByString:@")/"];
        
        s=arr[0];
        arr=[s componentsSeparatedByString:@"-"];
        s=arr[0];
        date =[NSDate dateWithTimeIntervalSince1970:[s longLongValue]/1000];
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateString=[NSString stringWithFormat:@"%@",[format stringFromDate:date]];
        
    }
    return dateString;
}
@end
