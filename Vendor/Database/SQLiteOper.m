//
//  SQLiteOper.m
//  FaFa
//
//  Created by mac on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SQLiteOper.h"
//#import "TcpFileService.h"
#import "AppSetting.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "DBInitSql.h"
//#import "FriendObject.h"
#import "NSDateAdditions.h"
//#import "EmployeeObject.h"
#import "Utils.h"

#import "Authority.h"

SQLiteOper *g_sqlite = nil;
SQLiteOper* get_g_sqlite()
{
    if (g_sqlite == nil) return nil;
    
    for (int i=0; i<30*1000; i++) {
        if([g_sqlite isOpened]) break;
        usleep(1000);
    }
    return g_sqlite;
}

@implementation SQLiteOper

- (id)init
{
    self=[super init];
    
    if (self )
    {
        
    }
    
    return self;
}

- (void)dealloc
{    
    [self close];
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

-(void)open:(NSString*)jidbare
{
    if (jidbare.length==0) {
        NSLog(@"-----------dbopen jidbare is null ,use default path-----");
    }
    [self close];
    NSString *dbpath=[AppSetting getPersonalFilePathWithJID:jidbare]; //jidbare = nil 是游客路径
    [Utils createDirectory:dbpath];
    NSString *dbfile = [dbpath stringByAppendingPathComponent: @"FaFaIPhone.db"];
    if (dbQueue==nil)
    {
#if ! __has_feature(objc_arc)
        dbQueue = [[FMDatabaseQueue databaseQueueWithPath:dbfile] retain];
#else
        dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbfile];
#endif
        [self checkDBVersion];
    }
}
-(void)close
{
    if (dbQueue != nil)
    {
        [dbQueue close];
        OBJC_RELEASE(dbQueue);
    }
}
-(BOOL)isOpened
{
    return dbQueue != nil;
}
-(void)checkDBVersion
{
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSNumber *dbversion = @0;
        if([db tableExists:@"dbversion"])
        {
//            firstLogin=NO;
            
            FMResultSet *rs = [db executeQuery:@"select version from dbversion"];
            if (rs != nil && [rs next]) {
                dbversion = [NSNumber numberWithInt:[rs intForColumnIndex:0]];
            }
            [rs close];
        }
        NSNumber *lastversioin = @0;
        NSArray *initsql = [DBInitSql getInitSql];
        for (int i=0; i<[initsql count];)
        {
            lastversioin = initsql[i];
            if ([dbversion intValue] < [initsql[i] intValue])
            {
                i++;
                NSArray *sqls = initsql[i];
                for (int j=0; j<[sqls count]; j++)
                {
                    [db executeUpdate:sqls[j]];
                }
            }
            else
            {
                i++;
            }
            
            i++;
        }
        if ([dbversion intValue] < [lastversioin intValue])
        {
            [db executeUpdate:@"delete from dbversion"];
            [db executeUpdate:@"insert into dbversion(version, note) values(?, ?)", lastversioin, @""];
        }
    }];
}

- (BOOL)Query:(NSString *)querySQL Record:(NSMutableArray *)recordArray
{
    BOOL __block rst=NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:querySQL];
        if (rs != nil)
        {
            while ([rs next]) {
                [recordArray addObject:[rs resultDictionary]];
            }
            rst = YES;
        }
        [rs close];
    }];
    
    return rst;
}

+(NSString*)SYSPARANAME_VER_IM_DEPT
{
    return @"VER_IM_DEPT";
}
+(NSString*)SYSPARANAME_VER_IM_GROUP
{
    return @"VER_IM_GROUP";
}
+(NSString*)SYSPARANAME_VER_IM_DEPTEMPLOYEE
{
    return @"VER_IM_EMPLOYEE";
}
-(NSString*)getSysParam:(NSString*)name defaultvalue:(NSString*)defaultvalue
{
    NSString __block *re = defaultvalue;
           
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select ifnull(max(para_value), ?) as para_value from sys_paras where para_name=?", defaultvalue, name];
        if (rs != nil && [rs next]) {
            re = [rs stringForColumnIndex:0];
        }
        [rs close];
    }];
    
    return re;
}
-(BOOL)setSysParam:(NSString*)name value:(NSString*)value
{
    BOOL __block re = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from sys_paras where para_name=?", name];
        re = [db executeUpdate:@"insert into sys_paras(para_name, para_value, para_desc) values(?, ?, null)", name, value];
    }];
    
    return re;
}

-(BOOL)clearHisData
{
    BOOL __block re = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSArray * arrSql = @[@"delete from im_message_single",
                             @"delete from im_message_group",
                             @"delete from im_message_business",
                             @"delete from we_conv",
                             @"delete from we_like",
                             @"delete from we_attach",
                             @"delete from we_together",
                             @"delete from we_together_staff",
                             @"delete from we_vote",
                             @"delete from we_vote_option",
                             @"delete from we_reply",
                             @"delete from we_reply_attach",
                             @"delete from we_conv_atme",
                             @"delete from we_bulletin",
                             @"delete from we_message",
                             @"delete from session_last_five"];
        for (NSString *sqlX in arrSql) {
            re = [db executeUpdate:sqlX];
        }
    }];
    
    return re;    
}

-(BOOL)insertSingleMessage:(NSString *)jid Resource:(NSString *)resource Content:(NSString*)content SendDateTime:(NSDate *)time IsMyMessage:(BOOL)isMyMessage
{
    return [self insertSingleMessage:jid Resource:resource Content:content SendDateTime:time IsMyMessage:isMyMessage xmlcontent:nil];
}
//-(BOOL)insertSnsShareMessage:(NSString *)jid Resource:(NSString *)resource Content:(NSString*)content SendDateTime:(NSDate *)time IsMyMessage:(BOOL)isMyMessage xmlcontent:(NSString*)xmlcontent msgtype:(NSString*)type;
//{
//    NSString *result=[NSString stringWithFormat:@"%@",content];
//    
//    ////////////////////////////////////
//    //语音消息
//    NSRegularExpression *pvoicesec = [NSRegularExpression regularExpressionWithPattern:@"\\(voicesec:(.*)\\)" options:NSRegularExpressionCaseInsensitive error:nil];
//    NSTextCheckingResult *mvoicesec = [pvoicesec firstMatchInString:result options:0 range:NSMakeRange(0, [result length])];
//    if (mvoicesec) {
//        //            NSString * matchstring= [result substringWithRange:mvoicesec.range];
//        NSRange filerange=NSMakeRange(0,mvoicesec.range.location);
//        NSString * filestr = [result substringWithRange:filerange];
//        
//        //        NSString * temp=[NSString stringWithFormat:@"(语音消息：$1'')"];
//        NSString * temp=[NSString stringWithFormat:@"$1''"];
//        
//        NSString *replacestring = [pvoicesec stringByReplacingMatchesInString:result
//                                                                      options:0
//                                                                        range:NSMakeRange(0, [result length])
//                                                                 withTemplate:temp];
//        result = [NSString stringWithFormat:@"%@\n%@",[replacestring substringFromIndex:mvoicesec.range.location],filestr];
//    }
//    //视频消息
//    NSRegularExpression *pvideosec = [NSRegularExpression regularExpressionWithPattern:@"\\(videosec:(.*)\\)" options:NSRegularExpressionCaseInsensitive error:nil];
//    NSTextCheckingResult *mvideosec = [pvideosec firstMatchInString:result options:0 range:NSMakeRange(0, [result length])];
//    if (mvideosec)
//    {
//        NSRange filerange=NSMakeRange(0,mvideosec.range.location);
//        NSString * filestr = [result substringWithRange:filerange];
//        
//        NSString * temp=[NSString stringWithFormat:@"(视频消息)"];
//        NSString *replacestring = [pvideosec stringByReplacingMatchesInString:result
//                                                                      options:0
//                                                                        range:NSMakeRange(0, [result length])
//                                                                 withTemplate:temp];
//        result = [NSString stringWithFormat:@"%@\n%@",[replacestring substringFromIndex:mvideosec.range.location],filestr];
//    }
//    
//    BOOL __block rst = NO;
//    
//    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        NSString *new_guid=[Utils genGUID];
//        NSDate *sendtime=time;
//        NSString *old_guid=@"";
//        
//        if (isMyMessage==NO)
//        {
//            FMResultSet *rs = [db executeQuery:@"SELECT guid FROM session_last_five WHERE talk_id=?",jid];
//            if (rs != nil && [rs next]) {
//                old_guid = [rs stringForColumnIndex:0];
//            }
//            [rs close];
//            if ([old_guid isEqualToString:@""]==NO)
//            {
//                rst=[db executeUpdate:
//                     @"UPDATE session_last_five SET guid=?, msg_time=? WHERE talk_id=?",new_guid,sendtime,jid];
//                if (rst==NO) {
//                    *rollback = YES;
//                    return;
//                }
//            }
//            else
//            {
//                //保持所有，不只是5条
//                //                int currentNum=0;
//                //                FMResultSet *rs = [db executeQuery:@"SELECT count(*) FROM session_last_five"];
//                //                if (rs != nil && [rs next]) {
//                //                    currentNum = [rs intForColumnIndex:0];
//                //                }
//                //                [rs close];
//                //                if (currentNum==5)
//                //                {
//                //                    //删最早的一条
//                //                    rst=[db executeUpdate:
//                //                         @"DELETE FROM session_last_five WHERE msg_time=(SELECT MIN(msg_time) FROM session_last_five)"];
//                //                    if (rst==NO) {
//                //                        *rollback = YES;
//                //                        return;
//                //                    }
//                //                }
//                rst=[db executeUpdate:
//                     @"INSERT INTO session_last_five(talk_id,session_type,guid,msg_time) "
//                     "VALUES(?,?,?,?)",jid,[NSNumber numberWithInt:0],new_guid,sendtime];
//                if (rst==NO) {
//                    *rollback = YES;
//                    return;
//                }
//            }
//        }
//        else
//        {
//            //自己发的消息
//            FMResultSet *rs = [db executeQuery:@"SELECT guid FROM session_last_five WHERE talk_id=?",jid];
//            if (rs != nil && [rs next]) {
//                old_guid = [rs stringForColumnIndex:0];
//            }
//            [rs close];
//            if ([old_guid isEqualToString:@""]==NO)
//            {
//                rst=[db executeUpdate:
//                     @"UPDATE session_last_five SET guid=?, msg_time=? WHERE talk_id=?",new_guid,sendtime,jid];
//                if (rst==NO) {
//                    *rollback = YES;
//                    return;
//                }
//            }
//            else
//            {
//                rst=[db executeUpdate:
//                     @"INSERT INTO session_last_five(talk_id,session_type,guid,msg_time) "
//                     "VALUES(?,?,?,?)",jid,[NSNumber numberWithInt:0],new_guid,sendtime];
//                if (rst==NO) {
//                    *rollback = YES;
//                    return;
//                }
//            }
//        }
//        
//        rst = [db executeUpdate:@"INSERT INTO im_message_single(guid,talkabout_jid_bare,talkabout_resource, msg_text,msg_time,ismymsg,msg_xml,msg_type) values(?,?,?,?,?,?,?,?)",new_guid,jid,resource,result,sendtime,isMyMessage==YES?@"1":@"0",xmlcontent,type];
//        if (rst==NO) {
//            *rollback = YES;
//            return;
//        }
//    }];
//    
//    return rst;
//}
-(BOOL)insertSingleMessage:(NSString *)jid Resource:(NSString *)resource Content:(NSString*)content SendDateTime:(NSDate *)time IsMyMessage:(BOOL)isMyMessage xmlcontent:(NSString*)xmlcontent
{
    return [self insertSingleMessage:jid Resource:resource Content:content SendDateTime:time IsMyMessage:isMyMessage xmlcontent:xmlcontent guid:nil];
}
-(BOOL)insertSingleMessage:(NSString *)jid Resource:(NSString *)resource Content:(NSString*)content SendDateTime:(NSDate *)time IsMyMessage:(BOOL)isMyMessage xmlcontent:(NSString*)xmlcontent guid:(NSString*)guid
{
    NSString *result=[NSString stringWithFormat:@"%@",content];
    
    ////////////////////////////////////
    //语音消息
    NSRegularExpression *pvoicesec = [NSRegularExpression regularExpressionWithPattern:@"\\(voicesec:(.*)\\)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *mvoicesec = [pvoicesec firstMatchInString:result options:0 range:NSMakeRange(0, [result length])];
    if (mvoicesec) {
        //            NSString * matchstring= [result substringWithRange:mvoicesec.range];
        NSRange filerange=NSMakeRange(0,mvoicesec.range.location);
        NSString * filestr = [result substringWithRange:filerange];
        
        //        NSString * temp=[NSString stringWithFormat:@"(语音消息：$1'')"];
        NSString * temp=[NSString stringWithFormat:@"$1''"];
        
        NSString *replacestring = [pvoicesec stringByReplacingMatchesInString:result
                                                                      options:0
                                                                        range:NSMakeRange(0, [result length])
                                                                 withTemplate:temp];
        result = [NSString stringWithFormat:@"%@\n%@",[replacestring substringFromIndex:mvoicesec.range.location],filestr];
    }
    //视频消息
    NSRegularExpression *pvideosec = [NSRegularExpression regularExpressionWithPattern:@"\\(videosec:(.*)\\)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *mvideosec = [pvideosec firstMatchInString:result options:0 range:NSMakeRange(0, [result length])];
    if (mvideosec)
    {
        NSRange filerange=NSMakeRange(0,mvideosec.range.location);
        NSString * filestr = [result substringWithRange:filerange];
        
        NSString * temp=[NSString stringWithFormat:@"(视频消息)"];
        NSString *replacestring = [pvideosec stringByReplacingMatchesInString:result
                                                                      options:0
                                                                        range:NSMakeRange(0, [result length])
                                                                 withTemplate:temp];
        result = [NSString stringWithFormat:@"%@\n%@",[replacestring substringFromIndex:mvideosec.range.location],filestr];
    }
    
    BOOL __block rst = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *new_guid= guid==nil ? [Utils genGUID] : guid;
        NSDate *sendtime=time;
        NSString *old_guid=@"";
        
        if (isMyMessage==NO)
        {
            FMResultSet *rs = [db executeQuery:@"SELECT guid FROM session_last_five WHERE talk_id=?",jid];
            if (rs != nil && [rs next]) {
                old_guid = [rs stringForColumnIndex:0];
            }
            [rs close];
            if ([old_guid isEqualToString:@""]==NO)
            {
                rst=[db executeUpdate:
                     @"UPDATE session_last_five SET guid=?, msg_time=? WHERE talk_id=?",new_guid,sendtime,jid];
                if (rst==NO) {
                    *rollback = YES;
                    return;
                }
            }
            else
            {
                //保持所有，不只是5条
                //                int currentNum=0;
                //                FMResultSet *rs = [db executeQuery:@"SELECT count(*) FROM session_last_five"];
                //                if (rs != nil && [rs next]) {
                //                    currentNum = [rs intForColumnIndex:0];
                //                }
                //                [rs close];
                //                if (currentNum==5)
                //                {
                //                    //删最早的一条
                //                    rst=[db executeUpdate:
                //                         @"DELETE FROM session_last_five WHERE msg_time=(SELECT MIN(msg_time) FROM session_last_five)"];
                //                    if (rst==NO) {
                //                        *rollback = YES;
                //                        return;
                //                    }
                //                }
                rst=[db executeUpdate:
                     @"INSERT INTO session_last_five(talk_id,session_type,guid,msg_time) "
                     "VALUES(?,?,?,?)",jid,[NSNumber numberWithInt:0],new_guid,sendtime];
                if (rst==NO) {
                    *rollback = YES;
                    return;
                }
            }
        }
        else
        {
            //自己发的消息
            FMResultSet *rs = [db executeQuery:@"SELECT guid FROM session_last_five WHERE talk_id=?",jid];
            if (rs != nil && [rs next]) {
                old_guid = [rs stringForColumnIndex:0];
            }
            [rs close];
            if ([old_guid isEqualToString:@""]==NO)
            {
                rst=[db executeUpdate:
                     @"UPDATE session_last_five SET guid=?, msg_time=? WHERE talk_id=?",new_guid,sendtime,jid];
                if (rst==NO) {
                    *rollback = YES;
                    return;
                }
            }
            else
            {
                rst=[db executeUpdate:
                     @"INSERT INTO session_last_five(talk_id,session_type,guid,msg_time) "
                     "VALUES(?,?,?,?)",jid,[NSNumber numberWithInt:0],new_guid,sendtime];
                if (rst==NO) {
                    *rollback = YES;
                    return;
                }
            }
        }
        
        rst = [db executeUpdate:@"INSERT INTO im_message_single(guid,talkabout_jid_bare,talkabout_resource, msg_text,msg_time,ismymsg, msg_xml) values(?,?,?,?,?,?,?)",new_guid,jid,resource,result,sendtime,isMyMessage==YES?@"1":@"0",xmlcontent];
        if (rst==NO) {
            *rollback = YES;
            return;
        }
    }];
    
    return rst;
}

