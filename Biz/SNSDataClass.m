//
//  SNSDataClass.m
//  Wefafa
//
//  Created by fafa  on 13-7-12.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "SNSDataClass.h"
#import "utils.h"
#import "JSONKit.h"

@implementation SNSDataClass

@end

//////////////////////////////////////////////////////////////////
@implementation SNSCircle
-(void)setJSONValue:(NSDictionary *)dict
{
    self.circle_id=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"circle_id"]] ];
    self.circle_name=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"circle_name"]] ];
    self.circle_desc=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"circle_desc"]] ];
    self.logo_path=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"logo_path"]] ];
    self.create_staff=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"create_staff"]] ];
    self.create_date=[NSDate parse:[Utils getSNSString:dict[@"create_date"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
    self.manager=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"manager"]] ];
    self.join_method=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"join_method"]] ];
    self.enterprise_no=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"enterprise_no"]] ];
    self.fafa_groupid=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"fafa_groupid"]] ];
    self.network_domain=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"network_domain"]] ];
    self.allow_copy=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"allow_copy"]] ];
    self.logo_path_small=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"logo_path_small"]] ];
    self.logo_path_big=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"logo_path_big"]] ];
    self.circle_class_name=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"classify_name"]] ];
    self.circle_class_id=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"circle_class_id"]] ];
    self.staff_num=[[Utils getSNSFloat:dict[@"staff_num"]] intValue];
    self.fafa_groupid=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:dict[@"fafa_groupid"]] ];
}
-(id)copyWithZone:(NSZone *)zone{
    return [self copySNSCircle:zone];
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return [self copySNSCircle:zone];
}

-(SNSCircle *)copySNSCircle:(NSZone *)zone {
    SNSCircle *snsCircle=[[SNSCircle allocWithZone:zone] init];
    snsCircle->_circle_id=self.circle_id;
    snsCircle->_circle_name=self.circle_name;
    snsCircle->_circle_desc=self.circle_desc;
    snsCircle->_logo_path=self.logo_path;
    snsCircle->_create_staff=self.create_staff;
    snsCircle->_manager=self.manager;
    snsCircle->_join_method=self.join_method;
    snsCircle->_enterprise_no=self.enterprise_no;
    snsCircle->_network_domain=self.network_domain;
    snsCircle->_allow_copy=self.allow_copy;
    snsCircle->_logo_path_small=self.logo_path_small;
    snsCircle->_logo_path_big=self.logo_path_big;
    snsCircle->_circle_class_id=self.circle_class_id;
    snsCircle->_circle_class_name=self.circle_class_name;
    snsCircle->_staff_num=self.staff_num;
    snsCircle->_fafa_groupid=self.fafa_groupid;
    return snsCircle;
}
@end

//////////////////////////////////////////////////////////////////
@implementation SNSGroup

