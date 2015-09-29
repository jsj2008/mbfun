//
//  SQLiteOper.h
//  FaFa
//
//  Created by mac on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <sqlite3.h>
//#import "DepartmentObject.h"
#import "FMDatabaseQueue.h"
#import "SNSDataClass.h"

typedef enum{
    ACCOUNT_TYPE_EMAIL,
    ACCOUNT_TYPE_JID
}ACCOUNT_TYPE;

@interface SQLiteOper : NSObject
{
    FMDatabaseQueue *dbQueue;
}

-(void)open:(NSString*)jidbare;
-(void)close;
-(BOOL)isOpened;

- (BOOL)Query:(NSString *)querySQL Record:(NSMutableArray *)recordArray;

+(NSString*)SYSPARANAME_VER_IM_DEPT;
+(NSString*)SYSPARANAME_VER_IM_GROUP;
+(NSString*)SYSPARANAME_VER_IM_DEPTEMPLOYEE;
-(NSString*)getSysParam:(NSString*)name defaultvalue:(NSString*)defaultvalue;
-(BOOL)setSysParam:(NSString*)name value:(NSString*)value;

-(BOOL)clearHisData;

-(BOOL)insertSingleMessage:(NSString *)jid Resource:(NSString *)resource Content:(NSString*)content SendDateTime:(NSDate *)time IsMyMessage:(BOOL)isMyMessage;
-(BOOL)insertSingleMessage:(NSString *)jid Resource:(NSString *)resource Content:(NSString*)content SendDateTime:(NSDate *)time IsMyMessage:(BOOL)isMyMessage xmlcontent:(NSString*)xmlcontent;

//分享
//-(BOOL)insertSnsShareMessage:(NSString *)jid Resource:(NSString *)resource Content:(NSString*)content SendDateTime:(NSDate *)time IsMyMessage:(BOOL)isMyMessage xmlcontent:(NSString*)xmlcontent msgtype:(NSString*)type;

-(BOOL) querySingleMessage:(NSMutableArray *)recordArray withJID:(NSString *)jid StartRow:(int)row MsgCount:(int)count;
-(int) getSingleMessageCount:(NSString *)jid;
-(BOOL) deleteSingleMessageByGUID:(NSString *)guid;
-(BOOL) deleteSingleMessageWithJid:(NSString *)jid;

-(BOOL)deleteIMDept;
-(BOOL)insertIMDept:(NSString *)deptid DeptName:(NSString *)deptname PID:(NSString *)pid noorder:(int)noorder;
- (NSDictionary*)getDepartmentRoot;
//-(NSString *)QueryDepartmentName:(NSString *)deptid;
-(NSArray*)getDeptByParent:(NSString *)pid;

-(void)deleteGroupInfo;
-(void)deleteGroupByID:(NSString *)groupid;
-(BOOL)insertGroupInfo:(NSString *)groupid GroupName:(NSString *)groupname GroupClass:(NSString *)groupclass GroupDesc:(NSString *)groupdesc GroupPost:(NSString *)grouppost Creator:(NSString *)creator AddMemberMethod:(NSString *)add_member_method Valid:(NSString *)valid;
-(NSArray*)getIMGroup;
-(NSDictionary*)getIMGroupByID:(NSString *)groupid;


-(void)deleteGroupMember:(NSString *)groupid;
//移除群组成员
-(void)deleteGroupMemberEmployee:(NSString *)groupid employeeid:(NSString *)employeeid;

-(BOOL)insertGroupMember:(NSString *)groupid EmployeeID:(NSString *)employeeid GroupRole:(NSString *)grouprole Nick:(NSString *)employeenick Note:(NSString *)employeenote;
-(NSArray*)getGroupMember:(NSString *)groupid;
-(NSArray*)getGroupMember:(NSString *)groupid MemberJID:(NSString *)memberjid;
-(NSString*)getGroupMemberVer:(NSString*)groupid;
-(BOOL)setGroupMemberVer:(NSString*)groupid version:(NSString*)version;
-(BOOL)insertCircleClass:(NSArray *)circleClasses;
-(NSArray *)getCircleClass;
-(NSDictionary *)getCircleClass:(NSString *)cicrleclassid;
-(BOOL) insertGroupMessage:(NSString *)groupid UserJID:(NSString *)userjid Resource:(NSString *)resource NickName:(NSString *)nickname MessageType:(NSString *)type Content:(NSString*)content SendDateTime:(NSDate *)sendtime IsReceived:(BOOL)isReceived;

-(BOOL) insertGroupMessage:(NSString *)groupid UserJID:(NSString *)userjid Resource:(NSString *)resource NickName:(NSString *)nickname MessageType:(NSString *)type Content:(NSString*)content SendDateTime:(NSDate *)sendtime IsReceived:(BOOL)isReceived xmlcontent:(NSString*)xmlcontent;