-(BOOL) querySingleMessage:(NSMutableArray *)recordArray withJID:(NSString *)jid StartRow:(int)row MsgCount:(int)count
{
    BOOL __block rst=NO;
    [dbQueue inDatabase:^(FMDatabase *db) {
        //NSString *sqlstr=[NSString stringWithFormat:@"SELECT * FROM im_message_single WHERE talkabout_jid_bare=? order by msg_time limit %d,%d",row,count];
        NSString *sqlstr=[NSString stringWithFormat:@"SELECT * FROM im_message_single WHERE talkabout_jid_bare=? order by msg_time limit %d,%d",row,count];
        FMResultSet *rs = [db executeQuery:sqlstr,jid];
        if (rs!=nil)
        {
            while([rs next]) {
                [recordArray addObject: [rs resultDictionary]];
                rst=YES;
            }
        }
        [rs close];
    }];
    return rst;
}

-(int) getSingleMessageCount:(NSString *)jid
{
    int __block rst=0;
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT count(*) FROM im_message_single WHERE talkabout_jid_bare=?",jid];
        if (rs!=nil && [rs next]) {
            rst=[rs intForColumnIndex:0];
        }
        [rs close];
    }];
    return rst;
}

-(BOOL) deleteSingleMessageWithJid:(NSString *)jid
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst = [db executeUpdate:@"DELETE FROM im_message_single WHERE talkabout_jid_bare=?", jid];
    }];
    
    return rst;
}

-(BOOL) deleteSingleMessageByGUID:(NSString *)guid
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst = [db executeUpdate:@"DELETE FROM im_message_single WHERE guid=?", guid];
    }];
    
    return rst;
}

-(BOOL)insertIMDept:(NSString *)deptid DeptName:(NSString *)deptname PID:(NSString *)pid noorder:(int)noorder
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst = [db executeUpdate:@"insert into im_dept(deptid, deptname, pid, noorder) values(?, ?, ?, ?)", deptid, deptname, pid, [NSNumber numberWithInt:noorder]];
    }];
    
    return rst;
}

- (NSDictionary*)getDepartmentRoot
{
    NSDictionary __block *rst=nil;
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT deptid, deptname, pid, noorder FROM im_dept a WHERE NOT EXISTS (SELECT deptid FROM im_dept b WHERE a.pid=b.deptid)"];
        if (rs!=nil && [rs next]) {
            rst = [rs resultDictionary];
        }
        [rs close];
    }];
    return rst;
}

-(BOOL)deleteIMDept
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst = [db executeUpdate:@"delete from im_dept"];
    }];
    
    return rst;
}

-(NSArray*)getDeptByParent:(NSString *)pid
{
    NSMutableArray __block *rst = [NSMutableArray arrayWithCapacity:10];
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT deptid, deptname, pid, noorder FROM im_dept WHERE pid=? ORDER BY noorder", pid];
        if (rs != nil)
        {
            while ([rs next]) {
                [rst addObject:[rs resultDictionary]];
            }
        }
        [rs close];
    }];
    return rst;
}

//-(NSString *)QueryDepartmentName:(NSString *)deptid
//{    
//    NSString __block  *rst=@"";
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:@"select deptname from im_dept where deptid=?",deptid];
//        if (rs != nil && [rs next]) {
//            rst = [rs stringForColumnIndex:0];
//        }
//        [rs close];
//    }];
//    
//    return rst;
//}

-(BOOL)insertDeptEmployee:(NSString *)deptid EmployeeID:(NSString *)employeeid EmployeeName:(NSString *)employeename LoginName:(NSString *)loginname
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst = [db executeUpdate:@"delete from im_employee where employeeid=?",  employeeid];
        rst = [db executeUpdate:@"insert into im_employee(deptid, employeeid, loginname, employeename) values(?, ?, ?, ?)", deptid, employeeid, loginname, employeename];
    }];
    
    return rst;
}

-(BOOL)deleteDeptEmployee
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst = [db executeUpdate:@"delete from im_employee"];
    }];
    
    return rst;
}

-(NSArray*)QueryDeptEmployee:(NSString *)deptid
{
    NSMutableArray __block *re = [NSMutableArray arrayWithCapacity:10];
    
    [dbQueue inDatabase:^(FMDatabase *db) { 
        FMResultSet *rs = [db executeQuery:@"select employeeid, deptid, loginname, employeename from im_employee where deptid=? order by employeeid",deptid];
        while (rs != nil && [rs next]) {
            [re addObject:[rs resultDictionary]]; 
        }
        [rs close];
    }];
    return re;
}

-(void)deleteGroupInfo
{
    BOOL __block  rst=NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst=[db executeUpdate:@"DELETE FROM im_group"];
    }];
}

-(void)deleteGroupByID:(NSString *)groupid
{
    BOOL __block  rst=NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst=[db executeUpdate:@"DELETE FROM im_group where groupid=?",groupid];
    }];
}

-(BOOL)insertGroupInfo:(NSString *)groupid GroupName:(NSString *)groupname GroupClass:(NSString *)groupclass GroupDesc:(NSString *)groupdesc GroupPost:(NSString *)grouppost Creator:(NSString *)creator AddMemberMethod:(NSString *)add_member_method Valid:(NSString *)valid
{ 
    BOOL __block  rst=NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        BOOL isExist=NO;
        FMResultSet *rs = [db executeQuery:@"SELECT count(*) as cnt FROM im_group WHERE groupid=?", groupid];
        if (rs != nil && [rs next]) {
            isExist=[rs intForColumn:@"cnt"]>0;
            NSLog(@"%d",[rs intForColumn:@"cnt"]);
        }
        [rs close];
        
        
        if (isExist)
            rst=[db executeUpdate:@"UPDATE im_group set groupname=?, groupclass=?, groupdesc=?, grouppost=? , creator=?, add_member_method=? WHERE groupid=?",
                groupname,groupclass,groupdesc,grouppost,creator,add_member_method,groupid];
        else
            rst=[db executeUpdate:@"INSERT INTO im_group(groupid, groupname, groupclass, groupdesc, grouppost , creator, add_member_method,valid) "
                 "VALUES(?,?,?,?,?,?,?,?)",
                 groupid,groupname,groupclass,groupdesc,grouppost,creator,add_member_method,valid];
    }];
    return rst;
}



-(NSArray*)getIMGroup
{
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:10];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        //过滤，只留discussgroup Chengyb 20141104
//        FMResultSet *rs = [db executeQuery:@"select groupid, groupname, groupclass, groupdesc, grouppost, creator, add_member_method from im_group where valid=?",@"1"];
        FMResultSet *rs = [db executeQuery:@"select groupid, groupname, groupclass, groupdesc, grouppost, creator, add_member_method from im_group where valid=? and groupclass=?",@"1", @"discussgroup"];
        
        
        while (rs != nil && [rs next]) {
            [re addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return re;
}

-(NSDictionary*)getIMGroupByID:(NSString *)groupid
{
    NSMutableDictionary *group_dict = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select groupid, groupname, groupclass, groupdesc, grouppost, creator, add_member_method from im_group where groupid=?",groupid];
        if (rs != nil && [rs next]) {
            [group_dict addEntriesFromDictionary:[rs resultDictionary]];
        }
        [rs close];
    }];
    return group_dict;
}

//-(BOOL)updateGroupInfoValid:(NSString *)groupid
//{
//    BOOL __block  rst=NO;
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        rst=[db executeUpdate:@"UPDATE im_group SET valid=? where groupid=?",@"1",groupid];
//    }];
//    return rst;
//}
//
//-(NSString *)QueryGroupName:(NSString *)groupid
//{
//    NSString __block  *rst=@"";
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:@"select groupname from im_group where groupid=?",groupid];
//        if (rs != nil && [rs next]) {
//            rst = [rs stringForColumnIndex:0];
//        }
//        [rs close];
//    }];
//    
//    return rst;
//}
//
//-(NSString *)QueryGroupDesc:(NSString *)groupid
//{
//    NSString __block  *rst=@"";
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:@"select groupdesc from im_group where groupid=?",groupid];
//        if (rs != nil && [rs next]) {
//            rst = [rs stringForColumnIndex:0];
//        }
//        [rs close];
//    }];
//    
//    return rst;
//}

-(void)deleteGroupMember:(NSString *)groupid
{
    BOOL __block  rst=NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst=[db executeUpdate:
             @"DELETE FROM im_groupemployee WHERE groupid=?",groupid];
    }];
}

-(void)deleteGroupMemberEmployee:(NSString *)groupid employeeid:(NSString *)employeeid
{
    BOOL __block  rst=NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst=[db executeUpdate:
             @"DELETE FROM im_groupemployee WHERE groupid=? and employeeid = ? ",groupid,employeeid];
    }];
}

-(BOOL)insertGroupMember:(NSString *)groupid EmployeeID:(NSString *)employeeid GroupRole:(NSString *)grouprole Nick:(NSString *)employeenick Note:(NSString *)employeenote
{
    BOOL __block  rst=NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst=[db executeUpdate:
             @"INSERT INTO im_groupemployee(groupid, employeeid, grouprole, employeenick,employeenote) "
             "VALUES(?,?,?,?,?) ",groupid,employeeid,grouprole,employeenick,employeenote];
    }];
    return rst;
}
-(NSArray*)getGroupMember:(NSString *)groupid
{
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:10];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select employeeid, groupid, grouprole, employeenick, employeenote from im_groupemployee where groupid=? ", groupid];
        while (rs != nil && [rs next]) {
            [re addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return re;
}
-(NSArray*)getGroupMember:(NSString *)groupid MemberJID:(NSString *)memberjid
{
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:10];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select employeeid, groupid, grouprole, employeenick, employeenote from im_groupemployee where groupid=? and employeeid=?", groupid,memberjid];
        while (rs != nil && [rs next]) {
            [re addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return re;
}

-(NSString*)getGroupMemberVer:(NSString*)groupid
{
    NSString __block *re = @"";
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select version from im_groupemployee_version where groupid=?",groupid];
        if (rs != nil && [rs next]) {
            re = [rs stringForColumnIndex:0];
        }
        [rs close];
    }];
    
    return re;
}
-(BOOL)setGroupMemberVer:(NSString*)groupid version:(NSString*)version
{    
    BOOL __block re = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from im_groupemployee_version where groupid=?", groupid];
        re = [db executeUpdate:@"insert into im_groupemployee_version(groupid, version) values(?, ?)", groupid, version];
    }];
    
    return re;
}

-(BOOL)insertCircleClass:(NSArray *)circleClasses {
 
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *delSqlwe_circle_class = @"delete from we_circle_class";
        static NSString *insSqlwe_circle_class = @"insert into we_circle_class(classify_id, classify_name, parent_classify_id) values(?,?,?)";
        
        [db executeUpdate:delSqlwe_circle_class];
        for (SNSCircleClass *circleClass in circleClasses) {
            [db executeUpdate:insSqlwe_circle_class,circleClass.classify_id,circleClass.classify_name,circleClass.parent_classify_id];
        }
        rst = YES;
    }];
    
    return rst;
}

-(NSArray *)getCircleClass {
    NSMutableArray __block *rst = [NSMutableArray arrayWithCapacity:20];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT classify_id as id,classify_name as name,parent_classify_id as parent_id FROM we_circle_class ORDER BY classify_id ASC"];
        if (rs != nil)
        {
            while([rs next]) {
                [rst addObject:[rs resultDictionary]];
            }
        }
        [rs close];
    }];
    
    return rst;
}

-(NSDictionary *)getCircleClass:(NSString *)cicrleclassid {
    NSDictionary __block *rst = [[NSDictionary alloc] init];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT classify_id as id,classify_name as name,parent_classify_id as parent_id FROM we_circle_class where classify_id=? ",cicrleclassid];
        if (rs != nil)
        {
            while([rs next]) {
                rst=[rs resultDictionary];
                break;
            }
        }
        [rs close];
    }];
    
    return rst;
}

-(BOOL) insertGroupMessage:(NSString *)groupid UserJID:(NSString *)userjid Resource:(NSString *)resource NickName:(NSString *)nickname MessageType:(NSString *)type Content:(NSString*)content SendDateTime:(NSDate *)sendtime IsReceived:(BOOL)isReceived
{
    return [self insertGroupMessage:groupid UserJID:userjid Resource:resource NickName:nickname MessageType:type Content:content SendDateTime:sendtime IsReceived:isReceived xmlcontent:nil];
}

-(BOOL) insertGroupMessage:(NSString *)groupid UserJID:(NSString *)userjid Resource:(NSString *)resource NickName:(NSString *)nickname MessageType:(NSString *)type Content:(NSString*)content SendDateTime:(NSDate *)sendtime IsReceived:(BOOL)isReceived xmlcontent:(NSString*)xmlcontent;
{
    return [self insertGroupMessage:groupid UserJID:userjid Resource:resource NickName:nickname MessageType:type Content:content SendDateTime:sendtime IsReceived:isReceived xmlcontent:xmlcontent guid:nil];
}

-(BOOL) queryGroupMessage:(NSMutableArray *)recordArray withGroupID:(NSString *)groupid StartRow:(int)row MsgCount:(int)count
{
    BOOL __block rst=NO;
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sqlstr=[NSString stringWithFormat:@"SELECT a.guid, a.group_id, a.speaker_jid_bare, a.speaker_resource, ifnull(b.nick_name, a.speaker_name) speaker_name, a.msg_text, a.msg_time, a.msg_xml FROM im_message_group a left join we_staff b on b.fafa_jid=a.speaker_jid_bare WHERE a.group_id=? order by a.msg_time limit %d,%d",row,count];
        FMResultSet *rs = [db executeQuery:sqlstr,groupid];
        if (rs != nil)
        {
            while ([rs next]) {
                [recordArray addObject:[rs resultDictionary]];
                rst = YES;
            }
        }
        [rs close];
    }];
    return rst;
}

-(int) getGroupMessageCount:(NSString *)groupid
{
    int __block  rst=0;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT count(*) FROM im_message_group WHERE group_id=?",groupid];
        if (rs != nil && [rs next]) {
            rst = [rs intForColumnIndex:0];
        }
        [rs close];
    }];

    return rst;
}

-(BOOL) deleteGroupMessageByGUID:(NSString *)guid
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst = [db executeUpdate:@"DELETE FROM im_message_group WHERE guid=?", guid];
    }];
    
    return rst;
}

-(BOOL) deleteGroupMessageWithGroupid:(NSString *)groupid {
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst = [db executeUpdate:@"DELETE FROM im_message_group WHERE group_id=?", groupid];
    }];
    
    return rst;
}