-(void)setJSONValue:(NSDictionary *)dict {
    if ([@"" isEqualToString:[Utils getSNSString:[dict objectForKey:@"circleid"]]]) {
        self.circle_id=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"circle_id"]]];
    }
    else self.circle_id=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"circleid"]]];
    
    if ([@"" isEqualToString:[Utils getSNSString:[dict objectForKey:@"groupid"]]]) {
        self.group_id=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"group_id"]]];
    }
    else self.group_id=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"groupid"]]];
    
    if ([@"" isEqualToString:[Utils getSNSString:[dict objectForKey:@"groupname"]]]) {
        self.group_name=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"group_name"]]];
    }
    else self.group_name=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"groupname"]]];
    
    if ([@"" isEqualToString:[Utils getSNSString:[dict objectForKey:@"groupclass"]]]) {
        self.group_class=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"group_class"]]];
    }
    else self.group_class=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"groupclass"]]];
    
    self.group_class_id=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"group_class_id"]]];
    
    if ([@"" isEqualToString:[Utils getSNSString:[dict objectForKey:@"groupdesc"]]]) {
        self.group_desc=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"group_desc"]]];
    }
    else self.group_desc=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"groupdesc"]]];
    
    self.group_notice=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"grouppost"]]];
    
    if ([@"" isEqualToString:[Utils getSNSString:[dict objectForKey:@"groupphotopath"]]]){
        self.group_notice=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"group_photo_path"]]];
    }
    else self.group_photo_path=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"groupphotopath"]]];
    
    if ([@"" isEqualToString:[Utils getSNSString:[dict objectForKey:@"add_member_method"]]]) {
        self.join_method=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"join_method"]]];
    }
    else self.join_method=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"add_member_method"]]];
    
    if ([@"" isEqualToString:[Utils getSNSString:[dict objectForKey:@"creator"]]]) {
        self.create_staff=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"create_staff"]]];
    }
    else self.create_staff=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"creator"]]];
   
    if ([@"" isEqualToString:[Utils getSNSString:[dict objectForKey:@"fafa_groupid"]]]) {
        self.fafa_groupid=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"groupid"]]];
    }
    else self.fafa_groupid=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"fafa_groupid"]]];
    
    if (![@"" isEqualToString:[Utils getSNSString:[dict objectForKey:@"create_date"]]]) {
        self.create_date=[Utils stringToDate:[Utils getSNSString:[dict objectForKey:@"create_date"]]];
    }
}

-(id)copyWithZone:(NSZone *)zone{
    return [self copySNSGroup:zone];
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return [self copySNSGroup:zone];
}

-(SNSGroup *)copySNSGroup:(NSZone *)zone {
    SNSGroup *snsGroup=[[SNSGroup allocWithZone:zone] init];
    snsGroup->_circle_id=self.circle_id;
    snsGroup->_group_id=self.group_id;
    snsGroup->_group_name=self.group_name;
    snsGroup->_group_class_id=self.group_class_id;
    snsGroup->_group_class=self.group_class;
    snsGroup->_group_desc=self.group_desc;
    snsGroup->_group_notice=self.group_notice;
    snsGroup->_group_photo_path=self.group_photo_path;
    snsGroup->_join_method=self.join_method;
    snsGroup->_create_staff=self.create_staff;
    snsGroup->_create_date=self.create_date;
    snsGroup->_fafa_groupid=self.fafa_groupid;
    return snsGroup;
}

@end

//////////////////////////////////////////////////////////////////
@implementation SNSGroupType : SNSDataClass

-(void)setJSONValue:(NSDictionary *)dict {
    self.type_id=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"typeid"]]];
    self.type_name=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"typename"]]];
    self.pid=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"pid"]]];
}

@end

//////////////////////////////////////////////////////////////////
@implementation SNSConvCopy
-(void)setJSONValue:(NSDictionary *)convcopy_dict
{
    self.conv_id=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[convcopy_dict objectForKey:@"conv_id"]]];
    self.create_staff=[[NSString alloc] initWithFormat:@"%@",[convcopy_dict objectForKey:@"create_staff"]];
    NSDictionary *staff_dict=[convcopy_dict objectForKey:@"create_staff_obj"];
    SNSStaff *staff=[[SNSStaff alloc] init];
    [staff setJSONValue:staff_dict];
    self.create_staff_obj=staff;
    self.post_date=[NSDate parse:[Utils getSNSString:convcopy_dict[@"post_date"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
    self.conv_type_id=[[NSString alloc] initWithFormat:@"%@",[convcopy_dict objectForKey:@"conv_type_id"]];
    self.conv_content=[[NSString alloc] initWithFormat:@"%@",[convcopy_dict objectForKey:@"conv_content"]];
    self.copy_num=(int)[[Utils getSNSFloat:[convcopy_dict objectForKey:@"copy_num"]] intValue];
    self.reply_num=(int)[[Utils getSNSFloat:[convcopy_dict objectForKey:@"reply_num"]] intValue];
    self.atten_num=(int)[[Utils getSNSFloat:[convcopy_dict objectForKey:@"atten_num"] ] intValue];
    self.like_num=[[Utils getSNSInteger:[convcopy_dict objectForKey:@"like_num"]] intValue];
    
    NSMutableArray *new_likes=[[NSMutableArray alloc] initWithCapacity:5];
    NSArray *likesArray=[convcopy_dict objectForKey:@"likes"];
    for (NSDictionary *like_dict in likesArray) {
        SNSLike *snslike=[[SNSLike alloc] init];
        [snslike setJSONValue:like_dict];
        [new_likes addObject:snslike];
    }
    self.likes=new_likes;
    
    NSMutableArray *new_attachs=[[NSMutableArray alloc] initWithCapacity:5];
    NSArray *attachsArray=[convcopy_dict objectForKey:@"attachs"];
    for (NSDictionary *attach_dict in attachsArray) {
        SNSAttach *snsattach=[[SNSAttach alloc] init];
        [snsattach setJSONValue:attach_dict];
        [new_attachs addObject:snsattach];
    }
    self.attachs=new_attachs;
    
    self.comefrom=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[convcopy_dict objectForKey:@"comefrom"]]];
    self.post_to_group=[[NSString alloc] initWithFormat:@"%@",[convcopy_dict objectForKey:@"post_to_group"]];
    self.attachHeight=0;
}
@end

