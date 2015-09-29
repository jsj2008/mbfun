//
//  DBInitSql.m
//  FaFa
//
//  Created by fafa  on 13-5-12.
//
//

#import "DBInitSql.h"

@implementation DBInitSql

static NSArray *_initSql = nil;
+(void)genInitSql
{
    _initSql = @[
                 @0, @[],   //占位
                 @1, @[@"\
                       create table dbversion (	\
                       version              numeric(8)                     not null,	\
                       note                 text,	\
                       primary key (version)	\
                       )",
                       @"\
                       create table im_dept (	\
                       deptid               varchar(100)                   not null,	\
                       deptname             varchar(100),	\
                       pid                  varchar(100),	\
                       noorder              numeric(8),	\
                       primary key (deptid)	\
                       )",
                       @"\
                       create table im_employee (	\
                       employeeid           varchar(100)                   not null,	\
                       deptid               varchar(100),	\
                       loginname            varchar(100),	\
                       employeename         varchar(100),	\
                       primary key (employeeid)	\
                       )",
                       @"\
                       create table im_friendgroups (	\
                       groupname            varchar(100)                   not null,	\
                       noorder              numeric(8),	\
                       primary key (groupname)	\
                       )",
                       @"\
                       create table im_group (	\
                       groupid              varchar(20)                    not null,	\
                       groupname            varchar(200),	\
                       groupclass           varchar(20),	\
                       groupdesc            text,	\
                       grouppost            text,	\
                       creator              varchar(100),	\
                       add_member_method    varchar(20),     \
                       primary key (groupid)	\
                       )",
                       @"\
                       create table im_groupemployee (	\
                       employeeid           varchar(100)                   not null,	\
                       groupid              varchar(20)                    not null,	\
                       grouprole            varchar(20),	\
                       employeenick         varchar(200),	\
                       employeenote         varchar(200),	\
                       primary key (employeeid, groupid)	\
                       )",
                       @"\
                       create table im_groupemployee_version (	\
                       groupid              varchar(20)                    not null,	\
                       version              varchar(100),	\
                       primary key (groupid)	\
                       )",
                       @"\
                       create table im_message_business (	\
                       guid                 varchar(50)                    not null,	\
                       sender_jid_bare      varchar(100),	\
                       business_caption     varchar(200),	\
                       business_content     text,	\
                       msg_time             datetime,	\
                       isread               varchar(2),	\
                       primary key (guid)	\
                       )",
                       @"\
                       create table im_message_group (	\
                       guid                 varchar(50)                    not null,	\
                       group_id             varchar(50),	\
                       speaker_jid_bare     varchar(100),	\
                       speaker_resource     varchar(100),	\
                       speaker_name         varchar(100),	\
                       msg_text             text,	\
                       msg_time             datetime,	\
                       primary key (guid)	\
                       )",
                       @"\
                       create  index Index_1 on im_message_group (	\
                       group_id ASC	\
                       )",
                       @"\
                       create table im_message_single (	\
                       guid                 varchar(50)                    not null,	\
                       talkabout_jid_bare   varchar(100),	\
                       talkabout_resource   varchar(100),	\
                       msg_text             text,	\
                       msg_time             datetime,	\
                       ismymsg              varchar(2),	\
                       primary key (guid)	\
                       )",
                       @"\
                       create  index Index_2 on im_message_single (	\
                       talkabout_jid_bare ASC	\
                       )",
                       @"\
                       create table im_roster (	\
                       jid                  varchar(100)                   not null,	\
                       nick                 varchar(100),	\
                       subscription         varchar(20),	\
                       primary key (jid)	\
                       )",
                       @"\
                       create table im_rostergroup (	\
                       jid                  varchar(100)                   not null,	\
                       groupname            varchar(100)                   not null,	\
                       primary key (jid, groupname)	\
                       )",
                       @"\
                       create table sys_paras (	\
                       para_name            varchar(100)                   not null,	\
                       para_value           text,	\
                       para_desc            text,	\
                       primary key (para_name)	\
                       )",
                       @"\
                       create table we_conv (	\
                       conv_id              varchar(20)                    not null,	\
                       create_staff         varchar(100),	\
                       post_date            datetime,	\
                       conv_type_id         varchar(20),	\
                       conv_content         text,	\
                       copy_num             numeric(14),	\
                       reply_num            numeric(14),	\
                       atten_num            numeric(14),	\
                       like_num             numeric(14),	\
                       iscollect            varchar(10),	\
                       comefrom             varchar(100),	\
                       post_to_group        varchar(20),	\
                       circle_id            varchar(20),	\
                       conv_root_id         varchar(20),	\
                       primary key (conv_id)	\
                       )",
                       @"\
                       create table we_attach (	\
                       conv_id              varchar(20)                    not null,	\
                       attach_id            varchar(100)                   not null,	\
                       file_name            varchar(100),	\
                       file_ext             varchar(20),	\
                       up_by_staff          varchar(100),	\
                       up_date              datetime,	\
                       primary key (conv_id, attach_id)	\
                       )",
                       @"\
                       create table we_bulletin (	\
                       bulletin_id          varchar(20)                    not null,	\
                       circle_id            varchar(20),	\
                       group_id             varchar(20),	\
                       bulletin_date        datetime,	\
                       bulletin_desc        text,	\
                       bulletin_staff       varchar(100),	\
                       bulletin_staff_nickname varchar(100),	\
                       bulletin_staff_photo varchar(100),	\
                       primary key (bulletin_id)	\
                       )",
                       @"\
                       create table we_circle (	\
                       circle_id            varchar(20)                    not null,	\
                       circle_name          varchar(100),	\
                       circle_desc          text,	\
                       logo_path            varchar(100),	\
                       create_staff         varchar(100),	\
                       create_date          datetime,	\
                       manager              varchar(100),	\
                       join_method          varchar(10),	\
                       enterprise_no        varchar(20),	\
                       network_domain       varchar(100),	\
                       allow_copy           varchar(10),	\
                       logo_path_small      varchar(100),	\
                       logo_path_big        varchar(100),	\
                       primary key (circle_id)	\
                       )",
                       @"\
                       create table we_group (	\
                       circle_id            varchar(20)                    not null,	\
                       group_id             varchar(20)                    not null,	\
                       group_name           varchar(100),	\
                       group_desc           text,	\
                       group_photo_path     varchar(100),	\
                       join_method          varchar(10),	\
                       create_staff         varchar(100),	\
                       create_date          datetime,	\
                       primary key (circle_id, group_id)	\
                       )",
                       @"\
                       create table we_like (	\
                       conv_id              varchar(20)                    not null,	\
                       like_staff           varchar(100)                   not null,	\
                       like_staff_nickname  varchar(100),	\
                       like_date            datetime,	\
                       primary key (conv_id, like_staff)	\
                       )",
                       @"\
                       create table we_message (	\
                       msg_id               varchar(10)                    not null,	\
                       sender               varchar(100),	\
                       sender_nickname      varchar(100),	\
                       sender_photo         varchar(100),	\
                       recver               varchar(100),	\
                       send_date            datetime,	\
                       title                text,	\
                       content              text,	\
                       isread               varchar(10),	\
                       primary key (msg_id)	\
                       )",
                       @"\
                       create table we_reply (	\
                       conv_id              varchar(20)                    not null,	\
                       reply_id             varchar(20)                    not null,	\
                       reply_staff          varchar(100),	\
                       reply_date           datetime,	\
                       reply_content        text,	\
                       reply_to             varchar(100),	\
                       reply_to_nickname    varchar(100),	\
                       like_num             numeric(14),	\
                       comefrom             varchar(100),	\
                       primary key (conv_id, reply_id)	\
                       )",
                       @"\
                       create table we_staff (	\
                       login_account        varchar(100)                   not null,	\
                       nick_name            varchar(100),	\
                       photo_path           varchar(100),	\
                       photo_path_small     varchar(100),	\
                       photo_path_big       varchar(100),	\
                       dept_id              varchar(100),	\
                       dept_name            varchar(100),	\
                       eno                  varchar(100),	\
                       ename                varchar(100),	\
                       eshortname           varchar(100),	\
                       self_desc            text,	\
                       duty                 varchar(100),	\
                       birthday             datetime,	\
                       specialty            text,	\
                       hobby                text,	\
                       work_phone           varchar(100),	\
                       mobile               varchar(100),	\
                       mobile_is_bind       varchar(10),	\
                       total_point          numeric(14,2),	\
                       register_date        datetime,	\
                       active_date          datetime,	\
                       attenstaff_num       numeric(14),	\
                       fans_num             numeric(14),	\
                       publish_num          numeric(14),	\
                       fafa_jid             varchar(100),	\
                       primary key (login_account)	\
                       )",
                       @"\
                       create  index Index_3 on we_staff (	\
                       fafa_jid ASC	\
                       )",
                       @"\
                       create table we_together (	\
                       conv_id              varchar(20)                    not null,	\
                       title                text,	\
                       will_date            datetime,	\
                       will_dur             varchar(100),	\
                       will_addr            text,	\
                       together_desc        text,	\
                       primary key (conv_id)	\
                       )",
                       @"\
                       create table we_together_staff (	\
                       conv_id              varchar(20)                    not null,	\
                       staff_id             varchar(100)                   not null,	\
                       staff_name           varchar(100),	\
                       primary key (conv_id, staff_id)	\
                       )",
                       
                       @"\
                       create table we_vote (	\
                       conv_id              varchar(20)                    not null,	\
                       title                text,	\
                       vote_all_num         numeric(14),	\
                       is_multi             varchar(10),	\
                       finishdate           datetime,	\
                       isvoted              varchar(10),	\
                       vote_user_num        numeric(14),	\
                       primary key (conv_id)	\
                       )",
                       
                       @"\
                       create table we_vote_option (	\
                       conv_id              varchar(20)                    not null,	\
                       option_id            varchar(20)                    not null,	\
                       option_desc          text,	\
                       vote_num             numeric(14),	\
                       primary key (conv_id, option_id)	\
                       )",
                       
                       @"create table we_conv_atme (	\
                       conv_id              varchar(20)                    not null,	\
                       primary key (conv_id)	\
                       )",
                       
                       @"create table session_last_five (\
                       session_type         INT,\
                       talk_id              varchar(100)                   not null,\
                       guid                 varchar(50),\
                       msg_time             datetime,\
                       primary key (talk_id)\
                       )"
                       ],
                 @2, @[@"alter table im_group add valid varchar(2) ",
                       @"update im_group set valid='1'"],
                 @3, @[@"create table cache_im_resource (\
                       jidbare              varchar(100)                   not null,\
                       jidresource          varchar(100)                   not null,\
                       pres_xmlstr          text,\
                       pres_date            datetime,\
                       primary key (jidbare, jidresource)\
                       )"],
                 @4, @[@"alter table im_message_business add msg_type int ",
                       @"alter table im_message_business add link TEXT ",
                       @"alter table im_message_business add existbutton INT ",
                       @"create table im_message_business_buttons ("
                       "business_guid        varchar(50),"
                       "serial              INT,"
                       "text                 varchar(50),"
                       "code                 varchar(200),"
                       "value                varchar(200),"
                       "link                 TEXT,"
                       "method               varchar(200),"
                       "blank                varchar(50),"
                       "showremark           varchar(200),"
                       "remarklabel          varchar(200)"
                       ")"
                       ],
                 @5, @[@"alter table we_staff add micro_use varchar(10) ",
                       @"alter table im_message_single add msg_xml text ",
                       @"alter table im_message_group add msg_xml text ",
                       @"create table we_microaccount	\
                       (	\
                        id                    varchar(50),	\
                        wm_number             varchar(100),	\
                        wm_name               varchar(100),	\
                        jid                   varchar(100),	\
                        im_state              varchar(10),	\
                        im_resource           varchar(100),	\
                        im_priority           numeric(14, 2),	\
                        wm_type               varchar(10),	\
                        micro_use             varchar(10),	\
                        logo_path             varchar(100),	\
                        logo_path_big         varchar(100),	\
                        logo_path_small       varchar(100),	\
                        introduction          text,	\
                        eno                   varchar(20),	\
                        wm_limit              varchar(10),	\
                        concern_approval      varchar(10),	\
                        wm_level              numeric(14, 2),	\
                        fans_count            numeric(14, 2),	\
                        window_template       text,	\
                        salutatory            text,	\
                        send_status           varchar(10),	\
                        primary key (id)	\
                        )"],
                 @5, @[@"alter table we_circle add staff_num numeric(14) "],
                 @6, @[@"create table im_authority \
                       ( \
                       authoritycode numeric(14), \
                       primary key (authoritycode)\
                       )"],
                 @7, @[@"create table we_reply_attach (	\
                       conv_id              varchar(20)                    not null,	\
                       reply_id             varchar(20)                    not null,	\
                       attach_id            varchar(100)                   not null,	\
                       file_name            varchar(100),	\
                       file_ext             varchar(20),	\
                       up_by_staff          varchar(100),	\
                       up_date              datetime,	\
                       primary key (conv_id,reply_id, attach_id)	\
                       )"],
                 @8, @[@"alter table we_circle add fafa_groupid varchar(20) ",
                       @"alter table we_group add fafa_groupid varchar(20) "],
                 @9, @[@"alter table session_last_five add totop numeric(14) ",
                       @"update session_last_five set totop=0",
                       @"create view view_chatsingle_last_session as \
                       SELECT talkabout_jid_bare,msg_time,msg_text FROM im_message_single group by talkabout_jid_bare having msg_time=max(msg_time)",
                       @"create view view_chatgroup_last_session as \
                       SELECT group_id,speaker_jid_bare,speaker_name,msg_time,msg_text FROM im_message_group group by group_id having msg_time=max(msg_time)",
                       @"create view view_business_message_last_session as \
                       SELECT guid, sender_jid_bare, business_caption, business_content, msg_time, isread, msg_type, link, existbutton FROM im_message_business group by msg_type having msg_time=max(msg_time)",
                       @"create view view_business_message_unread_session as \
                       SELECT msg_type, sum(cast(isread as numeric(14,0))) as unreadcount FROM im_message_business group by msg_type",
                       ],
                 @10, @[@"create table atten_staffs( \
                        jid                   varchar(100) not null,	\
                        login_account                   varchar(100) not null,	\
                        primary key (jid, login_account) \
                        )"],
                 @12, @[@"create table session_last_five_tmp (\
                        session_type         INT,\
                        talk_id              varchar(100)                   not null,\
                        guid                 varchar(50),\
                        msg_time             datetime,\
                        totop numeric(14)\
                        )",
                        @"insert into session_last_five_tmp(session_type,talk_id,guid,msg_time,totop) select session_type,talk_id,guid,msg_time,totop from session_last_five",
                        @"drop table session_last_five",
                        @"create table session_last_five (\
                        session_type         INT not null,\
                        talk_id              varchar(100)                   not null,\
                        guid                 varchar(50),\
                        msg_time             datetime,\
                        totop numeric(14),\
                        talk_id2             varchar(100),\
                        primary key (guid)\
                        )",
                        @"CREATE INDEX idx_session_last_five_tp_id ON session_last_five(session_type,talk_id)",
                        @"insert into session_last_five(session_type,talk_id,guid,msg_time,totop,talk_id2) select session_type,talk_id,guid,msg_time,totop,'' from session_last_five_tmp",
                        @"drop table session_last_five_tmp",
                        ],
                 @13, @[@"alter table we_circle add circle_class_name varchar(200)",
                        @"create table we_circle_class (\
                        classify_id          varchar(20)   not null,\
                        classify_name        varchar(200),\
                        parent_classify_id   varchar(20)\
                        )"
                        ],
                 @14, @[@"alter table we_circle add circle_class_id varchar(20)"],
                 @15, @[@"create table im_grouptype (\
                        typeid      varchar(20)  not null,\
                        typename    varchar(20),\
                        pid         varchar(20),\
                        primary key (typeid)\
                        )"],
                 @16, @[@"alter table we_staff add sex_id varchar(2)"],
                 @17, @[@"create table we_department (\
                        dept_id         varchar(20),\
                        dept_name       varchar(200),\
                        parent_deptid  varchar(20),\
                        fafa_deptid     varchar(20),\
                        primary key (dept_id)\
                        )"],
                 @18, @[@"alter table we_staff add openid varchar(64)"],
                 @19, @[@"alter table we_staff add ldap_uid varchar(64)"],
                 @20, @[@"alter table im_message_single add msg_type varchar(1)"],//新加区分消息类型字段
                ];
    
#if ! __has_feature(objc_arc)
    [_initSql retain];
#endif
}

+(NSArray*)getInitSql
{
    if (_initSql == nil)
    {
        [DBInitSql genInitSql];
    }
    
    return _initSql;
}

@end