-(BOOL) insertBusinessMessage:(NSString *)jid MessageCaption:(NSString *)caption Content:(NSString*)content SendDateTime:(NSDate*)time unreadnum:(int)unreadnum MessageType:(int)msg_type LinkString:(NSString *)link existButton:(BOOL)existbutton guid:(NSMutableString *)guid
{
    BOOL __block  rst=NO;
    guid.length>0?guid:[guid setString:[Utils genGUID]];
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSDate *gendate=time;
        //time=nil自动调整时间。排序在最后一个
        if (time==nil)
        {
            gendate=[NSDate date];
        }
//        1,关注。2，评论。3，评论回复。4，取消关注，10，点赞。20，分享。
//        FMResultSet * rsts= [db executeQuery:
//             @"delete from im_message_business where msg_type=?", @(1)];
//         [rsts close];
//        FMResultSet * rsts1= [db executeQuery:
//                             @"delete from im_message_business where msg_type=?", @(3)];
//        [rsts1 close];
//        FMResultSet * rsts2= [db executeQuery:
//                             @"delete from im_message_business where msg_type=?", @(4)];
//        [rsts2 close];
//        FMResultSet * rsts3= [db executeQuery:
//                             @"delete from im_message_business where msg_type=?", @(10)];
//        [rsts3 close];
//        FMResultSet * rsts4= [db executeQuery:
//                             @"delete from im_message_business where msg_type=?", @(20)];
//        [rsts4 close];
        FMResultSet *rs_s1 = [db executeQuery:@"SELECT max(msg_time) as max_time from im_message_single"];
        if (rs_s1 != nil && [rs_s1 next]) {
            NSDate *date_s1=[rs_s1 dateForColumn:@"max_time"];
            if (date_s1!=nil)
            {
                //gendate>date_s1
                gendate = ([gendate compare:date_s1]==NSOrderedDescending?gendate:date_s1);
            }
        }
        [rs_s1 close];
        FMResultSet *rs_g1 = [db executeQuery:@"SELECT max(msg_time) as max_time from im_message_group"];
        if (rs_g1 != nil && [rs_g1 next]) {
            NSDate *date_s2=[rs_g1 dateForColumn:@"max_time"];
            if (date_s2!=nil)
            {
                gendate = ([gendate compare:date_s2]==NSOrderedDescending?gendate:date_s2);
            }
        }
        [rs_g1 close];
        FMResultSet *rs = [db executeQuery:@"SELECT max(msg_time) as max_time from im_message_business"];
        if (rs != nil && [rs next]) {
            NSDate *date_b3=[rs dateForColumn:@"max_time"];
            if (date_b3!=nil)
            {
                gendate = ([gendate compare:date_b3]==NSOrderedDescending?gendate:date_b3);
            }
        }
        [rs close];
        if (gendate!=nil)
            gendate = [NSDate dateWithTimeInterval:0.001 sinceDate:gendate];
        //判断是否有相同的消息,并且状态是未读的情况下。只保存一条数据
        rs = [db executeQuery:@"SELECT count(*) from im_message_business where sender_jid_bare=? and business_caption=? and business_content=? and isread=? and msg_type=? and existbutton=?", jid,caption,content,@(unreadnum),@(msg_type),[NSNumber numberWithInt:existbutton?1:0]];
        BOOL isExist = NO;
        if (rs != nil) {
            while([rs next]) {
                if([rs intForColumnIndex:0] > 0) isExist = YES;
                break;
            }
        }
        [rs close];
        if (!isExist) {
            rst=[db executeUpdate:
                 @"INSERT INTO im_message_business(guid,sender_jid_bare,business_caption,business_content,msg_time,isread,msg_type,link,existbutton) "
                 "VALUES(?,?,?,?,?,?,?,?,?)",guid,jid,caption,content,gendate,@(unreadnum).stringValue,[NSNumber numberWithInt:msg_type],link,[NSNumber numberWithInt:existbutton?1:0]];
        }
    }];
    
    return rst;
}

-(BOOL) insertBusinessMessage_AboutMe:(NSString *)jid MessageCaption:(NSString *)caption Content:(NSString*)content SendDateTime:(NSDate*)time unreadnum:(int)unreadnum MessageType:(int)msg_type LinkString:(NSString *)link existButton:(BOOL)existbutton guid:(NSMutableString *)guid
{
    BOOL __block  rst=NO;
    int __block unreadnum_new=unreadnum;
    guid.length>0?guid:[guid setString:[Utils genGUID]];
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *oldunreadnum=@"0";
        FMResultSet *rs = [db executeQuery:@"SELECT * from im_message_business where msg_type=?", @(msg_type)];
        if (rs != nil)
        {
            while([rs next]) {
                oldunreadnum=[rs stringForColumn:@"isread"];
            }
            unreadnum_new=[oldunreadnum intValue];
            unreadnum_new++;
        }
        [rs close];
        rst=[db executeUpdate:
             @"delete from im_message_business where msg_type=?", @(msg_type)];
        rst=[db executeUpdate:
             @"INSERT INTO im_message_business(guid,sender_jid_bare,business_caption,business_content,msg_time,isread,msg_type,link,existbutton) "
             "VALUES(?,?,?,?,?,?,?,?,?)",guid,jid,caption,content,time,@(unreadnum_new).stringValue,[NSNumber numberWithInt:msg_type],link,[NSNumber numberWithInt:existbutton?1:0]];
    }];
    
    return rst;
}
-(BOOL) queryBusinessMessageWithGuid:(NSString*)elementId
{
    BOOL __block rst=NO;
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sqlstr=[NSString stringWithFormat:@"SELECT 1 FROM im_message_business WHERE guid=?"];
        FMResultSet *rs = [db executeQuery:sqlstr,elementId];
        if (rs!=nil)
        {
            while([rs next]) {
                rst=YES;
            }
        }
        [rs close];
    }];
    return rst;
}
-(NSArray*) queryBusinessMessageWithStartRow:(int)start withCount:(int)count
{
    NSMutableArray __block *rst = [NSMutableArray arrayWithCapacity:20];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT a.guid, a.sender_jid_bare, a.business_caption, a.business_content, a.msg_time, a.msg_type, a.link, a.existbutton,cast(b.unreadcount as varchar(8)) as isread FROM view_business_message_last_session a, view_business_message_unread_session b WHERE a.msg_type=b.msg_type order by a.msg_time desc limit %d, %d", start, count]];
        if (rs != nil)
        {
            while([rs next]) {
                [rst addObject:[rs resultDictionary]];
            }
        }
        [rs close];
    }];
    
    return rst;
}

-(NSArray*) queryBusinessMessageWithStartRow:(int)start withCount:(int)count withType:(NSArray*)msg_types
{
    NSMutableArray __block *rst = [NSMutableArray arrayWithCapacity:20];
    
    NSMutableString *sWH = [NSMutableString stringWithString:@"-1"];
    for (int i=0; i<msg_types.count; i++) {
        [sWH appendString:@",?"];
    }
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT a.guid, a.sender_jid_bare, a.business_caption, a.business_content, a.msg_time, a.isread, a.msg_type, a.link, a.existbutton FROM im_message_business a where msg_type in (%@) order by msg_time desc limit %d, %d", sWH, start, count] withArgumentsInArray:msg_types];
        if (rs != nil)
        {
            while([rs next]) {
                [rst addObject:[rs resultDictionary]];
            }
        }
        [rs close];
    }];
    
    return rst;
}

-(NSDictionary*)queryBusinessMessageWithGUID:(NSString*)guid
{
    NSDictionary __block *re = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT a.guid, a.sender_jid_bare, a.business_caption, a.business_content, a.msg_time, a.isread, a.msg_type, a.link, a.existbutton FROM im_message_business a where a.guid=?"], guid];
        if (rs != nil)
        {
            while([rs next]) {
                re= [rs resultDictionary];
            }
        }
        [rs close];
    }];
    
    return re;
}

-(BOOL)delBusinessMessageWithGuid:(NSString*)guid
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst = [db executeUpdate:@"delete from im_message_business where guid=?",guid];
    }];
    
    return rst;
}


-(BOOL)delBusinessMessageWithjid:(NSString*)jidbare withType:(int)msg_type
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst = [db executeUpdate:@"delete from im_message_business where sender_jid_bare=? and msg_type=?", jidbare, @(msg_type)];
    }];
    
    return rst;
}

//-(int) getBusinessUnreadCount
//{
//    int __block  rst=0;
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:@"select count(*) as count FROM im_message_business WHERE isread=?",0];
//        if (rs != nil && [rs next]) {
//            rst = [rs intForColumnIndex:0];
//        }
//        [rs close];
//    }];
//    
//    return rst;
//}

-(BOOL) setBusinessRead:(NSString*)guid
{
    BOOL __block  rst=NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst=[db executeUpdate:@"update im_message_business set isread='0' WHERE guid=?", guid];
    }];
    
    return rst;
}

-(BOOL) insertBusinessMessageButton:(NSString *)business_guid serial:(int)serial text:(NSString*)text code:(NSString *)code value:(NSString *)value link:(NSString *)link method:(NSString *)method blank:(NSString *)blank showremark:(NSString *)showremark remarklabel:(NSString *)remarklabel
{
    BOOL __block  rst=NO;
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst=[db executeUpdate:
             @"INSERT INTO im_message_business_buttons(business_guid,serial,text,code,value,link,method,blank,showremark,remarklabel) "
             "VALUES(?,?,?,?,?,?,?,?,?,?)",business_guid,[NSNumber numberWithInt:serial],text,code,value,link,method,blank,showremark,remarklabel];
    }];
    
    return rst;
}

-(BOOL) queryBusinessMessageButtons:(NSString *)businessGuid buttonArray:(NSMutableArray *)buttonArray
{
    BOOL __block  rst=NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM im_message_business_buttons where business_guid=? order by serial",businessGuid];
        if (rs != nil)
        {
            NSDictionary *dict_refuse=nil;
            while([rs next]) {
                if ([[rs stringForColumn:@"text"] isEqualToString:@"拒绝"]==NO)
                    [buttonArray addObject:[rs resultDictionary]];
                else
                    dict_refuse=[rs resultDictionary];
            }
            if (dict_refuse!=nil)
                [buttonArray addObject:dict_refuse];
            
            rst=YES;
        }
        [rs close];
    }];
    
    return rst;
}

-(BOOL)insertStaff:(SNSStaffFull*)staff
{
    BOOL __block rst = NO;
    if (staff!=nil && staff.login_account!=nil)
    {
        [dbQueue inDatabase:^(FMDatabase *db) {
            if (staff.ldap_uid.length==0)
            {
                NSString *old_ldap_uid=nil;
                NSString *old_openid=nil;
                static NSString *selSqlwe_staff = @"select ldap_uid,openid  \
                from we_staff \
                where fafa_jid=?";
                FMResultSet *rs = [db executeQuery:selSqlwe_staff, staff.jid];
                if (rs!=nil && [rs next]) {
                    old_ldap_uid=[rs stringForColumnIndex:0];
                    old_openid=[rs stringForColumnIndex:1];
                }
                [rs close];
                
                if (old_ldap_uid.length>0)
                    staff.ldap_uid=[[NSString alloc] initWithFormat:@"%@",old_ldap_uid];
                if (old_openid.length>0)
                    staff.openid=[[NSString alloc] initWithFormat:@"%@",old_openid];
            }
            
            [db executeUpdate:@"delete from we_staff where login_account=?", staff.login_account];
            rst = [db executeUpdate:@"insert into we_staff(login_account, nick_name, photo_path, photo_path_small, photo_path_big, dept_id, dept_name, eno, ename, eshortname, self_desc, duty, birthday, specialty, hobby, work_phone, mobile, mobile_is_bind, total_point, register_date, active_date, attenstaff_num, fans_num, publish_num, fafa_jid, micro_use,sex_id,openid,ldap_uid) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?)",
                   staff.login_account, staff.nick_name, staff.photo_path, staff.photo_path_small, staff.photo_path_big, staff.dept_id, staff.dept_name, staff.eno, staff.ename, staff.eshortname, staff.self_desc, staff.duty, staff.birthday, staff.specialty, staff.hobby, staff.work_phone, staff.mobile, staff.mobile_is_bind, [NSNumber numberWithDouble:staff.total_point], staff.register_date, staff.active_date, [NSNumber numberWithInt:staff.attenstaff_num], [NSNumber numberWithInt:staff.fans_num], [NSNumber numberWithInt:staff.publish_num], staff.jid, staff.micro_use,staff.sex_id,staff.openid,staff.ldap_uid];
        }];
    }
    return rst;
}

//business
-(BOOL)updateStaff:(NSString *)jid PhotoName:(NSString *)photo_path Desc:(NSString*)self_desc bindMobile:(NSString *)bind
{
    BOOL __block rst = NO;
    NSMutableArray *para = [NSMutableArray arrayWithCapacity:2];
    NSMutableString *updateset=[[NSMutableString alloc] initWithFormat:@"update we_staff set "];
    if ([photo_path length]>0)
    {
        [updateset appendString:@" photo_path=?"];
        [para addObject:photo_path];
    }
    if ([self_desc length]>0)
    {
        if ([para count]>0) [updateset appendString:@", "];
        [updateset appendString:@"self_desc=?"];
        [para addObject:self_desc];
    }
    if ([bind length]>0)
    {
        if ([para count]>0) [updateset appendString:@", "];
        [updateset appendString:@"mobile_is_bind=?"];
        [para addObject:bind];
    }
    if ([para count]==0)
        return NO;
    
    [updateset appendString:@" where fafa_jid=? "];
    [para addObject:jid];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *selSqlwe_staff = @"select count(*) as cnt from we_staff where fafa_jid=?";
        FMResultSet *rs = [db executeQuery:selSqlwe_staff, jid];
        BOOL isExist=NO;
        if (rs != nil && [rs next]) {
            isExist=[rs intForColumn:@"cnt"]>0;
        }
        [rs close];
        
        if (isExist)
            rst = [db executeUpdate:updateset withArgumentsInArray:para];
        
    }];
    return rst;
}

-(BOOL)updateStaff:(NSString *)jid PhotoPath:(NSString *)photoPath PhotoPathBig:(NSString *)photoPathBig PhotoPathSmall:(NSString *)photoPathSmall {
    BOOL __block rst = NO;
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *selSql= @"select count(*) as count from we_staff where fafa_jid=?";
        FMResultSet *rs = [db executeQuery:selSql, jid];
        BOOL isExist=NO;
        if (rs != nil && [rs next]) {
            isExist=[rs intForColumn:@"count"]>0;
        }
        [rs close];
        
        if (isExist) {
            rst = [db executeUpdate:@"update we_staff set photo_path=? , photo_path_small=? , photo_path_big=? where fafa_jid=?",photoPath,photoPathSmall,photoPathBig,jid];
        }
        
    }];
    return rst;
}

//-(BOOL)getStaffFullByJid:(NSString*)jidbare StaffInfo:(NSMutableDictionary *)staff
//{
//    BOOL __block re = NO;
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        static NSString *selSqlwe_staff = @"select login_account, nick_name, photo_path, photo_path_small, photo_path_big, dept_id, dept_name, eno, ename, eshortname, self_desc, duty, birthday , specialty, hobby, work_phone, mobile , mobile_is_bind, total_point, register_date, active_date, attenstaff_num, fans_num , publish_num, fafa_jid \
//        from we_staff \
//        where fafa_jid=?";
//        FMResultSet *rs = [db executeQuery:selSqlwe_staff, jidbare];
//        if (rs != nil && [rs next]) {
//            [staff addEntriesFromDictionary:[rs resultDictionary]];
//            re=YES;
//        }
//        [rs close];
//    }];
//    
//    return re;
//}

-(SNSStaffFull*)rsRow2SNSStaffFull:(FMResultSet*)rs staff:(SNSStaffFull*)staff
{
    staff.login_account = [rs stringForColumn:@"login_account"];
    staff.nick_name = [rs stringForColumn:@"nick_name"];
    staff.photo_path = [Utils getSNSString:[rs stringForColumn:@"photo_path"]];
    staff.photo_path_small = [Utils getSNSString:[rs stringForColumn:@"photo_path_small"]];
    staff.photo_path_big = [Utils getSNSString:[rs stringForColumn:@"photo_path_big"]];
    staff.eshortname = [rs stringForColumn:@"eshortname"];
    staff.dept_id = [rs stringForColumn:@"dept_id"];
    staff.dept_name = [Utils getSNSString:[rs stringForColumn:@"dept_name"]];
    staff.eno = [rs stringForColumn:@"eno"];
    staff.ename = [rs stringForColumn:@"ename"];
    staff.self_desc = [Utils getSNSString:[rs stringForColumn:@"self_desc"]];
    staff.duty = [rs stringForColumn:@"duty"];
    staff.birthday = [rs dateForColumn:@"birthday"];
    staff.specialty = [rs stringForColumn:@"specialty"];
    staff.hobby = [rs stringForColumn:@"hobby"];
    staff.work_phone = [Utils getSNSString:[rs stringForColumn:@"work_phone"]];
    staff.mobile = [Utils getSNSString:[rs stringForColumn:@"mobile"]];
    staff.mobile_is_bind = [rs stringForColumn:@"mobile_is_bind"];
    staff.total_point = [rs doubleForColumn:@"total_point"];
    staff.register_date = [rs dateForColumn:@"register_date"];
    staff.active_date = [rs dateForColumn:@"active_date"];
    staff.attenstaff_num = [rs intForColumn:@"attenstaff_num"];
    staff.fans_num = [rs intForColumn:@"fans_num"];
    staff.publish_num = [rs intForColumn:@"publish_num"];
    staff.jid = [rs stringForColumn:@"fafa_jid"];
    staff.micro_use = [rs stringForColumn:@"micro_use"];
    staff.sex_id = [rs stringForColumn:@"sex_id"];
    staff.openid = [Utils getSNSString:[rs stringForColumn:@"openid"]];
    staff.ldap_uid = [Utils getSNSString:[rs stringForColumn:@"ldap_uid"]];

    return staff;
}