//////////////////////////////////////////////////////////////////
@implementation SNSConv

-(void)setJSONValue:(NSDictionary *)conv_dict
{
    [super setJSONValue:conv_dict];
    NSMutableArray *new_replys=[[NSMutableArray alloc] initWithCapacity:5];
    NSArray *replysArray=[conv_dict objectForKey:@"replys"];
    for (NSDictionary *reply_dict in replysArray) {
        SNSReply *snsreply=[[SNSReply alloc] init];
        [snsreply setJSONValue:reply_dict];
        [new_replys addObject:snsreply];
    }
    self.replys=new_replys;
    
    self.iscollect=[[NSMutableString alloc] initWithFormat:@"%@",[conv_dict objectForKey:@"iscollect"]];
    
    NSString *convStr=@"";
    if(conv_dict[@"link_url"]!=nil&&![conv_dict[@"link_url"] isEqual:[NSNull null]])
    {
        if ([[conv_dict objectForKey:@"link_url"] rangeOfString:@"}"].location==NSNotFound)
        {
//            convStr=[[NSString alloc] initWithFormat:@"%@}}",[conv_dict objectForKey:@"link_url"] ];
            convStr=[[NSString alloc] initWithFormat:@"{\"iosclass\":\"\",\"androidclass\":\"com.mb.component.dapei\",\"bizdata\":{\"title\":\"\u6bd2\u6c14\",\"id\":1012,\"type\":\"2\",\"shareUserId\":\"e680da8c-2776-4c72-961a-18ee96582cf0\",\"shareContent\":\"ggg\"}}"];
        }
        else
        {
            convStr=[conv_dict objectForKey:@"link_url"];
        }
    }
    if (convStr.length>0)
        self.conv_link_url=[convStr objectFromJSONString];
    else
        self.conv_link_url=[[NSDictionary alloc] init];
    
    NSDictionary *together_dict=[conv_dict objectForKey:@"together"];
    self.together=[[SNSTogether alloc] init];
    [self.together setJSONValue:together_dict];
    
    NSDictionary *vote_dict=[conv_dict objectForKey:@"vote"];
    self.vote=[[SNSVote alloc] init];
    [self.vote setJSONValue:vote_dict];
    
    NSDictionary *conv_copy_dict=[conv_dict objectForKey:@"conv_copy"];
    self.conv_copy=[[SNSConvCopy alloc] init];
    [self.conv_copy setJSONValue:conv_copy_dict];
    
    self.conv_root_id=[[NSString alloc] initWithFormat:@"%@",self.conv_copy.conv_id];
    self.attachHeight=0;
}
@end