-(BOOL) queryGroupMessage:(NSMutableArray *)recordArray withGroupID:(NSString *)groupid StartRow:(int)row MsgCount:(int)count;
-(int) getGroupMessageCount:(NSString *)groupid;
-(BOOL) deleteGroupMessageByGUID:(NSString *)guid;
-(BOOL) deleteGroupMessageWithGroupid:(NSString *)groupid;

-(BOOL) insertBusinessMessage:(NSString *)jid MessageCaption:(NSString *)caption Content:(NSString*)content SendDateTime:(NSDate*)time unreadnum:(int)unreadnum MessageType:(int)msg_type LinkString:(NSString *)link existButton:(BOOL)existbutton guid:(NSMutableString *)guid;
-(BOOL) insertBusinessMessage_AboutMe:(NSString *)jid MessageCaption:(NSString *)caption Content:(NSString*)content SendDateTime:(NSDate*)time unreadnum:(int)unreadnum MessageType:(int)msg_type LinkString:(NSString *)link existButton:(BOOL)existbutton guid:(NSMutableString *)guid;
-(NSArray*) queryBusinessMessageWithStartRow:(int)start withCount:(int)count;
-(NSArray*) queryBusinessMessageWithStartRow:(int)start withCount:(int)count withType:(NSArray*)msg_types;
-(NSDictionary*)queryBusinessMessageWithGUID:(NSString*)guid;
-(BOOL)delBusinessMessageWithjid:(NSString*)jidbare withType:(int)msg_type;
//-(int) getBusinessUnreadCount;
-(BOOL)delBusinessMessageWithGuid:(NSString*)guid;
-(BOOL) setBusinessRead:(NSString*)guid;
-(BOOL) insertBusinessMessageButton:(NSString *)business_guid serial:(int)serial text:(NSString*)text code:(NSString *)code value:(NSString *)value link:(NSString *)link method:(NSString *)method blank:(NSString *)blank showremark:(NSString *)showremark remarklabel:(NSString *)remarklabel;
-(BOOL) queryBusinessMessageButtons:(NSString *)businessGuid buttonArray:(NSMutableArray *)buttonArray;
//business
-(BOOL)updateStaff:(NSString *)jid PhotoName:(NSString *)photo_path Desc:(NSString*)self_desc bindMobile:(NSString *)bind;
-(BOOL)updateStaff:(NSString *)jid PhotoPath:(NSString *)photoPath PhotoPathBig:(NSString *)photoPathBig PhotoPathSmall:(NSString *)photoPathSmall;

-(BOOL)insertStaff:(SNSStaffFull*)staff;
//-(NSString*)getStaffPhotoPath:(NSString*)jidbare;
//-(NSString*)getStaffPhotoPathSmall:(NSString*)jidbare;
//-(NSString*)getStaffPhotoPathBig:(NSString*)jidbare;
-(NSString*)getStaffDescByLoginAccount:(NSString*)login_account;
//-(NSString*)getStaffDescByJid:(NSString*)jidbare;
//-(NSString*)getStaffNickByJid:(NSString*)jidbare;
//-(BOOL)getStaffFullByJid:(NSString*)jidbare StaffInfo:(NSMutableDictionary *)staff;
-(BOOL)getStaffFullByJid:(NSString*)jidbare stafffull:(SNSStaffFull *)staff;
-(BOOL)getStaffFullByEmail:(NSString*)email stafffull:(SNSStaffFull *)staff;

- (NSArray *)getStaffList:(NSString *)fafaJid;

-(NSArray*)getRosterJidStrs;
-(BOOL)clearRoster;
-(BOOL)insertRoster:(NSString*)jidbare nick:(NSString*)nick subscription:(NSString*)subscription groups:(NSArray*)groups;
-(BOOL)deleteRoster:(NSString*)jidbare;
-(NSArray*)getRosterGroups:(NSString*)jidbare;
//-(BOOL)saveRoster:(NSArray*)friendArray;
-(NSArray*)getIMFriendGroups;
-(BOOL)saveIMFriendGroups:(NSArray*)friendGroupArray;
-(NSArray*)getRosterInner:(NSString*)Aeno; //内部联系人
-(NSArray*)getRosterOuter:(NSString*)Aeno; //外部联系人
-(NSArray*)getRosterByGroupName:(NSString*)Agroupname;

-(BOOL)saveRosterResource:(NSString *)jidbare resource:(NSString*)resource pres_xml:(NSString*)pres_xml pres_date:(NSDate*)pres_date;
-(BOOL)deleteRosterResource:(NSString *)jidbare resource:(NSString*)resource;
-(NSArray*)getRosterResource:(NSString *)jidbare;
-(BOOL)clearAllRosterResource;