-(BOOL)getStaffFullByJid:(NSString*)jidbare stafffull:(SNSStaffFull *)staff
{
    BOOL __block re = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *selSqlwe_staff = @"select * \
        from we_staff \
        where fafa_jid=?";
        FMResultSet *rs = [db executeQuery:selSqlwe_staff, jidbare];
        if (rs != nil && [rs next]) {
            [self rsRow2SNSStaffFull:rs staff:staff];
            re=YES;
        }
        [rs close];
    }];
    
    return re;
}

-(BOOL)getStaffFullByEmail:(NSString*)email stafffull:(SNSStaffFull *)staff
{
    BOOL __block re = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *selSqlwe_staff = @"select *  \
        from we_staff \
        where login_account=?";
        FMResultSet *rs = [db executeQuery:selSqlwe_staff, email];
        if (rs != nil && [rs next]) {
            [self rsRow2SNSStaffFull:rs staff:staff];
            re=YES;
        }
        [rs close];
    }];
    
    return re;
}

//-(NSString*)getStaffPhotoPath:(NSString*)jidbare
//{
//    NSString __block *re = @"";
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:@"select photo_path from we_staff where fafa_jid=?", jidbare];
//        if (rs != nil && [rs next]) {
//            re = [rs stringForColumnIndex:0];
//        }
//        [rs close];
//    }];
//    
//    return re;
//}
//-(NSString*)getStaffPhotoPathSmall:(NSString*)jidbare
//{
//    NSString __block *re = @"";
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:@"select photo_path_small from we_staff where fafa_jid=?", jidbare];
//        if (rs != nil && [rs next]) {
//            re = [rs stringForColumnIndex:0];
//        }
//        [rs close];
//    }];
//    
//    return re;
//}
//-(NSString*)getStaffPhotoPathBig:(NSString*)jidbare
//{
//    NSString __block *re = @"";
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:@"select photo_path_big from we_staff where fafa_jid=?", jidbare];
//        if (rs != nil && [rs next]) {
//            re = [rs stringForColumnIndex:0];
//        }
//        [rs close];
//    }];
//    
//    return re;
//}
//
-(NSString*)getStaffDescByLoginAccount:(NSString*)login_account
{
    NSString __block *re = @"";
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select self_desc from we_staff where login_account=?", login_account];
        if (rs != nil && [rs next]) {
            re = [rs stringForColumnIndex:0];
        }
        [rs close];
    }];
    
    return re;
}
//-(NSString*)getStaffDescByJid:(NSString*)jidbare
//{
//    NSString __block *re = @"";
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:@"select self_desc from we_staff where fafa_jid=?", jidbare];
//        if (rs != nil && [rs next]) {
//            re = [rs stringForColumnIndex:0];
//        }
//        [rs close];
//    }];
//    
//    return re;
//}
//
//-(NSString*)getStaffNickByJid:(NSString*)jidbare
//{
//    NSString __block *re = @"";
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:@"select nick_name from we_staff where fafa_jid=?", jidbare];
//        if (rs != nil && [rs next]) {
//            re = [rs stringForColumnIndex:0];
//        }
//        [rs close];
//    }];
//    
//    return re;
//}

//取好友和企业成员
- (NSArray *)getStaffList:(NSString *)fafaJid {
    NSMutableArray *re=[NSMutableArray arrayWithCapacity:5];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sqlim_roster = @"select DISTINCT * from ( select b.* from im_roster a  left join we_staff b on a.jid=b.fafa_jid where b.fafa_jid is not null and b.login_account is not null UNION select c.* from we_staff c where c.eno=(select eno from we_staff where fafa_jid=? LIMIT 0,1) and c.fafa_jid!=? and c.login_account not in ('sysadmin@fafatime.com','service@fafatime.com','corp@fafatime.com'))";
        
        FMResultSet *rs = [db executeQuery:sqlim_roster,fafaJid,fafaJid];
        while (rs != nil && [rs next]) {
            [re addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return re;
}

-(NSArray*)getRosterJidStrs
{
    NSMutableArray* re = [NSMutableArray arrayWithCapacity:15];

    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sqlim_roster = @"select jid from im_roster";

        FMResultSet *rs = [db executeQuery:sqlim_roster];
        while (rs != nil && [rs next]) {
            [re addObject:[rs stringForColumn:@"jid"]];
        }
        [rs close];
    }];
    
    return re;    
}
-(BOOL)clearRoster
{
    BOOL __block re = NO;

    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sqlDelcache_im_resource = @"delete from cache_im_resource";        
        static NSString *sqlDelim_rostergroup = @"delete from im_rostergroup";
        static NSString *sqlDelim_roster = @"delete from im_roster";
        
        [db executeUpdate:sqlDelcache_im_resource];
        [db executeUpdate:sqlDelim_rostergroup];
        [db executeUpdate:sqlDelim_roster];
        
        re = YES;
    }];
    
    return re;
}

-(BOOL)insertRoster:(NSString*)jidbare nick:(NSString*)nick subscription:(NSString*)subscription groups:(NSArray*)groups
{
    BOOL __block re = NO;

    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *insSql_im_roster = @"insert into im_roster(jid, nick, subscription) select ?, ?, ? where not exists(select 1 from im_roster where jid=?)";
        static NSString *insSql_im_rostergroup = @"insert into im_rostergroup(jid, groupname) select ?, ? where not exists(select 1 from im_rostergroup where jid=? and groupname=?)";
                
        [db executeUpdate:insSql_im_roster, jidbare, nick, subscription, jidbare];
        for (NSString *groupname in groups)
        {
            [db executeUpdate:insSql_im_rostergroup, jidbare, groupname, jidbare, groupname];
        }
        
        re = YES;
    }];
    
    return re;
}

-(BOOL)deleteRoster:(NSString*)jidbare
{
    BOOL __block re = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
//        static NSString *sqlDelcache_im_resource = @"delete from cache_im_resource where jidbare=?";
        static NSString *sqlDelim_rostergroup = @"delete from im_rostergroup where jid=?";
        static NSString *sqlDelim_roster = @"delete from im_roster where jid=?";
        
//        [db executeUpdate:sqlDelcache_im_resource, jidbare];
        [db executeUpdate:sqlDelim_rostergroup, jidbare];
        [db executeUpdate:sqlDelim_roster, jidbare];
        
        re = YES;
    }];
    
    return re;
}

-(NSArray*)getRosterGroups:(NSString*)jidbare
{
    NSMutableArray* re = [NSMutableArray arrayWithCapacity:1];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sqlim_roster = @"select groupname from im_rostergroup where jid=?";
        
        FMResultSet *rs = [db executeQuery:sqlim_roster, jidbare];
        while (rs != nil && [rs next]) {
            [re addObject:[rs stringForColumn:@"groupname"]];
        }
        [rs close];
    }];
    
    return re;
}

//-(BOOL)saveRoster:(NSArray*)friendArray
//{
//    BOOL __block re = NO;
//
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:@"delete from im_rostergroup"];
//        [db executeUpdate:@"delete from im_roster"];
//        
//        NSString *insSql_im_roster = @"insert into im_roster(jid, nick, subscription) values(?, ?, ?)";
//        NSString *insSql_im_rostergroup = @"insert into im_rostergroup(jid, groupname) select ?, ? where not exists(select 1 from im_rostergroup where jid=? and  groupname=?)";
//        for (FriendObject *foA in friendArray)
//        {
//            [db executeUpdate:insSql_im_roster, foA.JID, foA.Name, [NSString stringWithFormat:@"%d", foA.SubScription]];
//            for (NSString *groupname in foA.groups)
//            {
//                [db executeUpdate:insSql_im_rostergroup, foA.JID, groupname, foA.JID, groupname];
//            }
//        }
//    }];
//    
//    return re;
//}

-(NSArray*)getIMFriendGroups
{
    NSMutableArray* re = [NSMutableArray arrayWithCapacity:1];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sqlim_roster = @"select groupname from im_friendgroups order by noorder";
        
        FMResultSet *rs = [db executeQuery:sqlim_roster];
        while (rs != nil && [rs next]) {
            [re addObject:[rs stringForColumn:@"groupname"]];
        }
        [rs close];
    }];
    
    return re;    
}

-(BOOL)saveIMFriendGroups:(NSArray*)friendGroupArray
{
    BOOL __block re = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from im_friendgroups"];
        
        NSString *insSql_im_friendgroups = @"insert into im_friendgroups(groupname, noorder) values(?, ?)";
        int noorder = 10;  //从10开始，前面预留几个位置
        for (NSString *groupname in friendGroupArray)
        {
            [db executeUpdate:insSql_im_friendgroups, groupname, [NSNumber numberWithInt:noorder++]];
        }
    }];
    
    return re;
}

-(NSArray*)getRosterInner:(NSString*)Aeno
{
    NSMutableArray* re = [NSMutableArray arrayWithCapacity:1];
     
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sqlim_roster_inner = @"select jid from im_roster a \
        where not exists(select 1 from im_rostergroup b, im_friendgroups c where b.groupname=c.groupname and b.jid=a.jid and c.groupname<>'内部联系人') \
        and a.jid like  ('%-' || ? || '@%')";
        
        FMResultSet *rs = [db executeQuery:sqlim_roster_inner, Aeno];
        while (rs != nil && [rs next]) {
            [re addObject:[rs stringForColumn:@"jid"]];
        }
        [rs close];
    }];
    
    return re;
}

-(NSArray*)getRosterOuter:(NSString*)Aeno
{
    NSMutableArray* re = [NSMutableArray arrayWithCapacity:1];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sqlim_roster_outer = @"select jid from im_roster a \
        where not exists(select 1 from im_rostergroup b, im_friendgroups c where b.groupname=c.groupname and b.jid=a.jid and c.groupname<>'外部联系人') \
        and a.jid not like  ('%-' || ? || '@%')";
        
        FMResultSet *rs = [db executeQuery:sqlim_roster_outer, Aeno];
        while (rs != nil && [rs next]) {
            [re addObject:[rs stringForColumn:@"jid"]];
        }
        [rs close];
    }];
    
    return re;
}

-(NSArray*)getRosterByGroupName:(NSString*)Agroupname
{
    NSMutableArray* re = [NSMutableArray arrayWithCapacity:1];
    
    [dbQueue inDatabase:^(FMDatabase *db) {        
        static NSString *sqlim_roster_normal = @"select b.jid from im_rostergroup b, im_friendgroups c \
        where b.groupname=c.groupname \
          and b.groupname=?";
        
        FMResultSet *rs = [db executeQuery:sqlim_roster_normal, Agroupname];
        while (rs != nil && [rs next]) {
            [re addObject:[rs stringForColumn:@"jid"]];
        }
        [rs close];
    }];
    
    return re;
}

-(BOOL)saveRosterResource:(NSString *)jidbare resource:(NSString*)resource pres_xml:(NSString*)pres_xml pres_date:(NSDate*)pres_date
{
    BOOL __block re = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sqlDelcache_im_resource = @"delete from cache_im_resource where jidbare=? and jidresource=?";
        static NSString *sqlInscache_im_resource = @"insert into cache_im_resource (jidbare, jidresource, pres_xmlstr, pres_date) values(?, ?, ?, ?)";
        
        [db executeUpdate:sqlDelcache_im_resource, jidbare, resource];
        [db executeUpdate:sqlInscache_im_resource, jidbare, resource, pres_xml, pres_date];
        
        re = YES;
    }];
    
    return re;
}

-(BOOL)deleteRosterResource:(NSString *)jidbare resource:(NSString*)resource
{
    BOOL __block re = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sqlDelcache_im_resource = @"delete from cache_im_resource where jidbare=? and jidresource=?";
        
        [db executeUpdate:sqlDelcache_im_resource, jidbare, resource];
        
        re = YES;
    }];
    
    return re;
}

-(NSArray*)getRosterResource:(NSString *)jidbare
{
    NSMutableArray* re = [NSMutableArray arrayWithCapacity:1];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sqlcache_im_resource = @"select jidbare, jidresource, pres_xmlstr, pres_date from cache_im_resource where jidbare=?";
        
        FMResultSet *rs = [db executeQuery:sqlcache_im_resource, jidbare];
        while (rs != nil && [rs next]) {
            [re addObject:@{@"jidbare":[rs stringForColumn:@"jidbare"],
             @"jidresource":[rs stringForColumn:@"jidresource"],
             @"pres_xmlstr":[rs stringForColumn:@"pres_xmlstr"],
             @"pres_date":[rs dateForColumn:@"pres_date"]}];
        }
        [rs close];
    }];
    
    return re;
}

-(BOOL)clearAllRosterResource
{
    BOOL __block re = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sqlDelcache_im_resource = @"delete from cache_im_resource";
        
        [db executeUpdate:sqlDelcache_im_resource];
        
        re = YES;
    }];
    
    return re;
}

-(SNSConv*)rsRow2SNSConv:(FMResultSet*)rs
{
    SNSConv * conv = [[SNSConv alloc] init];
    
    conv.iscollect=[[NSMutableString alloc] initWithFormat:@"0"];
    conv.conv_id = [rs stringForColumn:@"conv_id"];
    conv.create_staff = [rs stringForColumn:@"create_staff"];
    
    SNSStaff *create_staff_obj = [[SNSStaff alloc] init];
    create_staff_obj.login_account = [rs stringForColumn:@"login_account"];
    create_staff_obj.nick_name = [rs stringForColumn:@"nick_name"];
    create_staff_obj.photo_path = [Utils getSNSString:[rs stringForColumn:@"photo_path"]];
    create_staff_obj.photo_path_small = [Utils getSNSString:[rs stringForColumn:@"photo_path_small"]];
    create_staff_obj.photo_path_big = [Utils getSNSString:[rs stringForColumn:@"photo_path_big"]];
    conv.create_staff_obj = create_staff_obj;
    
    conv.post_date = [rs dateForColumn:@"post_date"];
    conv.conv_type_id = [rs stringForColumn:@"conv_type_id"];
    conv.conv_content = [rs stringForColumn:@"conv_content"];
    conv.copy_num = [rs intForColumn:@"copy_num"];
    conv.reply_num = [rs intForColumn:@"reply_num"];
    conv.atten_num = [rs intForColumn:@"atten_num"];
    conv.like_num = [rs intForColumn:@"like_num"];
    NSString *iscollect=[rs stringForColumn:@"iscollect"];
    if (iscollect!=nil)
        [conv.iscollect setString:iscollect];
    conv.comefrom = [rs stringForColumn:@"comefrom"];
    conv.post_to_group = [rs stringForColumn:@"post_to_group"];
    conv.circle_id = [rs stringForColumn:@"circle_id"];    
    conv.conv_root_id = [rs stringForColumn:@"conv_root_id"];
    
    return conv;
}

-(SNSLike*)rsRow2SNSLike:(FMResultSet*)rs
{
    SNSLike *snslike=[[SNSLike alloc] init];
    snslike.like_staff = [rs stringForColumn:@"like_staff"];
    snslike.like_staff_nickname = [rs stringForColumn:@"like_staff_nickname"];
    snslike.like_date = [rs dateForColumn:@"like_date"];
    
    return snslike;
}

-(SNSAttach*)rsRow2SNSAttach:(FMResultSet*)rs
{
    SNSAttach *snsattach=[[SNSAttach alloc] init];
    snsattach.attach_id = [rs stringForColumn:@"attach_id"];
    snsattach.file_name = [rs stringForColumn:@"file_name"];
    snsattach.file_ext = [rs stringForColumn:@"file_ext"];
    snsattach.up_by_staff = [rs stringForColumn:@"up_by_staff"];
    snsattach.up_date = [rs dateForColumn:@"up_date"];

    return snsattach;
}

-(SNSReply*)rsRow2SNSReply:(FMResultSet*)rs
{
    SNSReply *snsreply=[[SNSReply alloc] init];
    snsreply.reply_id = [rs stringForColumn:@"reply_id"];
    snsreply.reply_staff = [rs stringForColumn:@"reply_staff"];
    
    SNSStaff *reply_staff_obj = [[SNSStaff alloc] init];
    reply_staff_obj.login_account = [rs stringForColumn:@"login_account"];
    reply_staff_obj.nick_name = [rs stringForColumn:@"nick_name"];
    reply_staff_obj.photo_path = [Utils getSNSString:[rs stringForColumn:@"photo_path"]];
    reply_staff_obj.photo_path_small = [Utils getSNSString:[rs stringForColumn:@"photo_path_small"]];
    reply_staff_obj.photo_path_big = [Utils getSNSString:[rs stringForColumn:@"photo_path_big"]];
    snsreply.reply_staff_obj = reply_staff_obj;
    
    snsreply.reply_date = [rs dateForColumn:@"reply_date"];
    snsreply.reply_content = [rs stringForColumn:@"reply_content"];
    snsreply.reply_to = [rs stringForColumn:@"reply_to"];
    snsreply.reply_to_nickname = [rs stringForColumn:@"reply_to_nickname"];
    snsreply.like_num = [rs intForColumn:@"like_num"];
    snsreply.comefrom = [rs stringForColumn:@"comefrom"];
    
    return snsreply;
}
-(SNSTogether*)rsRow2SNSTogether:(FMResultSet*)rs
{    
    SNSTogether *together=[[SNSTogether alloc] init];
    together.title = [rs stringForColumn:@"title"];
    together.will_date = [rs dateForColumn:@"will_date"];
    together.will_dur = [rs stringForColumn:@"will_dur"];
    together.will_addr = [rs stringForColumn:@"will_addr"];
    together.together_desc = [rs stringForColumn:@"together_desc"];
    
    return together;
}