//////////////////////////////////////////////////////////////////
@implementation SNSLike
- (void)setJSONValue:(NSDictionary *)like_dict
{
    self.like_staff=[[NSString alloc] initWithFormat:@"%@",[like_dict objectForKey:@"like_staff"]];
    self.like_staff_nickname=[[NSString alloc] initWithFormat:@"%@",[like_dict objectForKey:@"like_staff_nickname"]];
    self.like_date=[NSDate parse:[Utils getSNSString:like_dict[@"like_date"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
}

@end
//////////////////////////////////////////////////////////////////
@implementation SNSReply
- (void)setJSONValue:(NSDictionary *)reply_dict
{
    self.comefrom=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[reply_dict objectForKey:@"comefrom"]]];
    self.reply_id=[[NSString alloc] initWithFormat:@"%@",[reply_dict objectForKey:@"reply_id"]];
    self.reply_staff=[[NSString alloc] initWithFormat:@"%@",[reply_dict objectForKey:@"reply_staff"]];
    
    NSDictionary *staff_dict=[reply_dict objectForKey:@"reply_staff_obj"];
    SNSStaff *staff=[[SNSStaff alloc] init];
    [staff setJSONValue:staff_dict];
    self.reply_staff_obj=staff;
    
    NSMutableArray *new_attachs=[[NSMutableArray alloc] initWithCapacity:5];
    NSArray *attachsArray=[reply_dict objectForKey:@"attachs"];
    for (NSDictionary *attach_dict in attachsArray) {
        SNSAttach *snsattach=[[SNSAttach alloc] init];
        [snsattach setJSONValue:attach_dict];
        [new_attachs addObject:snsattach];
    }
    self.attachs=new_attachs;
    
    self.reply_date=[NSDate parse:[Utils getSNSString:reply_dict[@"reply_date"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
    self.reply_content=[[NSString alloc] initWithFormat:@"%@",[reply_dict objectForKey:@"reply_content"]];
    self.reply_to=[[NSString alloc] initWithFormat:@"%@",[reply_dict objectForKey:@"reply_to"]];
    self.reply_to_nickname=[[NSString alloc] initWithFormat:@"%@",[reply_dict objectForKey:@"reply_to_nickname"]];
    
    NSMutableArray *new_likes=[[NSMutableArray alloc] initWithCapacity:5];
    NSArray *likesArray=[reply_dict objectForKey:@"likes"];
    for (NSDictionary *like_dict in likesArray) {
        SNSLike *snslike=[[SNSLike alloc] init];
        [snslike setJSONValue:like_dict];
        [new_likes addObject:snslike];
    }
    self.likes=new_likes;
    
//    self.like_num = [reply_dict[@"like_num"] intValue];
    self.like_num = [[Utils getSNSInteger:reply_dict[@"like_num"]] intValue];
}

@end
//////////////////////////////////////////////////////////////////
@implementation SNSVoteOption
- (void)setJSONValue:(NSDictionary *)voteoption_dict
{
    self.option_id=[[NSString alloc] initWithFormat:@"%@",[voteoption_dict objectForKey:@"option_id"]];
    self.option_desc=[[NSString alloc] initWithFormat:@"%@",[voteoption_dict objectForKey:@"option_desc"]];
    self.vote_num=[[voteoption_dict objectForKey:@"vote_num"] intValue];
}

@end
//////////////////////////////////////////////////////////////////
@implementation SNSVote
- (void)setJSONValue:(NSDictionary *)vote_dict
{
    self.title=[[NSString alloc] initWithFormat:@"%@",[vote_dict objectForKey:@"title"]];
    self.vote_all_num=[[vote_dict objectForKey:@"vote_all_num"] intValue];
    self.is_multi=[[NSString alloc] initWithFormat:@"%@",[vote_dict objectForKey:@"is_multi"]];
    self.finishdate=[NSDate parse:[Utils getSNSString:vote_dict[@"finishdate"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
    
    NSMutableArray *new_options=[[NSMutableArray alloc] initWithCapacity:5];
    NSDictionary *optionsArray=[vote_dict objectForKey:@"vote_options"];
    for(NSDictionary *option_dict in optionsArray)
    {
        SNSVoteOption *voteoption=[[SNSVoteOption alloc] init];
        [voteoption setJSONValue:option_dict];
        [new_options addObject:voteoption];
    }
    self.vote_options=new_options;
    
    self.isvoted=[[NSString alloc] initWithFormat:@"%@",[vote_dict objectForKey:@"isvoted"]];
    self.vote_user_num=[[vote_dict objectForKey:@"vote_user_num"] intValue];
}

@end
//////////////////////////////////////////////////////////////////
@implementation SNSTogether
- (void)setJSONValue:(NSDictionary *)together_dict
{
    self.title=[[NSString alloc] initWithFormat:@"%@",[together_dict objectForKey:@"title"]];
    self.will_date=[NSDate parse:[Utils getSNSString:together_dict[@"will_date"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
    self.will_dur=[[NSString alloc] initWithFormat:@"%@",[together_dict objectForKey:@"will_dur"]];
    self.will_addr=[[NSString alloc] initWithFormat:@"%@",[together_dict objectForKey:@"will_addr"]];
    self.together_desc=[[NSString alloc] initWithFormat:@"%@",[together_dict objectForKey:@"together_desc"]];
    
    NSMutableArray *new_together_staffs=[[NSMutableArray alloc] initWithCapacity:5];
    NSArray *staffArray=[together_dict objectForKey:@"together_staffs"];
    for (NSDictionary *staff_dict in staffArray) {
        SNSTogetherStaff *staff=[[SNSTogetherStaff alloc] init];
        [staff setJSONValue:staff_dict];
        [new_together_staffs addObject:staff];
    }
    self.together_staffs=new_together_staffs;
}

@end
//////////////////////////////////////////////////////////////////
@implementation SNSTogetherStaff
- (void)setJSONValue:(NSDictionary *)staff_dict
{
    self.staff_id=[[NSString alloc] initWithFormat:@"%@",[staff_dict objectForKey:@"staff_id"]];
    self.staff_name=[[NSString alloc] initWithFormat:@"%@",[staff_dict objectForKey:@"staff_name"]];
}

@end
//////////////////////////////////////////////////////////////////
@implementation SNSAttach
- (void)setJSONValue:(NSDictionary *)attch_dict
{
    self.attach_id=[[NSString alloc] initWithFormat:@"%@",[attch_dict objectForKey:@"attach_id"]];
    self.file_name=[[NSString alloc] initWithFormat:@"%@",[attch_dict objectForKey:@"file_name"]];
    self.file_ext=[[NSString alloc] initWithFormat:@"%@",[attch_dict objectForKey:@"file_ext"]];
    self.up_by_staff=[[NSString alloc] initWithFormat:@"%@",[attch_dict objectForKey:@"up_by_staff"]];
    self.up_date=[NSDate parse:[Utils getSNSString:attch_dict[@"up_date"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
}

@end
//////////////////////////////////////////////////////////////////
@implementation SNSStaff
- (void)setJSONValue:(NSDictionary *)staff_dict
{
    self.login_account=[[NSString alloc] initWithFormat:@"%@",[staff_dict objectForKey:@"login_account"]];
    self.nick_name=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[staff_dict objectForKey:@"nick_name"]]];
    self.photo_path=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[staff_dict objectForKey:@"photo_path"]]];
    self.photo_path_small=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[staff_dict objectForKey:@"photo_path_small"]]];
    self.photo_path_big=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[staff_dict objectForKey:@"photo_path_big"]]];
    self.eshortname=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[staff_dict objectForKey:@"eshortname"]]];
    self.openid=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[staff_dict objectForKey:@"openid"]]];
    self.ldap_uid=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[staff_dict objectForKey:@"ldap_uid"]]];
}