-(NSArray*)getConv:(NSString*)circleid groupid:(NSString*)groupid lastid:(NSString*)lastid;
-(BOOL)saveConvs:(NSArray*)convs;
//-(BOOL)saveReplys:(NSArray*)replys conv_id:(NSString*)conv_id;
//-(NSArray*)getReplys:(NSString*)conv_id lastid:(NSString*)lastid;
//
//-(NSArray *)getBulletin:(NSString *)circleid groupid:(NSString *)groupid lastid:(NSString *)lastid;
//-(BOOL)saveBulletins:(NSArray*)bulletins;
//
//-(NSArray *)getWeMessage:(NSString *)lastid;
//-(BOOL)saveWeMessages:(NSArray*)we_messages;
//
-(NSArray*)getConvAtme:(NSString*)lastid;
-(BOOL)saveConvsAtme:(NSArray*)convs;

-(BOOL)getTopSessionLastFive:(NSMutableArray *)re;
-(BOOL)getSessionLastFive:(NSMutableArray *)re;

-(NSArray*)getCircles;
-(BOOL)saveCircles:(NSArray*)circles;
-(BOOL)updateCircle:(SNSCircle*)circle;
-(SNSCircle *)getCircle:(NSString *)circleid;

-(NSArray*)getCircleGroups:(NSString *)circleid;
-(BOOL)saveCircleGroups:(NSArray*)groups CircleID:(NSString *)circleid;
-(SNSGroup*)getCircleGroupInfo:(NSString *)groupid;


-(BOOL)insertDeptEmployee:(NSString *)deptid EmployeeID:(NSString *)employeeid EmployeeName:(NSString *)employeename LoginName:(NSString *)loginname;
-(BOOL)deleteDeptEmployee;
-(NSArray*)QueryDeptEmployee:(NSString *)deptid;

-(NSArray*)getWeMicroaccount:(int)micro_use;
-(SNSMicroAccount*)getWeMicroaccount:(NSString*)number MicroUseType:(int)micro_use;
-(SNSMicroAccount*)getWeMicroAccount:(NSString*)number;
-(BOOL)saveWeMicroaccount:(NSArray*)acccounts;


-(NSArray *)getAuthority;
-(BOOL)permissionAuthority:(int)fm;
-(BOOL)deleteAuthority;
-(BOOL)insertAuthority:(int)auth;
-(int)getAuthorityLevel;
-(BOOL)updateAuthorityLevel:(int)authlevel;

-(BOOL)saveAttenStaffs:(NSString *)jid returnAttenList:(NSArray *)attenlist;
-(BOOL)isAttenStuff:(NSString *)jid staff_login_account:(NSString *)loginaccount;

-(BOOL)updateGroupInfo:(SNSGroup *)snsGroup;

-(BOOL)addImGroupTypes:(NSArray *)grouptypes;
-(NSMutableArray *)getImGroupTypes;
-(SNSGroupType *)getImGroupType:(NSString *)grouptypeid;
-(BOOL)updateStaff:(SNSStaffFull *)snsStaffFull;

-(NSMutableArray *)getSNSDepts;
-(BOOL)saveSNSDepts:(NSArray *)snsDepts;
-(BOOL)checkCircleWithName:(NSString *)circlename OldCircleName:(NSString *)oldCircleName;
-(BOOL)cehckSNSGroupWithName:(NSString *)groupname Circleid:(NSString *)circleid OldGroupName:(NSString *)oldGroupName;

-(SNSGroup *)getSNSGroupWithFafaGroupid:(NSString *)fafaGroupid;
-(SNSCircle *)getSNSCircleWithFafaGroupid:(NSString *)fafaGroupid;

-(NSDictionary *)getIMRosterWithJid:(NSString *)jid;


//
-(BOOL)getStaffFullByLdapUID:(NSString*)ldap_uid stafffull:(SNSStaffFull *)staff;
-(BOOL)updateStaffLdapUID:(NSString*)ldap_uid staffJID:(NSString *)jid;
-(BOOL)deletMySelfStaffLdapUID:(NSString*)ldap_uid;
////////消息去重 2015-2-9 lvxuejun
-(BOOL) querySingleMessageByGuid:(NSString*)elementid;
-(BOOL) queryGroupMessageByGuid:(NSString*)elementid;
-(BOOL) queryBusinessMessageWithGuid:(NSString*)elementId;
-(BOOL)insertSingleMessage:(NSString *)jid Resource:(NSString *)resource Content:(NSString*)content SendDateTime:(NSDate *)time IsMyMessage:(BOOL)isMyMessage xmlcontent:(NSString*)xmlcontent guid:(NSString*)guid;
-(BOOL) insertGroupMessage:(NSString *)groupid UserJID:(NSString *)userjid Resource:(NSString *)resource NickName:(NSString *)nickname MessageType:(NSString *)type Content:(NSString*)content SendDateTime:(NSDate *)sendtime IsReceived:(BOOL)isReceived xmlcontent:(NSString*)xmlcontent guid:(NSString*)guid;
@end

extern SQLiteOper *g_sqlite;
SQLiteOper* get_g_sqlite();
#define sqlite get_g_sqlite()