-(SNSTogetherStaff*)rsRow2SNSTogetherStaff:(FMResultSet*)rs
{
    SNSTogetherStaff *staff=[[SNSTogetherStaff alloc] init];
    staff.staff_id = [rs stringForColumn:@"staff_id"];
    staff.staff_name = [rs stringForColumn:@"staff_name"];
    
    return staff;
}

-(SNSVote*)rsRow2SNSVote:(FMResultSet*)rs
{
    SNSVote *vote=[[SNSVote alloc] init];
    vote.title = [rs stringForColumn:@"title"];
    vote.vote_all_num = [rs intForColumn:@"vote_all_num"];
    vote.is_multi = [rs stringForColumn:@"is_multi"];
    vote.finishdate = [rs dateForColumn:@"finishdate"];
    vote.isvoted = [rs stringForColumn:@"isvoted"];
    vote.vote_user_num = [rs intForColumn:@"vote_user_num"];
    
    return vote;
}

-(SNSVoteOption*)rsRow2SNSVoteOption:(FMResultSet*)rs
{
    SNSVoteOption *voteoption=[[SNSVoteOption alloc] init];
    
    voteoption.option_id = [rs stringForColumn:@"option_id"];
    voteoption.option_desc = [Utils getSNSString:[rs stringForColumn:@"option_desc"]];
    voteoption.vote_num = [rs intForColumn:@"vote_num"];
    
    return voteoption;
}

- (void)loadConvChild:(SNSConv *)conv db:(FMDatabase *)db
{
    FMResultSet *rs;
    
    static NSString *sqlwe_like = @"select conv_id, like_staff, like_staff_nickname, like_date from we_like where conv_id=?";
    static NSString *sqlwe_attach = @"select conv_id, attach_id, file_name, file_ext, up_by_staff, up_date from we_attach where conv_id=?";
    static NSString *sqlwe_reply = @"select a.conv_id, a.reply_id, a.reply_staff, a.reply_date, a.reply_content, \
    a.reply_to, a.reply_to_nickname, a.like_num, a.comefrom, \
    b.login_account, b.nick_name, b.photo_path, b.photo_path_small, b.photo_path_big  \
    from we_reply a, we_staff b \
    where a.reply_staff=b.login_account \
      and a.conv_id=? \
    order by a.reply_id+0 desc";
    static NSString *sqlwe_together = @"select conv_id, title, will_date, will_dur, will_addr, together_desc from we_together where conv_id=?";
    static NSString *sqlwe_together_staff = @"select conv_id, staff_id, staff_name from we_together_staff where conv_id=?";
    static NSString *sqlwe_vote = @"select conv_id, title, vote_all_num, is_multi, finishdate, isvoted, vote_user_num from we_vote where conv_id=?";
    static NSString *sqlwe_vote_option = @"select conv_id, option_id, option_desc, vote_num from we_vote_option where conv_id=?";
    static NSString *sqlwe_conv_copy = @"select \
    a.conv_id, a.create_staff, a.post_date, a.conv_type_id, a.conv_content, a.copy_num, \
    a.reply_num, a.atten_num, a.like_num, a.iscollect, a.comefrom, a.post_to_group, a.circle_id, a.conv_root_id, \
    b.login_account, b.nick_name, b.photo_path, b.photo_path_small, b.photo_path_big  \
    from we_conv a, we_staff b \
    where a.create_staff=b.login_account \
    and a.conv_id=? ";
    static NSString *sqlwe_reply_attach = @"select conv_id, reply_id, attach_id, file_name, file_ext, up_by_staff, up_date from we_reply_attach where conv_id=? and reply_id=?";
    
    conv.iscollect=[[NSMutableString alloc] initWithFormat:@"0"];
    
    rs = [db executeQuery:sqlwe_like, conv.conv_id];
    conv.likes=[[NSMutableArray alloc] init];
    while (rs != nil && [rs next]) {
        [conv.likes addObject:[self rsRow2SNSLike:rs]];
    }
    [rs close];
    
    rs = [db executeQuery:sqlwe_attach, conv.conv_id];
    conv.attachs=[[NSMutableArray alloc] init];
    while (rs != nil && [rs next]) {
        [conv.attachs addObject:[self rsRow2SNSAttach:rs]];
    }
    [rs close];
    
    rs = [db executeQuery:sqlwe_reply, conv.conv_id];
    conv.replys=[[NSMutableArray alloc] init];
    while (rs != nil && [rs next]) {
        [conv.replys addObject:[self rsRow2SNSReply:rs]];
    }
    [rs close];
    
    //回复的附件
    for (SNSReply *reply in conv.replys) {
        rs = [db executeQuery:sqlwe_reply_attach, conv.conv_id, reply.reply_id];
        reply.attachs=[[NSMutableArray alloc] init];
        while (rs != nil && [rs next]) {
            [reply.attachs addObject:[self rsRow2SNSAttach:rs]];
        }
        [rs close];
    }
    
    if ([@"02" isEqualToString:conv.conv_type_id])
    {
        rs = [db executeQuery:sqlwe_together, conv.conv_id];
        if (rs != nil && [rs next]) {
            conv.together = [self rsRow2SNSTogether:rs];
        }
        [rs close];                
        
        rs = [db executeQuery:sqlwe_together_staff, conv.conv_id];
        conv.together.together_staffs=[[NSMutableArray alloc] init];
        while (rs != nil && [rs next]) {
            [conv.together.together_staffs addObject:[self rsRow2SNSTogetherStaff:rs]];                    
        }
        [rs close];                
    }
    
    if ([@"03" isEqualToString:conv.conv_type_id])
    {
        rs = [db executeQuery:sqlwe_vote, conv.conv_id];
        if (rs != nil && [rs next]) {
            conv.vote = [self rsRow2SNSVote:rs];
        }
        [rs close];                
        
        rs = [db executeQuery:sqlwe_vote_option, conv.conv_id];
        conv.vote.vote_options=[[NSMutableArray alloc] init];
        while (rs != nil && [rs next]) {
            [conv.vote.vote_options addObject:[self rsRow2SNSVoteOption:rs]];
        }
        [rs close];
    }
    
    if ([@"05" isEqualToString:conv.conv_type_id])
    {
        rs = [db executeQuery:sqlwe_conv_copy, conv.conv_root_id];
        if (rs != nil && [rs next]) {
            conv.conv_copy = [self rsRow2SNSConv:rs];
        }
        [rs close];
        [self loadConvChild:(SNSConv*)conv.conv_copy db:db];
    }
}

-(NSArray*)getConv:(NSString*)circleid groupid:(NSString*)groupid lastid:(NSString*)lastid
{
    NSMutableArray* re = [NSMutableArray arrayWithCapacity:15];
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:@"SELECT * FROM we_conv"];
//        while (rs != nil && [rs next]) {
//            NSLog(@"%@", [rs stringForColumn:@"circle_id"]);
//        }
//        [rs close];
//    }];

    [dbQueue inDatabase:^(FMDatabase *db) {
        NSMutableString *sqlwe_conv = [NSMutableString stringWithString:@"\
                                       select \
                                         a.conv_id, a.create_staff, a.post_date, a.conv_type_id, a.conv_content, a.copy_num, \
                                         a.reply_num, a.atten_num, a.like_num, a.iscollect, a.comefrom, a.post_to_group, a.circle_id, a.conv_root_id, \
                                         b.login_account, b.nick_name, b.photo_path, b.photo_path_small, b.photo_path_big  \
                                       from we_conv a, we_staff b \
                                       where a.create_staff=b.login_account \
                                         and a.circle_id=? "];
        NSMutableArray *para = [NSMutableArray arrayWithCapacity:10];
        [para addObject:circleid];
        
        if (groupid == nil || [groupid length] == 0)
        {
            [sqlwe_conv appendString:@" and post_to_group in ('ALL', 'PRIVATE') "];
        }
        else
        {
            [sqlwe_conv appendString:@" and post_to_group=? "];
            [para addObject:groupid];
        }
        if (lastid != nil && [lastid length] > 0)
        {
            [sqlwe_conv appendString:@" and conv_id+0<?+0 "];
            [para addObject:lastid];
        }
        
        [sqlwe_conv appendString:@" order by conv_id+0 desc limit 0, 15 "];
        
        FMResultSet *rs = [db executeQuery:sqlwe_conv withArgumentsInArray:para];
        while (rs != nil && [rs next]) {
            [re addObject:[self rsRow2SNSConv:rs]];
        }
        [rs close];
        
        for (SNSConv *conv in re)
        {
            [self loadConvChild:conv db:db];
        }
    }];
    
    return re;
}

-(BOOL)saveConvs:(NSArray*)convs;
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *selSqlwe_circle = @"select conv_id,conv_content,circle_id,post_to_group from we_conv where conv_id=?";
        static NSString *selSqlwe_conv = @"select count(*) c from we_conv where conv_id=?";
        static NSString *delSqlwe_conv = @"delete from we_conv where conv_id=?";
        static NSString *insSqlwe_conv = @"insert into we_conv(conv_id, create_staff, post_date, conv_type_id, conv_content, copy_num, reply_num, atten_num, like_num, iscollect, comefrom, post_to_group, circle_id, conv_root_id) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        static NSString *delSqlwe_like = @"delete from we_like where conv_id=?";
        static NSString *insSqlwe_like = @"insert into we_like(conv_id, like_staff, like_staff_nickname, like_date) values(?, ?, ?, ?)";
        static NSString *delSqlwe_attach = @"delete from we_attach where conv_id=?";
        static NSString *insSqlwe_attach = @"insert into we_attach(conv_id, attach_id, file_name, file_ext, up_by_staff, up_date) values(?, ?, ?, ?, ?, ?)";
        static NSString *delSqlwe_together = @"delete from we_together where conv_id=?";
        static NSString *insSqlwe_together = @"insert into we_together(conv_id, title, will_date, will_dur, will_addr, together_desc) values(?, ?, ?, ?, ?, ?)";
        static NSString *delSqlwe_together_staff = @"delete from we_together_staff where conv_id=?";
        static NSString *insSqlwe_together_staff = @"insert into we_together_staff(conv_id, staff_id, staff_name) values(?, ?, ?)";
        static NSString *delSqlwe_vote = @"delete from we_vote where conv_id=?";
        static NSString *insSqlwe_vote = @"insert into we_vote(conv_id, title, vote_all_num, is_multi, finishdate, isvoted, vote_user_num) values(?, ?, ?, ?, ?, ?, ?)";
        static NSString *delSqlwe_vote_option = @"delete from we_vote_option where conv_id=?";
        static NSString *insSqlwe_vote_option = @"insert into we_vote_option(conv_id, option_id, option_desc, vote_num) values(?, ?, ?, ?)";
        static NSString *delSqlwe_reply = @"delete from we_reply where conv_id=?";
        static NSString *insSqlwe_reply = @"insert into we_reply(conv_id, reply_id, reply_staff, reply_date, reply_content, reply_to, reply_to_nickname, like_num, comefrom) values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        static NSString *selSqlwe_staff = @"select count(*) c from we_staff where login_account=?";
        static NSString *insSqlwe_staff = @"insert into we_staff(login_account, nick_name, photo_path, photo_path_small, photo_path_big, eshortname) values(?, ?, ?, ?, ?, ?)";
        
        for (SNSConv *conv in convs) {
            
//            NSMutableString *sqlwe_conv12 = [NSString stringWithFormat:@"\
//                                             select * from we_conv"];
//            FMResultSet *rs12 = [db executeQuery:sqlwe_conv12];
//            int icount=0;
//            while (rs12 != nil && [rs12 next]) {
//                icount++;
//            }
//            [rs12 close];
            
            FMResultSet *rs = [db executeQuery:selSqlwe_circle, conv.conv_id];
            if (rs != nil && [rs next]) {
                if (conv.circle_id==nil)
                {
                    NSString *circle_id=[rs stringForColumn:@"circle_id"];
                    conv.circle_id = circle_id==nil?@"":circle_id;
                }
                if (conv.post_to_group==nil)
                    conv.post_to_group = [rs stringForColumn:@"post_to_group"];
            }
            [rs close];

            [db executeUpdate:delSqlwe_conv, conv.conv_id];
            
            [db executeUpdate:insSqlwe_conv,
             conv.conv_id, conv.create_staff, conv.post_date, conv.conv_type_id, conv.conv_content, [NSNumber numberWithInt:conv.copy_num], [NSNumber numberWithInt:conv.reply_num], [NSNumber numberWithInt:conv.atten_num], [NSNumber numberWithInt:conv.like_num], conv.iscollect, conv.comefrom, conv.post_to_group, conv.circle_id, conv.conv_root_id];
            [db executeUpdate:delSqlwe_like, conv.conv_id];
            for (SNSLike *like in conv.likes) {
                [db executeUpdate:insSqlwe_like, conv.conv_id, like.like_staff, like.like_staff_nickname, like.like_date];
            }
            
            [db executeUpdate:delSqlwe_attach, conv.conv_id];
            for (SNSAttach *attach in conv.attachs) {
                [db executeUpdate:insSqlwe_attach, conv.conv_id, attach.attach_id, attach.file_name, attach.file_ext, attach.up_by_staff, attach.up_date];
            }
            
            if ([@"02" isEqualToString:conv.conv_type_id])
            {
                [db executeUpdate:delSqlwe_together, conv.conv_id];
                [db executeUpdate:insSqlwe_together, conv.conv_id, conv.together.title, conv.together.will_date, conv.together.will_dur, conv.together.will_addr, conv.together.together_desc];
                
                [db executeUpdate:delSqlwe_together_staff, conv.conv_id];
                for (SNSTogetherStaff *tstaff in conv.together.together_staffs) {
                    [db executeUpdate:insSqlwe_together_staff, conv.conv_id, tstaff.staff_id, tstaff.staff_name];
                }
            }
            
            if ([@"03" isEqualToString:conv.conv_type_id])
            {
                [db executeUpdate:delSqlwe_vote, conv.conv_id];
                [db executeUpdate:insSqlwe_vote, conv.conv_id, conv.vote.title, [NSNumber numberWithInt:conv.vote.vote_all_num], conv.vote.is_multi, conv.vote.finishdate, conv.vote.isvoted, [NSNumber numberWithInt:conv.vote.vote_user_num]];
                
                [db executeUpdate:delSqlwe_vote_option, conv.conv_id];
                for (SNSVoteOption *voption in conv.vote.vote_options) {
                    [db executeUpdate:insSqlwe_vote_option, conv.conv_id, voption.option_id, voption.option_desc, [NSNumber numberWithInt:voption.vote_num]];
                }
            }
            
            if ([@"05" isEqualToString:conv.conv_type_id])
            {
                int c = 0;
                FMResultSet *rs = [db executeQuery:selSqlwe_conv, conv.conv_copy.conv_id];
                if (rs != nil && [rs next]) {
                    c = [rs intForColumnIndex:0];
                }
                [rs close];
                if (c == 0)
                {
                    [db executeUpdate:insSqlwe_conv,
                     conv.conv_copy.conv_id, conv.conv_copy.create_staff, conv.conv_copy.post_date, conv.conv_copy.conv_type_id, conv.conv_copy.conv_content, [NSNumber numberWithInt:conv.conv_copy.copy_num], [NSNumber numberWithInt:conv.conv_copy.reply_num], [NSNumber numberWithInt:conv.conv_copy.atten_num], [NSNumber numberWithInt:conv.conv_copy.like_num], @"0", conv.conv_copy.comefrom, conv.conv_copy.post_to_group, @"", conv.conv_copy.conv_root_id];
                    
                    [db executeUpdate:delSqlwe_like, conv.conv_copy.conv_id];
                    for (SNSLike *like in conv.conv_copy.likes) {
                        [db executeUpdate:insSqlwe_like, conv.conv_copy.conv_id, like.like_staff, like.like_staff_nickname, like.like_date];
                    }
                    
                    [db executeUpdate:delSqlwe_attach, conv.conv_copy.conv_id];
                    for (SNSAttach *attach in conv.conv_copy.attachs) {
                        [db executeUpdate:insSqlwe_attach, conv.conv_copy.conv_id, attach.attach_id, attach.file_name, attach.file_ext, attach.up_by_staff, attach.up_date];
                    }                                        
                    
                    [self saveConvStaff:conv.conv_copy.create_staff_obj selSqlwe_staff:selSqlwe_staff insSqlwe_staff:insSqlwe_staff db:db];
                }
            }
            
            [db executeUpdate:delSqlwe_reply, conv.conv_id];
            for (SNSReply *reply in conv.replys) {
                [db executeUpdate:insSqlwe_reply, conv.conv_id, reply.reply_id, reply.reply_staff, reply.reply_date, reply.reply_content, reply.reply_to, reply.reply_to_nickname, [NSNumber numberWithInt:reply.like_num], reply.comefrom];
                [self saveConvStaff:reply.reply_staff_obj selSqlwe_staff:selSqlwe_staff insSqlwe_staff:insSqlwe_staff db:db];
                
                static NSString *delSqlwe_reply_attach = @"delete from we_reply_attach where conv_id=? and reply_id=?";
                static NSString *insSqlwe_reply_attach = @"insert into we_reply_attach(conv_id, reply_id, attach_id, file_name, file_ext, up_by_staff, up_date) values(?, ?, ?, ?, ?, ?, ?)";
                [db executeUpdate:delSqlwe_reply_attach, conv.conv_id,reply.reply_id];
                for (SNSAttach *attach in reply.attachs) {
                    [db executeUpdate:insSqlwe_reply_attach, conv.conv_id,reply.reply_id, attach.attach_id, attach.file_name, attach.file_ext, attach.up_by_staff, attach.up_date];
                }

            }
            
            [self saveConvStaff:conv.create_staff_obj selSqlwe_staff:selSqlwe_staff insSqlwe_staff:insSqlwe_staff db:db];
            
            rst = YES;
        }