@end


//////////////////////////////////////////////////////////////////
@implementation SNSStaffFull

-(void)setJSONValue:(NSDictionary *)dicstaff
{
    [super setJSONValue:dicstaff];
    
    self.dept_id = [NSString stringWithFormat:@"%@", dicstaff[@"dept_id"]];
    self.dept_name = [Utils getSNSString: dicstaff[@"dept_name"]];
    self.eno = [NSString stringWithFormat:@"%@", dicstaff[@"eno"]];
    self.ename = [NSString stringWithFormat:@"%@", dicstaff[@"ename"]];
    self.self_desc = [Utils getSNSString: dicstaff[@"self_desc"]];
    self.duty = [Utils getSNSString:dicstaff[@"duty"]];
    self.birthday = [NSDate parse:[Utils getSNSString:dicstaff[@"birthday"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
    self.specialty = [Utils getSNSString: dicstaff[@"specialty"]];
    self.hobby = [Utils getSNSString:dicstaff[@"hobby"]];
    self.work_phone = [Utils getSNSString: dicstaff[@"work_phone"]];
    self.mobile = [Utils getSNSString:dicstaff[@"mobile"]];
    self.mobile_is_bind = [NSString stringWithFormat:@"%@", dicstaff[@"mobile_is_bind"]];
    self.total_point = [[NSString stringWithFormat:@"%@", dicstaff[@"total_point"]] doubleValue];
    self.register_date = [NSDate parse:[Utils getSNSString: dicstaff[@"register_date"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
    self.active_date = [NSDate parse:[Utils getSNSString: dicstaff[@"active_date"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
    self.attenstaff_num = [[NSString stringWithFormat:@"%@", dicstaff[@"attenstaff_num"]] intValue];
    self.fans_num = [[NSString stringWithFormat:@"%@", dicstaff[@"fans_num"]] intValue];
    self.publish_num = [[NSString stringWithFormat:@"%@", dicstaff[@"publish_num"]] intValue];
    self.jid = [Utils getSNSString:dicstaff[@"jid"]];
    self.micro_use = [Utils getSNSString:dicstaff[@"micro_use"]];
    self.sex_id = [Utils getSNSString:dicstaff[@"sex_id"]];
    self.user_vip_type = [Utils getSNSInteger:dicstaff[@"user_vip_type"]];
    self.last_login_date =[NSDate parse:[Utils getSNSString: dicstaff[@"last_login_date"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
}

-(NSDictionary *)getDictionary
{
    NSDictionary *dict=@{@"dept_id":self.dept_id,
                         @"dept_name":self.dept_name,
                         @"eno":self.eno,
                         @"ename":self.ename,
                         @"self_desc":self.self_desc,
                         @"duty":self.duty,
                         @"birthday":[self.birthday toDateTimeString],
                         @"specialty":self.specialty,
                         @"hobby":self.hobby,
                         @"work_phone":self.work_phone,
                         @"mobile":self.mobile,
                         @"mobile_is_bind":self.mobile_is_bind,
                         @"total_point":[NSString stringWithFormat:@"%f",self.total_point],
                         @"register_date":[self.register_date toDateTimeString],
                         @"active_date":[self.active_date toDateTimeString],
                         @"attenstaff_num":[NSString stringWithFormat:@"%d",self.attenstaff_num],
                         @"fans_num":[NSString stringWithFormat:@"%d",self.fans_num],
                         @"publish_num":[NSString stringWithFormat:@"%d",self.publish_num],
                         @"jid":self.jid,
                         @"micro_use":self.micro_use,
                         @"sex_id":self.sex_id,
                         @"openid":self.openid,
                         @"ldap_uid":self.ldap_uid,
                         };
    return dict;
}

@end

//////////////////////////////////////////////////////////////////
@implementation SNSMicroAccount

@end 

/////////////////////////////////
@implementation SNSEnterprise

- (void)setJSONValue:(NSDictionary *)en_dict
{
    self.eno=[[NSString alloc] initWithFormat:@"%@",[en_dict objectForKey:@"eno"]];
    self.ename=[[NSString alloc] initWithFormat:@"%@",[en_dict objectForKey:@"ename"]];
}
@end

//////////////////////////////////////////////////////////////////
@implementation SNSEnterpriseStaff
- (void)setJSONValue:(NSDictionary *)staff_dict
{
    self.login_account=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[staff_dict objectForKey:@"login_account"]]];
    self.name=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[staff_dict objectForKey:@"name"]]];
    self.photo_path=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[staff_dict objectForKey:@"photo_path"]]];
    self.fafa_jid=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[staff_dict objectForKey:@"fafa_jid"]]];
}

@end
/////////////////////////////////
@implementation SNSRecommendUser

- (void)setJSONValue:(NSDictionary *)dict
{
    self.classify_name=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"classify_name"]]];
    self.classify_parent_name=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"classify_parent_name"]]];
    self.duty=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"duty"]]];
    self.ename=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"ename"]]];
    self.eno=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"eno"]]];
    self.eshortname=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"eshortname"]]];
    self.hobby=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"hobby"]]];
    self.login_account=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"login_account"]]];
    self.logo=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"logo"]]];
    self.mobile=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"mobile"]]];
    self.nick_name=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"nick_name"]]];
    self.photo_path=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"photo_path"]]];
    self.photo_path_big=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"photo_path_big"]]];
    self.photo_path_small=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"photo_path_small"]]];
    self.sex_id=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"sex_id"]]];
}