//        NSMutableString *sqlwe_conv11 = [NSString stringWithFormat:@"\
//                                         select *  \
//                                         from we_conv a \
//                                          "];
//        FMResultSet *rs11 = [db executeQuery:sqlwe_conv11];
//        int icount=0;
//        while (rs11 != nil && [rs11 next]) {
//            NSLog(@"%@, circleid=%@,groupid=%@,create_staff=%@", [rs11 stringForColumn:@"conv_id"], [rs11 stringForColumn:@"circle_id"], [rs11 stringForColumn:@"post_to_group"],[rs11 stringForColumn:@"create_staff"]);
//            icount++;
//        }
//        [rs11 close];
    }];
    
    return rst;
}

//如果人员不存在，则只记录部分人员信息
- (void)saveConvStaff:(SNSStaff *)staff selSqlwe_staff:(NSString *)selSqlwe_staff insSqlwe_staff:(NSString *)insSqlwe_staff db:(FMDatabase *)db
{
    int c = 0;
    FMResultSet *rs = [db executeQuery:selSqlwe_staff, staff.login_account];
    if (rs != nil && [rs next]) {
        c = [rs intForColumnIndex:0];
    }
    [rs close];
    if (c == 0)
    {
        [db executeUpdate:insSqlwe_staff,
         staff.login_account, staff.nick_name, staff.photo_path, staff.photo_path_small, staff.photo_path_big, staff.eshortname];
    }
}

//-(BOOL)saveReplys:(NSArray*)replys conv_id:(NSString*)conv_id
//{
//    BOOL __block rst = NO;
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        static NSString *insSqlwe_reply = @"insert into we_reply(conv_id, reply_id, reply_staff, reply_date, reply_content, reply_to, reply_to_nickname, like_num, comefrom) select ?, ?, ?, ?, ?, ?, ?, ?, ? where not exists(select 1 from we_reply where reply_id=?)";
//        static NSString *selSqlwe_staff = @"select count(*) c from we_staff where login_account=?";
//        static NSString *insSqlwe_staff = @"insert into we_staff(login_account, nick_name, photo_path, photo_path_small, photo_path_big, eshortname) values(?, ?, ?, ?, ?, ?)";
//
//        for (SNSReply *reply in replys) {
//            [db executeUpdate:insSqlwe_reply, conv_id, reply.reply_id, reply.reply_staff, reply.reply_date, reply.reply_content, reply.reply_to, reply.reply_to_nickname, [NSNumber numberWithInt:reply.like_num], reply.comefrom, reply.reply_id];
//            [self saveConvStaff:reply.reply_staff_obj selSqlwe_staff:selSqlwe_staff insSqlwe_staff:insSqlwe_staff db:db];
//            
//            
//            static NSString *delSqlwe_reply_attach = @"delete from we_reply_attach where conv_id=? and reply_id=?";
//            static NSString *insSqlwe_reply_attach = @"insert into we_reply_attach(conv_id, reply_id, attach_id, file_name, file_ext, up_by_staff, up_date) values(?, ?, ?, ?, ?, ?, ?)";
//            [db executeUpdate:delSqlwe_reply_attach, conv_id,reply.reply_id];
//            for (SNSAttach *attach in reply.attachs) {
//                [db executeUpdate:insSqlwe_reply_attach, conv_id,reply.reply_id, attach.attach_id, attach.file_name, attach.file_ext, attach.up_by_staff, attach.up_date];
//            }
//        }
//    }];
//    
//    return rst;
//}
//
//-(NSArray*)getReplys:(NSString*)conv_id lastid:(NSString*)lastid
//{
//    
//    NSMutableArray* re = [NSMutableArray arrayWithCapacity:15];
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        NSMutableString *sqlwe_reply = [NSMutableString stringWithString:@"select a.conv_id, a.reply_id, a.reply_staff, a.reply_date, a.reply_content, \
//                                        a.reply_to, a.reply_to_nickname, a.like_num, a.comefrom, \
//                                        b.login_account, b.nick_name, b.photo_path, b.photo_path_small, b.photo_path_big  \
//                                        from we_reply a, we_staff b \
//                                        where a.reply_staff=b.login_account \
//                                        and a.conv_id=? "];
//        NSMutableArray *para = [NSMutableArray arrayWithCapacity:10];
//        [para addObject:conv_id];
//        
//        if (lastid != nil && [lastid length] > 0)
//        {
//            [sqlwe_reply appendString:@" and a.reply_id+0<?+0 "];
//            [para addObject:lastid];
//        }
//        
//        [sqlwe_reply appendString:@" order by a.reply_id+0 desc limit 0, 15 "];
//        
//        FMResultSet *rs = [db executeQuery:sqlwe_reply withArgumentsInArray:para];
//        while (rs != nil && [rs next]) {
//            [re addObject:[self rsRow2SNSReply:rs]];
//        }
//        [rs close];
//    }];
//    
//    return re;
//}

//-(SNSBulletin*)rsRow2Bulletin:(FMResultSet*)rs
//{
//    SNSBulletin *snsbulletin=[[[SNSBulletin alloc] init] autorelease];
//    
//    snsbulletin.bulletin_id = [rs stringForColumn:@"bulletin_id"];
//    snsbulletin.circle_id = [rs stringForColumn:@"circle_id"];
//    snsbulletin.group_id = [rs stringForColumn:@"group_id"];
//    snsbulletin.bulletin_date = [rs dateForColumn:@"bulletin_date"];
//    snsbulletin.bulletin_desc = [rs stringForColumn:@"bulletin_desc"];
//    snsbulletin.bulletin_staff = [rs stringForColumn:@"bulletin_staff"];
//    snsbulletin.bulletin_staff_nickname = [rs stringForColumn:@"bulletin_staff_nickname"];
//    snsbulletin.bulletin_staff_photo = [rs stringForColumn:@"bulletin_staff_photo"];
//    
//    return snsbulletin;
//}
//
//-(NSArray *)getBulletin:(NSString *)circleid groupid:(NSString *)groupid lastid:(NSString *)lastid
//{
//    NSMutableArray* re = [NSMutableArray arrayWithCapacity:15];
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        NSMutableString *sqlwe_bulletin =
//        [NSMutableString stringWithString:@"\
//         select bulletin_id, circle_id, group_id, bulletin_date, bulletin_desc, bulletin_staff, \
//           bulletin_staff_nickname, bulletin_staff_photo \
//         from we_bulletin a \
//         where 1=1 "];
//        NSMutableArray *para = [NSMutableArray arrayWithCapacity:10];
//        
//        if (circleid != nil && [circleid length] > 0)
//        {
//            [sqlwe_bulletin appendString:@" and a.circle_id=? "];
//            [para addObject:circleid];
//        }
//        
//        if (groupid == nil || [groupid length] == 0)
//        {
//            [sqlwe_bulletin appendString:@" and group_id in ('ALL', '') "];
//        }
//        else
//        {
//            [sqlwe_bulletin appendString:@" and group_id=? "];
//            [para addObject:groupid];
//        }
//        if (lastid != nil && [lastid length] > 0)
//        {
//            [sqlwe_bulletin appendString:@" and bulletin_id+0<?+0 "];
//            [para addObject:lastid];
//        }
//        
//        [sqlwe_bulletin appendString:@" order by bulletin_id+0 desc limit 0, 15 "];
//        
//        FMResultSet *rs = [db executeQuery:sqlwe_bulletin withArgumentsInArray:para];
//        while (rs != nil && [rs next]) {
//            [re addObject:[self rsRow2Bulletin:rs]];
//        }
//        [rs close];
//    }];
//    
//    return re;
//}
//-(BOOL)saveBulletins:(NSArray*)bulletins
//{
//    BOOL __block rst = NO;
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        static NSString *insSqlwe_reply = @"insert into we_bulletin(bulletin_id, circle_id, group_id, bulletin_date, bulletin_desc, bulletin_staff, bulletin_staff_nickname, bulletin_staff_photo) select ?, ?, ?, ?, ?, ?, ?, ? where not exists(select 1 from we_bulletin where bulletin_id=?)";
//        
//        for (SNSBulletin *bull in bulletins) {
//            [db executeUpdate:insSqlwe_reply, bull.bulletin_id, bull.circle_id, bull.group_id, bull.bulletin_date, bull.bulletin_desc, bull.bulletin_staff, bull.bulletin_staff_nickname, bull.bulletin_staff_photo, bull.bulletin_id];
//        }
//    }];
//    
//    return rst;
//}
//
//-(SNSMessage*)rsRow2WeMessage:(FMResultSet*)rs
//{
//    SNSMessage *snsmess=[[[SNSMessage alloc] init] autorelease];
//    
//    snsmess.msg_id = [rs stringForColumn:@"msg_id"];
//    snsmess.sender = [rs stringForColumn:@"sender"];
//    snsmess.sender_nickname = [rs stringForColumn:@"sender_nickname"];
//    snsmess.sender_photo = [rs stringForColumn:@"sender_photo"];
//    snsmess.recver = [rs stringForColumn:@"recver"];
//    snsmess.send_date = [rs dateForColumn:@"send_date"];
//    snsmess.title = [rs stringForColumn:@"title"];
//    snsmess.content = [rs stringForColumn:@"content"];
//    snsmess.isread = [rs stringForColumn:@"isread"];
//    
//    return snsmess;
//}
//
//-(NSArray *)getWeMessage:(NSString *)lastid
//{
//    NSMutableArray* re = [NSMutableArray arrayWithCapacity:15];
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        NSMutableString *sqlwe_message =
//        [NSMutableString stringWithString:@"\
//         select msg_id, sender, sender_nickname, sender_photo, recver, send_date, title, content, isread \
//         from we_message a \
//         where 1=1 "];
//        NSMutableArray *para = [NSMutableArray arrayWithCapacity:10];
//        
//        if (lastid != nil && [lastid length] > 0)
//        {
//            [sqlwe_message appendString:@" and msg_id+0<?+0 "];
//            [para addObject:lastid];
//        }
//        
//        [sqlwe_message appendString:@" order by msg_id+0 desc limit 0, 15 "];
//        
//        FMResultSet *rs = [db executeQuery:sqlwe_message withArgumentsInArray:para];
//        while (rs != nil && [rs next]) {
//            [re addObject:[self rsRow2WeMessage:rs]];
//        }
//        [rs close];
//    }];
//    
//    return re;
//}
//-(BOOL)saveWeMessages:(NSArray*)we_messages
//{
//    BOOL __block rst = NO;
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        static NSString *insSqlwe_message = @"insert into we_message(msg_id, sender, sender_nickname, sender_photo, recver, send_date, title, content, isread) select ?, ?, ?, ?, ?, ?, ?, ?, ? where not exists(select 1 from we_message where msg_id=?)";
//        
//        for (SNSMessage *mess in we_messages) {
//            [db executeUpdate:insSqlwe_message, mess.msg_id, mess.sender, mess.sender_nickname, mess.sender_photo, mess.recver, mess.send_date, mess.title, mess.content, mess.isread, mess.msg_id];
//        }
//    }];
//    
//    return rst;
//}

-(NSArray*)getConvAtme:(NSString*)lastid
{
    NSMutableArray* re = [NSMutableArray arrayWithCapacity:15];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSMutableString *sqlwe_conv = [NSMutableString stringWithString:@"\
                                       select \
                                       a.conv_id, a.create_staff, a.post_date, a.conv_type_id, a.conv_content, a.copy_num, \
                                       a.reply_num, a.atten_num, a.like_num, a.iscollect, a.comefrom, a.post_to_group, a.circle_id, a.conv_root_id, \
                                       b.login_account, b.nick_name, b.photo_path, b.photo_path_small, b.photo_path_big  \
                                       from we_conv a, we_staff b, we_conv_atme c \
                                       where a.create_staff=b.login_account \
                                         and a.conv_id=c.conv_id "];
        NSMutableArray *para = [NSMutableArray arrayWithCapacity:10];

        if (lastid != nil && [lastid length] > 0)
        {
            [sqlwe_conv appendString:@" and a.conv_id<? "];
            [para addObject:lastid];
        }
        
        [sqlwe_conv appendString:@" order by a.conv_id+0 desc limit 0, 15 "];
        
        FMResultSet *rs = [db executeQuery:sqlwe_conv withArgumentsInArray:para];
        while (rs != nil && [rs next]) {
            [re addObject:[self rsRow2SNSConv:rs]];
        }
        [rs close];
        
        for (SNSConv *conv in re)
        {
            [self loadConvChild:conv db:db];
        }
    }];
    
    return re;
}
-(BOOL)saveConvsAtme:(NSArray*)convs
{
    BOOL __block rst = NO;
    
    [self saveConvs:convs];
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *insSqlwe_conv_atme = @"insert into we_conv_atme(conv_id) select ? where not exists(select 1 from we_conv_atme where conv_id=?)";
        
        for (SNSConv *conv in convs) {
            [db executeUpdate:insSqlwe_conv_atme, conv.conv_id, conv.conv_id];
        }
    }];
    
    return rst;
}

//获取首页上的置顶
-(BOOL)getTopSessionLastFive:(NSMutableArray *)re
{
    //RETURN DBField:session_type,talk_id,talk_name,msg_text,msg_time,jidbare,nick_name
    BOOL __block rst=NO;
    [dbQueue inDatabase:^(FMDatabase *db) {
        //微应用、公共号名称
        FMResultSet *rs_WeMicroAcc = [db executeQuery:@"SELECT distinct b.jid, b.wm_number, b.wm_name \
                                      FROM session_last_five a, we_microaccount b where a.talk_id=b.jid"];
        NSMutableDictionary *dictWeMicroAcc=[[NSMutableDictionary alloc] initWithCapacity:5];
        while (rs_WeMicroAcc != nil && [rs_WeMicroAcc next]) {
            if ([rs_WeMicroAcc resultDictionary])
            {
                NSString *wm_jid=[[rs_WeMicroAcc resultDictionary] objectForKey:@"jid"];
                NSString *wm_name=[[rs_WeMicroAcc resultDictionary] objectForKey:@"wm_name"];
                [dictWeMicroAcc setObject:wm_name forKey:wm_jid];
            }
        }
        [rs_WeMicroAcc close];
        
        //single
        FMResultSet *rs_s = [db executeQuery:@"SELECT a.session_type,a.talk_id,c.nick_name as talk_name, b.msg_text,a.msg_time,a.talk_id as jidbare, c.nick_name, a.totop,a.talk_id2 \
            FROM session_last_five a \
                LEFT JOIN view_chatsingle_last_session b ON a.talk_id=b.talkabout_jid_bare \
                LEFT JOIN we_staff c ON a.talk_id=c.fafa_jid \
            WHERE session_type=0 AND totop>0 ORDER BY a.msg_time DESC"];
        while (rs_s != nil && [rs_s next]) {
            if (dictWeMicroAcc.count>0)
            {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[rs_s resultDictionary]];
                NSString *wm_name=[dictWeMicroAcc objectForKey:dict[@"talk_id"]];
                if (wm_name!=nil)
                {
                    [dict setObject:wm_name forKey:@"talk_name"];
                }
                [re addObject:dict];
            }
            else
            {
                [re addObject:[rs_s resultDictionary]];
            }
        }
        [rs_s close];
        
        //group
        FMResultSet *rs_g = [db executeQuery:@"SELECT a.session_type,a.talk_id,c.groupname as talk_name, b.msg_text,a.msg_time,b.speaker_jid_bare as jidbare, b.speaker_name as nick_name, a.totop,a.talk_id2 \
                             FROM session_last_five a \
                             LEFT JOIN view_chatgroup_last_session b ON a.talk_id=b.group_id \
                             LEFT JOIN im_group c ON a.talk_id=c.groupid \
                             WHERE session_type>0 AND session_type<=3 AND totop>0 ORDER BY a.msg_time DESC"];
        while (rs_g != nil && [rs_g next]) {
            [re addObject:[rs_g resultDictionary]];
            rst=YES;
        }
        [rs_g close];

        //circle_trend
        FMResultSet *rs_ct = [db executeQuery:@"SELECT a.session_type,a.talk_id,b.circle_name as talk_name, '' as msg_text,a.msg_time,'' as jidbare, '' as nick_name, a.totop,a.talk_id2 \
                             FROM session_last_five a \
                             LEFT JOIN we_circle b ON a.talk_id=b.circle_id \
                             WHERE session_type=4 AND totop>0 ORDER BY a.msg_time DESC"];
        while (rs_ct != nil && [rs_ct next]) {
            [re addObject:[rs_ct resultDictionary]];
            rst=YES;
        }
        [rs_ct close];
        
        //group_trend
        FMResultSet *rs_gt = [db executeQuery:@"SELECT a.session_type,a.talk_id,b.group_name as talk_name, '' as msg_text,a.msg_time,'' as jidbare, '' as nick_name, a.totop,a.talk_id2 \
                             FROM session_last_five a \
                             LEFT JOIN we_group b ON a.talk_id=b.group_id and a.talk_id2=b.circle_id \
                             WHERE session_type=5 AND totop>0 ORDER BY a.msg_time DESC"];
        while (rs_gt != nil && [rs_gt next]) {
            [re addObject:[rs_gt resultDictionary]];
            rst=YES;
        }
        [rs_gt close];
    }];
    
    return rst;
}

//获取首页上的全部会话包含置顶
-(BOOL)getSessionLastFive:(NSMutableArray *)re
{
    //RETURN DBField:session_type,talk_id,talk_name,msg_text,msg_time,jidbare,nick_name
    BOOL __block rst=NO;
    [dbQueue inDatabase:^(FMDatabase *db) {
        //微应用、公共号名称
        FMResultSet *rs_WeMicroAcc = [db executeQuery:@"SELECT distinct b.jid, b.wm_number, b.wm_name \
                                      FROM session_last_five a, we_microaccount b where a.talk_id=b.jid"];
//        FMResultSet *rs_WeMicroAcc = [db executeQuery:@"SELECT distinct b.id, b.wm_number, b.wm_name \
//                                      FROM we_microaccount b"];
        NSMutableDictionary *dictWeMicroAcc=[[NSMutableDictionary alloc] initWithCapacity:5];
        while (rs_WeMicroAcc != nil && [rs_WeMicroAcc next]) {
            if ([rs_WeMicroAcc resultDictionary])
            {
                NSString *wm_jid=[[rs_WeMicroAcc resultDictionary] objectForKey:@"jid"];
                NSString *wm_name=[[rs_WeMicroAcc resultDictionary] objectForKey:@"wm_name"];
                [dictWeMicroAcc setObject:wm_name forKey:wm_jid];
            }
        }
        [rs_WeMicroAcc close];
        
//        FMResultSet *rs_s = [db executeQuery:@"SELECT session_type,talk_id,c.nick_name as talk_name,msg_text,b.msg_time as msg_time,talkabout_jid_bare as jidbare, c.nick_name FROM session_last_five a,im_message_single b,we_staff c WHERE session_type=0 AND a.talk_id=b.talkabout_jid_bare AND b.talkabout_jid_bare=c.fafa_jid  AND b.msg_time=(select max(msg_time) from im_message_single d where d.talkabout_jid_bare=a.talk_id) ORDER BY b.msg_time DESC"];
        FMResultSet *rs_s = [db executeQuery:@"SELECT a.session_type,a.talk_id,c.nick_name as talk_name, b.msg_text,a.msg_time,a.talk_id as jidbare, c.nick_name, a.totop,a.talk_id2 \
                             FROM session_last_five a \
                             LEFT JOIN view_chatsingle_last_session b ON a.talk_id=b.talkabout_jid_bare \
                             LEFT JOIN we_staff c ON a.talk_id=c.fafa_jid \
                             WHERE session_type=0 ORDER BY a.msg_time DESC"];
        while (rs_s != nil && [rs_s next]) {
            if (dictWeMicroAcc.count>0)
            {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[rs_s resultDictionary]];
                NSString *wm_name=[dictWeMicroAcc objectForKey:dict[@"talk_id"]];
                if (wm_name!=nil)
                {
                    [dict setObject:wm_name forKey:@"talk_name"];
                    [dict setObject:wm_name forKey:@"nick_name"];
                }
                [re addObject:dict];
            }
            else
            {
                [re addObject:[rs_s resultDictionary]];
            }
        }
        [rs_s close];
        
        //group
        FMResultSet *rs_g = [db executeQuery:@"SELECT a.session_type,a.talk_id,c.groupname as talk_name, b.msg_text,a.msg_time,b.speaker_jid_bare as jidbare, b.speaker_name as nick_name, a.totop,a.talk_id2 \
                             FROM session_last_five a \
                             LEFT JOIN view_chatgroup_last_session b ON a.talk_id=b.group_id \
                             LEFT JOIN im_group c ON a.talk_id=c.groupid \
                             WHERE session_type>0 AND session_type<=3 ORDER BY a.msg_time DESC"];
        while (rs_g != nil && [rs_g next]) {
            [re addObject:[rs_g resultDictionary]];
            rst=YES;
        }
        [rs_g close];
        
        //circle_trend
        FMResultSet *rs_ct = [db executeQuery:@"SELECT a.session_type,a.talk_id,b.circle_name as talk_name, '' as msg_text,a.msg_time,'' as jidbare, '' as nick_name, a.totop,a.talk_id2 \
                              FROM session_last_five a \
                              LEFT JOIN we_circle b ON a.talk_id=b.circle_id \
                              WHERE session_type=4 ORDER BY a.msg_time DESC"];
        while (rs_ct != nil && [rs_ct next]) {
            [re addObject:[rs_ct resultDictionary]];
            rst=YES;
        }
        [rs_ct close];
        
        //group_trend
        FMResultSet *rs_gt = [db executeQuery:@"SELECT a.session_type,a.talk_id,b.group_name as talk_name, '' as msg_text,a.msg_time,'' as jidbare, '' as nick_name, a.totop,a.talk_id2 \
                              FROM session_last_five a \
                              LEFT JOIN we_group b ON a.talk_id=b.group_id and a.talk_id2=b.circle_id \
                              WHERE session_type=5 ORDER BY a.msg_time DESC"];
        while (rs_gt != nil && [rs_gt next]) {
            [re addObject:[rs_gt resultDictionary]];
            rst=YES;
        }
        [rs_gt close];
    }];
    
    return rst;
}


-(SNSCircle*)rsRow2SNSCircle:(FMResultSet*)rs
{
    SNSCircle *snscircle=[[SNSCircle alloc] init];
    
    snscircle.circle_id = [[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"circle_id"]] ];
    snscircle.circle_name = [[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"circle_name"]] ];
    snscircle.circle_desc = [[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"circle_desc"]] ];
    snscircle.logo_path = [[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"logo_path"]] ];
    snscircle.create_staff = [[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"create_staff"]] ];
    snscircle.create_date = [rs dateForColumn:@"create_date"];
    snscircle.manager = [[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"manager"]] ];
    snscircle.join_method = [[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"join_method"]] ];
    snscircle.enterprise_no = [[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"enterprise_no"]] ];
    snscircle.network_domain = [[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"network_domain"]] ];
    snscircle.allow_copy = [[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"allow_copy"]] ];
    snscircle.logo_path_small = [[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"logo_path_small"]] ];
    snscircle.logo_path_big = [[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"logo_path_big"]] ];
    snscircle.staff_num = [rs intForColumn:@"staff_num"];
    snscircle.fafa_groupid=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"fafa_groupid"]] ];
    snscircle.circle_class_name=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"circle_class_name"]] ];
    snscircle.circle_class_id=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[rs stringForColumn:@"circle_class_id"]] ];
    
    return snscircle;
}

-(NSArray*)getCircles
{    
    NSMutableArray* re = [NSMutableArray arrayWithCapacity:15];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSMutableString *sqlwe_circle = [NSMutableString stringWithString:@"select * from we_circle order by enterprise_no,circle_id desc"];
        NSMutableArray *para = [NSMutableArray arrayWithCapacity:10];
        SNSCircle *circle_9999=nil,*circle_10000=nil,*circle_enterprise=nil;
        FMResultSet *rs = [db executeQuery:sqlwe_circle withArgumentsInArray:para];
        while (rs != nil && [rs next]) {
            SNSCircle *circle1=[self rsRow2SNSCircle:rs];
            if ([circle1.circle_id isEqualToString:@"9999"])
                circle_9999=circle1;
            else if ([circle1.circle_id isEqualToString:@"10000"])
                circle_10000=circle1;
            else if ([[rs stringForColumn:@"enterprise_no"] isEqualToString:@""]==NO)
                circle_enterprise=circle1;
            else
                [re addObject:circle1];
        }
        if (circle_10000!=nil) [re insertObject:circle_10000 atIndex:0];
        if (circle_9999!=nil) [re insertObject:circle_9999 atIndex:0];
        if (circle_enterprise!=nil) [re insertObject:circle_enterprise atIndex:0];
        [rs close];
    }];
    
    return re;
}

-(SNSCircle *)getCircle:(NSString *)circleid
{
    SNSCircle __block *circle1=nil;
    [dbQueue inDatabase:^(FMDatabase *db){
        NSMutableString *sqlwe_circle = [NSMutableString stringWithString:@"select * from we_circle where circle_id=?"];
        FMResultSet *rs = [db executeQuery:sqlwe_circle,circleid];
        while (rs != nil && [rs next]) {
            circle1=[self rsRow2SNSCircle:rs];
        }
        [rs close];
    }];
    return circle1;
}
-(BOOL)saveCircles:(NSArray*)circles
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *delSqlwe_circle = @"delete from we_circle";
        static NSString *insSqlwe_circle = @"insert into we_circle(circle_id, circle_name, circle_desc, logo_path, create_staff, create_date, manager, join_method, enterprise_no, network_domain, allow_copy, logo_path_small, logo_path_big, staff_num,fafa_groupid,circle_class_name,circle_class_id) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)";
        
        [db executeUpdate:delSqlwe_circle];
        for (SNSCircle *circle in circles) {
            if (circle.fafa_groupid.length==0) circle.fafa_groupid=circle.circle_id;
            [db executeUpdate:insSqlwe_circle, circle.circle_id, circle.circle_name, circle.circle_desc, circle.logo_path, circle.create_staff, circle.create_date, circle.manager, circle.join_method, circle.enterprise_no, circle.network_domain, circle.allow_copy, circle.logo_path_small, circle.logo_path_big, [NSNumber numberWithInt:circle.staff_num],circle.fafa_groupid,circle.circle_class_name,circle.circle_class_id];
        }
        rst = YES;
    }];
    
    return rst;
}

-(BOOL)updateCircle:(SNSCircle*)circle
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *updSqlwe_circle = @"update we_circle set circle_name=?, circle_desc=?, logo_path=?, manager=?, join_method=?, allow_copy=?, logo_path_small=?, logo_path_big=?, fafa_groupid=?,circle_class_name=?,circle_class_id=? where circle_id=? ;";
        
        if (circle.fafa_groupid.length==0) circle.fafa_groupid=circle.circle_id;
        rst=[db executeUpdate:updSqlwe_circle, circle.circle_name, circle.circle_desc, circle.logo_path, circle.manager, circle.join_method, circle.allow_copy, circle.logo_path_small, circle.logo_path_big,circle.fafa_groupid,circle.circle_class_name,circle.circle_class_id,circle.circle_id];
        
        static NSString *updSqlim_group = @"update im_group set groupname=? , groupdesc=? , add_member_method=? where groupid=?";
        
        rst=[db executeUpdate:updSqlim_group, circle.circle_name, circle.circle_desc, circle.join_method,circle.fafa_groupid];
        
        rst = YES;
    }];
    
    return rst;
}

-(SNSGroup*)rsRow2SNSCircleGroup:(FMResultSet*)rs
{
    SNSGroup *snsgroup=[[SNSGroup alloc] init];
    snsgroup.circle_id = [rs stringForColumn:@"circle_id"];
    snsgroup.group_id = [rs stringForColumn:@"group_id"];
    snsgroup.group_name = [rs stringForColumn:@"group_name"];
    snsgroup.group_desc = [rs stringForColumn:@"group_desc"];
    snsgroup.group_photo_path = [rs stringForColumn:@"group_photo_path"];
    snsgroup.join_method = [rs stringForColumn:@"join_method"];
    snsgroup.create_staff = [rs stringForColumn:@"create_staff"];
    snsgroup.create_date = [rs dateForColumn:@"create_date"];
    snsgroup.fafa_groupid=[Utils getSNSString:[rs stringForColumn:@"fafa_groupid"]];
    
    return snsgroup;
}

-(NSArray*)getCircleGroups:(NSString *)circleid
{
    NSMutableArray* re = [NSMutableArray arrayWithCapacity:15];
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSMutableString *sqlstr = [NSMutableString stringWithString:@"select circle_id, group_id, group_name, group_desc,group_photo_path,join_method,create_staff,create_date,fafa_groupid  from we_group "];
        
        NSMutableArray *para = [NSMutableArray arrayWithCapacity:10];
        
        if (circleid != nil && [circleid length] > 0)
        {
            [sqlstr appendString:@" where circle_id=? "];
            [para addObject:circleid];
        }
        
        [sqlstr appendString:@" order by circle_id,group_id "];
        
        FMResultSet *rs = [db executeQuery:sqlstr withArgumentsInArray:para];
        while (rs != nil && [rs next]) {
            [re addObject:[self rsRow2SNSCircleGroup:rs]];
        }
        [rs close];
    }];
    
    return re;
    
}
-(SNSGroup*)getCircleGroupInfo:(NSString *)groupid
{
    if ([groupid length] == 0)
        return nil;
    
    __block SNSGroup* re = nil;
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSMutableString *sqlstr = [NSMutableString stringWithString:@"select circle_id, group_id, group_name, group_desc,group_photo_path,join_method,create_staff,create_date,fafa_groupid  from we_group where group_id=?"];
        
        FMResultSet *rs = [db executeQuery:sqlstr,groupid];
        if (rs != nil && [rs next]) {
            re=[self rsRow2SNSCircleGroup:rs];
        }
        [rs close];
    }];
    
    return re;
    
}

-(BOOL)saveCircleGroups:(NSArray*)groups CircleID:(NSString *)circleid
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *delSqlwe_group = @"delete from we_group where circle_id=?";
        static NSString *insSqlwe_group = @"insert into we_group(circle_id, group_id, group_name, group_desc,group_photo_path,join_method,create_staff,create_date,fafa_groupid) values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        [db executeUpdate:delSqlwe_group,circleid];
        for (SNSGroup *group in groups) {
            if (group.fafa_groupid.length==0) group.fafa_groupid=group.circle_id;
            [db executeUpdate:insSqlwe_group, group.circle_id, group.group_id, group.group_name, group.group_desc,group.group_photo_path,group.join_method,group.create_staff,group.create_date,group.fafa_groupid];
        }
        rst = YES;
    }];
    
    return rst;
}