@end


/////////////////////////////////

@implementation SNSCircleStaff

- (void)setJSONValue:(NSDictionary *)dict
{
    [super setJSONValue:dict];
    
    self.ename=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"ename"]]];
}

@end

/////////////////////////////////
@implementation SNSRecommendCircle

- (void)setJSONValue:(NSDictionary *)dict
{
    self.circle_id=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"circle_id"]]];
    self.circle_name=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"circle_name"]]];
    self.circle_desc=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"circle_desc"]]];
    self.create_date=[NSDate parse:[Utils getSNSString:dict[@"create_date"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
    self.create_staff=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"create_staff"]]];
    self.logo_path=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"logo_path"]]];
    self.logo_path_big=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"logo_path_big"]]];
    self.logo_path_small=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"logo_path_small"]]];
    self.staff_num=[[Utils getSNSInteger:dict[@"staff_num"]] intValue];
    
    SNSStaff *staff=[[SNSStaff alloc] init];
    [staff setJSONValue:[dict objectForKey:@"staff"]];
    self.create_staff_obj=staff;
    
    NSMutableArray *circle_staffs=[[NSMutableArray alloc] initWithCapacity:5];
    NSArray *staffArray=[dict objectForKey:@"top"];
    for (NSDictionary *staff_dict in staffArray) {
        SNSCircleStaff *staff=[[SNSCircleStaff alloc] init];
        [staff setJSONValue:staff_dict];
        [circle_staffs addObject:staff];
    }
//    self.members=circle_staffs;
}

@end

/////////////////////////////////



@implementation SNSTagInfo

- (void)setJSONValue:(NSDictionary *)tag_dict
{
    self.create_date=[NSDate parse:[Utils getSNSString:tag_dict[@"create_date"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
    self.tag_desc=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[tag_dict objectForKey:@"tag_desc"]]];
    self.tag_id=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[tag_dict objectForKey:@"tag_id"]]];
    self.tag_name=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[tag_dict objectForKey:@"tag_name"]]];
}

@end

/////////////////////////////////

@implementation SNSCircleClass

- (void)setJSONValue:(NSDictionary *)dict
{
    self.classify_id=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"id"]]];
    self.classify_name=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"name"]]];
    self.parent_classify_id=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"parent_id"]]];}

@end

////////////////////////////////

@implementation SNSDept

- (void)setJSONValue:(NSDictionary *)dict
{
    self.dept_id=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"dept_id"]]];
    self.dept_name=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"dept_name"]]];
    self.parent_deptid=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"parent_deptid"]]];
    self.fafa_deptid=[NSString stringWithFormat:@"%@",[Utils getSNSString:[dict objectForKey:@"fafa_deptid"]]];
}

@end