-(SNSMicroAccount*)rsRow2SNSMicroAccount:(FMResultSet*)rs
{
    SNSMicroAccount *ma = [[SNSMicroAccount alloc] init];
    ma.ID = [rs stringForColumn:@"id"];
    ma.wm_number = [rs stringForColumn:@"wm_number"];
    ma.wm_name = [rs stringForColumn:@"wm_name"];
    ma.jid = [rs stringForColumn:@"jid"];
    ma.im_state = [rs stringForColumn:@"im_state"];
    ma.im_resource = [rs stringForColumn:@"im_resource"];
    ma.im_priority = @([rs intForColumn:@"im_priority"]);
    ma.wm_type = [rs stringForColumn:@"wm_type"];
    ma.micro_use = [rs stringForColumn:@"micro_use"];
    ma.logo_path = [rs stringForColumn:@"logo_path"];
    ma.logo_path_big = [rs stringForColumn:@"logo_path_big"];
    ma.logo_path_small = [rs stringForColumn:@"logo_path_small"];
    ma.introduction = [rs stringForColumn:@"introduction"];
    ma.eno = [rs stringForColumn:@"eno"];
    ma.wm_limit = [rs stringForColumn:@"wm_limit"];
    ma.concern_approval = [rs stringForColumn:@"concern_approval"];
    ma.wm_level = @([rs intForColumn:@"wm_level"]);
    ma.fans_count = @([rs intForColumn:@"fans_count"]);
    ma.window_template = [rs stringForColumn:@"window_template"];
    ma.salutatory = [rs stringForColumn:@"salutatory"];
    ma.send_status = [rs stringForColumn:@"send_status"];
    
    return ma;
}

-(NSArray*)getWeMicroaccount:(int)micro_use;
{
    NSMutableArray* re = [NSMutableArray arrayWithCapacity:15];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sqlstr = @"select a.id, a.wm_number, a.wm_name, a.jid, a.im_state, a.im_resource, a.im_priority, a.wm_type, a.micro_use, a.logo_path, a.logo_path_big, a.logo_path_small, a.introduction, a.eno, a.wm_limit, a.concern_approval, a.wm_level, a.fans_count, a.window_template, a.salutatory, a.send_status from we_microaccount a where a.micro_use=? order by a.wm_name";
        
        FMResultSet *rs = [db executeQuery:sqlstr, [NSString stringWithFormat:@"%d",micro_use]];
        while (rs != nil && [rs next]) {
            [re addObject:[self rsRow2SNSMicroAccount:rs]];
            
        }
        [rs close];
    }];
    
    return re;    
}

-(SNSMicroAccount*)getWeMicroaccount:(NSString*)number MicroUseType:(int)micro_use
{
    SNSMicroAccount* __block re = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sqlstr = @"select a.id, a.wm_number, a.wm_name, a.jid, a.im_state, a.im_resource, a.im_priority, a.wm_type, a.micro_use, a.logo_path, a.logo_path_big, a.logo_path_small, a.introduction, a.eno, a.wm_limit, a.concern_approval, a.wm_level, a.fans_count, a.window_template, a.salutatory, a.send_status from we_microaccount a where a.wm_number=? and a.micro_use=?";
        
        FMResultSet *rs = [db executeQuery:sqlstr, number, [NSString stringWithFormat:@"%d",micro_use]];
        while (rs != nil && [rs next]) {
            re = [self rsRow2SNSMicroAccount:rs];
            
        }
        [rs close];
    }];
    
    return re;
}

-(SNSMicroAccount*)getWeMicroAccount:(NSString*)number
{
    SNSMicroAccount* __block re = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sqlstr = @"select a.id, a.wm_number, a.wm_name, a.jid, a.im_state, a.im_resource, a.im_priority, a.wm_type, a.micro_use, a.logo_path, a.logo_path_big, a.logo_path_small, a.introduction, a.eno, a.wm_limit, a.concern_approval, a.wm_level, a.fans_count, a.window_template, a.salutatory, a.send_status from we_microaccount a where a.wm_number=?";
        
        FMResultSet *rs = [db executeQuery:sqlstr, number];
        while (rs != nil && [rs next]) {
            re = [self rsRow2SNSMicroAccount:rs];
            
        }
        [rs close];
    }];
    
    return re;
}

-(BOOL)saveWeMicroaccount:(NSArray*)acccounts
{
    BOOL __block rst = NO;
    if ([acccounts count]==0)
        return NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        SNSMicroAccount *micro1=acccounts[0];
        static NSString *delSql = @"delete from we_microaccount where micro_use=?";
        static NSString *insSql = @"insert into we_microaccount(id, wm_number, wm_name, jid, im_state, im_resource, im_priority, wm_type, micro_use, logo_path, logo_path_big, logo_path_small, introduction, eno, wm_limit, concern_approval, wm_level, fans_count, window_template, salutatory, send_status) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        [db executeUpdate:delSql,micro1.micro_use];
        for (SNSMicroAccount *ma in acccounts) {
            [db executeUpdate:insSql, ma.ID, ma.wm_number,  ma.wm_name,  ma.jid,  ma.im_state,  ma.im_resource,  ma.im_priority,  ma.wm_type,  ma.micro_use,  ma.logo_path,  ma.logo_path_big,  ma.logo_path_small,  ma.introduction,  ma.eno,  ma.wm_limit,  ma.concern_approval,  ma.wm_level,  ma.fans_count,  ma.window_template,  ma.salutatory,  ma.send_status];
        }
        rst = YES;
    }];
    
    return rst;
}


-(NSArray *)getAuthority
{
    NSMutableArray* rst = [NSMutableArray arrayWithCapacity:15];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from im_authority"];
        while (rs != nil && [rs next]) {
            [rst addObject:[NSNumber numberWithInt:[rs intForColumn:@"authoritycode"]]];
        }
        [rs close];
    }];
    
    return rst;
}

-(BOOL)permissionAuthority:(int)fm
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select count(*) as cnt from im_authority where authoritycode=?",[NSNumber numberWithInt:fm]];
        while (rs != nil && [rs next]) {
            rst = [rs intForColumn:@"cnt"]>0;
        }
        [rs close];
    }];
    
    return rst;
}

-(int)getAuthorityLevel
{
    int __block rst = AUTHORITY_FUNCTION_ERROR;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from im_authority where authoritycode>=?",[NSNumber numberWithInt:AUTHORITY_FUNCTION_LEVEL_V]];
        while (rs != nil && [rs next]) {
            rst = [rs intForColumn:@"authoritycode"];
        }
        [rs close];
    }];
    
    return rst;
}

-(BOOL)updateAuthorityLevel:(int)authlevel
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst=[db executeUpdate:@"delete from im_authority where authoritycode>=?",[NSNumber numberWithInt:AUTHORITY_FUNCTION_LEVEL_V]];
        rst=[db executeUpdate:@"insert into im_authority(authoritycode) values(?)",[NSNumber numberWithInt:authlevel]];
    }];
    
    return rst;
}

-(BOOL)deleteAuthority //不用
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        rst=[db executeUpdate:@"delete from im_authority"];
    }];
    
    return rst;
}

-(BOOL)insertAuthority:(int)auth
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from im_authority where authoritycode=?",[NSNumber numberWithInt:auth]];
        [db executeUpdate:@"insert into im_authority(authoritycode) values(?)", [NSNumber numberWithInt:auth]];
        
        rst = YES;
    }];
    
    return rst;
}

-(BOOL)isAttenStuff:(NSString *)jid staff_login_account:(NSString *)loginaccount
{
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from atten_staffs where jid=? and login_account=?",jid,loginaccount];
        if (rs != nil && [rs next]) {
            rst=YES;
        }
        [rs close];
    }];
    return rst;
}
-(BOOL)saveAttenStaffs:(NSString *)jid returnAttenList:(NSArray *)attenlist
{
    BOOL __block rst = NO;
    if ([attenlist count]==0)
        return NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *delSql = @"delete from atten_staffs where jid=?";
        [db executeUpdate:delSql,jid];
        
        for (SNSStaff *staff in attenlist) {
            static NSString *insertsql_staff = @"insert into atten_staffs(jid,login_account) values(?, ?)";
            [db executeUpdate:insertsql_staff,jid,staff.login_account];
            
            static NSString *selSqlwe_staff = @"select count(*) c from we_staff where login_account=?";
            static NSString *insSqlwe_staff = @"insert into we_staff(login_account, nick_name, photo_path, photo_path_small, photo_path_big, eshortname) values(?, ?, ?, ?, ?, ?)";
            [self saveConvStaff:staff selSqlwe_staff:selSqlwe_staff insSqlwe_staff:insSqlwe_staff db:db];
        }
        rst = YES;
    }];
    
    return rst;
}

-(BOOL)updateGroupInfo:(SNSGroup *)snsGroup {
    BOOL __block rst = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        static NSString *updateSql = @"update im_group set groupname=?,groupclass=?,groupdesc=?,add_member_method=? where groupid=?";
        rst=[db executeUpdate:updateSql,snsGroup.group_name,snsGroup.group_class,snsGroup.group_desc,snsGroup.join_method,snsGroup.fafa_groupid];
        
        static NSString *updateSnsGroupSql = @"update we_group set group_name=?,group_desc=?,join_method=?,group_photo_path=? where group_id=? and circle_id=? and fafa_groupid=?";
        rst=[db executeUpdate:updateSnsGroupSql,snsGroup.group_name,snsGroup.group_desc,snsGroup.join_method,snsGroup.group_photo_path,snsGroup.group_id,snsGroup.circle_id,snsGroup.fafa_groupid];
        
        rst = YES;
        
    }];
    
    return rst;
}

-(BOOL)addImGroupTypes:(NSArray *)grouptypes {
    BOOL __block result=NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from im_grouptype"];
        for (SNSGroupType *snsGroupType in grouptypes) {
            [db executeUpdate:@"insert into im_grouptype(typeid,typename,pid) values(?,?,?)",snsGroupType.type_id,snsGroupType.type_name,snsGroupType.pid];
        }
        result=YES;
    }];
    
    return result;
}

-(NSMutableArray *)getImGroupTypes {
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from im_grouptype"];
        if (rs!=nil) {
            result=[NSMutableArray array];
        }
        while (rs != nil && [rs next]) {
            SNSGroupType *grouptype=[[SNSGroupType alloc] init];
            
            [grouptype setJSONValue:[rs resultDictionary]];
            
            [result addObject:grouptype];
        }
        [rs close];
    }];
    
    return result;
}

-(SNSGroupType *)getImGroupType:(NSString *)grouptypeid {
    SNSGroupType __block *result=nil;
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from im_grouptype where typeid=?",grouptypeid];
        while (rs != nil && [rs next]) {
            result=[[SNSGroupType alloc] init];
            
            [result setJSONValue:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return result;
}

-(BOOL)updateStaff:(SNSStaffFull *)snsStaffFull {
    BOOL __block result=NO;
    [dbQueue inDatabase:^(FMDatabase *db) {
        result=[db executeUpdate:@"update im_employee set deptid=?,employeename=? where loginname=? ",snsStaffFull.fafa_deptid,snsStaffFull.nick_name,snsStaffFull.jid];
        result=[db executeUpdate:@"update we_staff set nick_name=? , sex_id=? , self_desc=? , work_phone=? , dept_id=? ,dept_name=?, duty=? where login_account=? ",snsStaffFull.nick_name,snsStaffFull.sex_id,snsStaffFull.self_desc,snsStaffFull.work_phone,snsStaffFull.dept_id,snsStaffFull.dept_name,snsStaffFull.duty,snsStaffFull.login_account];
    }];
    return result;
}

-(NSMutableArray *)getSNSDepts {
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from we_department"];
        if (rs!=nil) {
            result=[NSMutableArray array];
        }
        while (rs != nil && [rs next]) {
            SNSDept *snsDept=[[SNSDept alloc] init];
            
            [snsDept setJSONValue:[rs resultDictionary]];
            
            [result addObject:snsDept];
        }
        [rs close];
    }];
    
    return result;
}

-(BOOL)saveSNSDepts:(NSArray *)snsDepts {
    BOOL __block result=NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from we_department"];
        for (SNSDept *snsDept in snsDepts) {
            [db executeUpdate:@"insert into we_department(dept_id,dept_name,parent_deptid,fafa_deptid) values(?,?,?,?)",snsDept.dept_id,snsDept.dept_name,snsDept.parent_deptid,snsDept.fafa_deptid];
        }
        result=YES;
    }];
    
    return result;
}

-(BOOL)checkCircleWithName:(NSString *)circlename OldCircleName:(NSString *)oldCircleName {
    BOOL __block result=NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select count(*) from we_circle where circle_name=?  and circle_name!=?",circlename,oldCircleName];
        int icount=0;
        if (rs!=nil && [rs next]) {
            icount=[rs intForColumnIndex:0];
        }
        [rs close];
        if(icount>0)result=YES;
    }];
    
    return result;
}

-(BOOL)cehckSNSGroupWithName:(NSString *)groupname Circleid:(NSString *)circleid OldGroupName:(NSString *)oldGroupName {
    BOOL __block result=NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select count(*) from we_group where group_name=? and circle_id=? and group_name!=?",groupname,circleid,oldGroupName];
        int icount=0;
        if (rs!=nil && [rs next]) {
            icount=[rs intForColumnIndex:0];
        }
        [rs close];
        if(icount>0)result=YES;
    }];
    
    return result;
}

-(SNSGroup *)getSNSGroupWithFafaGroupid:(NSString *)fafaGroupid {
    SNSGroup __block *result=nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from we_group where fafa_groupid=?",fafaGroupid];
        if (rs!=nil && [rs next]) {
            result = [self rsRow2SNSCircleGroup:rs];
        }
        [rs close];
    }];
    
    return result;
}

-(SNSCircle *)getSNSCircleWithFafaGroupid:(NSString *)fafaGroupid {
    SNSCircle __block *result=nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from we_circle where fafa_groupid=?",fafaGroupid];
        if (rs!=nil && [rs next]) {
            result = [self rsRow2SNSCircle:rs];
        }
        [rs close];
    }];
    
    return result;
}

-(NSDictionary *)getIMRosterWithJid:(NSString *)jid {
    __block NSDictionary *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from im_roster where jid=? ",jid];
        while (rs != nil && [rs next]) {
           result= [rs resultDictionary];
        }
        [rs close];
    }];
    
    return result;
}


//美邦
-(BOOL)getStaffFullByLdapUID:(NSString*)ldap_uid stafffull:(SNSStaffFull *)staff
{
    BOOL __block re = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {

        static NSString *selSqlwe_staff = @"select *  \
        from we_staff \
        where ldap_uid=?";
        FMResultSet *rs = [db executeQuery:selSqlwe_staff, ldap_uid];
        if (rs != nil && [rs next]) {
            [self rsRow2SNSStaffFull:rs staff:staff];
            re=YES;
        }
        [rs close];
    }];
    
    return re;
}

-(BOOL)deletMySelfStaffLdapUID:(NSString*)ldap_uid
{
    BOOL __block rst = NO;

    [dbQueue inDatabase:^(FMDatabase *db) {
       rst = [db executeUpdate:@"delete from we_staff where ldap_uid=?", ldap_uid];
    }];
    return rst;
}

-(BOOL)updateStaffLdapUID:(NSString*)ldap_uid staffJID:(NSString *)jid
{
    BOOL __block re = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *selSqlwe_staff = @"update we_staff set ldap_uid=? where fafa_jid=?";
        [db executeUpdate:selSqlwe_staff, ldap_uid,jid];
    }];
    
    return re;
}
////////消息去重 2015-2-9 lvxuejun
-(BOOL) querySingleMessageByGuid:(NSString*)elementid;
{
    BOOL __block rst=NO;
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sqlstr=[NSString stringWithFormat:@"SELECT 1 FROM im_message_single WHERE guid=?"];
        FMResultSet *rs = [db executeQuery:sqlstr,elementid];
        if (rs != nil)
        {
            while ([rs next]) {
                rst = YES;
            }
        }
        [rs close];
    }];
    return rst;
}

-(BOOL) queryGroupMessageByGuid:(NSString*)elementid
{
    BOOL __block rst=NO;
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sqlstr=[NSString stringWithFormat:@"SELECT 1 FROM im_message_group WHERE guid=?"];
        FMResultSet *rs = [db executeQuery:sqlstr,elementid];
        if (rs != nil)
        {
            while ([rs next]) {
                rst = YES;
            }
        }
        [rs close];
    }];
    return rst;
}

@end
