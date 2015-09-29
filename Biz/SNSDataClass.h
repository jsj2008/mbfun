//
//  SNSDataClass.h
//  Wefafa
//
//  Created by fafa  on 13-7-12.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNSDataClass : NSObject

@end

//////////////////////////////////////////////////////////////////
@interface SNSCircle : SNSDataClass<NSCopying, NSMutableCopying>

@property (strong, nonatomic) NSString *circle_id;
@property (strong, nonatomic) NSString *circle_name;
@property (strong, nonatomic) NSString *circle_desc;
@property (strong, nonatomic) NSString *logo_path;
@property (strong, nonatomic) NSString *create_staff;
@property (strong, nonatomic) NSDate *create_date;
@property (strong, nonatomic) NSString *manager;
@property (strong, nonatomic) NSString *join_method;
@property (strong, nonatomic) NSString *enterprise_no;
@property (strong, nonatomic) NSString *network_domain;
@property (strong, nonatomic) NSString *allow_copy;
@property (strong, nonatomic) NSString *logo_path_small;
@property (strong, nonatomic) NSString *logo_path_big;
@property (strong, nonatomic) NSString *circle_class_id;
@property (strong, nonatomic) NSString *circle_class_name;
@property (assign, nonatomic) int staff_num;
@property (strong, nonatomic) NSString *fafa_groupid; //查群成员使用

-(void)setJSONValue:(NSDictionary *)dict;
-(id)copyWithZone:(NSZone *)zone;
-(id)mutableCopyWithZone:(NSZone *)zone;
@end

//////////////////////////////////////////////////////////////////
@interface SNSGroup : SNSDataClass<NSCopying, NSMutableCopying>

@property (strong, nonatomic) NSString *circle_id;
@property (strong, nonatomic) NSString *group_id;
@property (strong, nonatomic) NSString *group_class_id;
@property (strong, nonatomic) NSString *group_class;
@property (strong, nonatomic) NSString *group_name;
@property (strong, nonatomic) NSString *group_desc;
@property (strong, nonatomic) NSString *group_notice;
@property (strong, nonatomic) NSString *group_photo_path;
@property (strong, nonatomic) NSString *join_method;
@property (strong, nonatomic) NSString *create_staff;
@property (strong, nonatomic) NSDate *create_date;
@property (strong, nonatomic) NSString *fafa_groupid; //查群成员使用

-(void)setJSONValue:(NSDictionary *)dict;
-(id)copyWithZone:(NSZone *)zone;
-(id)mutableCopyWithZone:(NSZone *)zone;
@end


//////////////////////////////////////////////////////////////////
@interface SNSGroupType : SNSDataClass

@property (strong, nonatomic) NSString *type_id;
@property (strong, nonatomic) NSString *type_name;
@property (strong, nonatomic) NSString *pid;

-(void)setJSONValue:(NSDictionary *)dict;

@end

//////////////////////////////////////////////////////////////////
@interface SNSStaff : SNSDataClass

@property (strong, nonatomic) NSString *login_account;
@property (strong, nonatomic) NSString *nick_name;
@property (strong, nonatomic) NSString *photo_path;
@property (strong, nonatomic) NSString *photo_path_small;
@property (strong, nonatomic) NSString *photo_path_big;
@property (strong, nonatomic) NSString *eshortname;
@property (strong, nonatomic) NSString *openid;
@property (strong, nonatomic) NSString *ldap_uid;

- (void)setJSONValue:(NSDictionary *)staff_dict;

@end

//////////////////////////////////////////////////////////////////
@interface SNSStaffFull : SNSStaff

@property (strong, nonatomic) NSString *dept_id;
@property (strong, nonatomic) NSString *fafa_deptid;
@property (strong, nonatomic) NSString *dept_name;
@property (strong, nonatomic) NSString *eno;
@property (strong, nonatomic) NSString *ename;
@property (strong, nonatomic) NSString *self_desc;
@property (strong, nonatomic) NSString *duty;
@property (strong, nonatomic) NSDate   *birthday;
@property (strong, nonatomic) NSString *specialty;
@property (strong, nonatomic) NSString *hobby;
@property (strong, nonatomic) NSString *work_phone;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *mobile_is_bind;     //字符串	0未/1已绑定
@property (assign, nonatomic) double total_point;
@property (strong, nonatomic) NSDate *register_date;
@property (strong, nonatomic) NSDate *active_date;
@property (assign, nonatomic) int attenstaff_num;
@property (assign, nonatomic) int fans_num;
@property (assign, nonatomic) int publish_num;
@property (strong, nonatomic) NSString *jid;
@property (strong, nonatomic) NSString *micro_use;
@property (strong, nonatomic) NSString *sex_id;
@property (strong, nonatomic) NSString *user_vip_type;
@property (strong, nonatomic) NSDate *last_login_date;
-(NSDictionary *)getDictionary;

@end

//////////////////////////////////////////////////////////////////
@interface SNSConvCopy : SNSDataClass
@property (strong, nonatomic) NSString *conv_id;
@property (strong, nonatomic) NSString *create_staff;
@property (strong, nonatomic) SNSStaff *create_staff_obj;
@property (strong, nonatomic) NSDate *post_date;
@property (strong, nonatomic) NSString *conv_type_id;
@property (strong, nonatomic) NSString *conv_content;
@property (nonatomic) int copy_num;
@property (nonatomic) int reply_num;
@property (nonatomic) int atten_num;
@property (nonatomic) int like_num;
@property (strong, nonatomic) NSMutableArray *likes;
@property (strong, nonatomic) NSMutableArray *attachs;
@property (strong, nonatomic) NSString * comefrom;
@property (strong, nonatomic) NSString * post_to_group;
@property (strong, nonatomic) NSString * circle_id;
@property (strong, nonatomic) NSString *conv_root_id;
@property (nonatomic) int attachHeight;

- (void)setJSONValue:(NSDictionary *)convcopy_dict;

@end

/////////////////////////////////
@interface SNSTogetherStaff : SNSDataClass

@property (strong, nonatomic) NSString *staff_id;
@property (strong, nonatomic) NSString *staff_name;

- (void)setJSONValue:(NSDictionary *)togetherstaff_dict;

@end

/////////////////////////////////
@interface SNSTogether : SNSDataClass

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *will_date;
@property (strong, nonatomic) NSString *will_dur;
@property (strong, nonatomic) NSString *will_addr;
@property (strong, nonatomic) NSString *together_desc;
@property (strong, nonatomic) NSMutableArray *together_staffs;

- (void)setJSONValue:(NSDictionary *)together_dict;

@end

/////////////////////////////////
@interface SNSVoteOption : SNSDataClass

@property (strong, nonatomic) NSString *option_id;
@property (strong, nonatomic) NSString *option_desc;
@property (nonatomic) int vote_num;

- (void)setJSONValue:(NSDictionary *)voteoption_dict;

@end

/////////////////////////////////

@interface SNSVote : SNSDataClass

@property (strong, nonatomic) NSString *title;
@property (nonatomic) int vote_all_num;
@property (strong, nonatomic) NSString *is_multi;
@property (strong, nonatomic) NSDate *finishdate;
@property (strong, nonatomic) NSMutableArray *vote_options;
@property (strong, nonatomic) NSString *isvoted;
@property (nonatomic) int vote_user_num;
//@property (nonatomic) int voteViewHeight; //临时用，存放计算得到的投票选项视图高度。

- (void)setJSONValue:(NSDictionary *)vote_dict;

@end

/////////////////////////////////
@interface SNSLike : SNSDataClass

@property (strong, nonatomic) NSString *like_staff;
@property (strong, nonatomic) NSString *like_staff_nickname;
@property (strong, nonatomic) NSDate *like_date;

- (void)setJSONValue:(NSDictionary *)like_dict;

@end


/////////////////////////////////
@interface SNSAttach : SNSDataClass

@property (strong, nonatomic) NSString *attach_id;
@property (strong, nonatomic) NSString *file_name;
@property (strong, nonatomic) NSString *file_ext;
@property (strong, nonatomic) NSString *up_by_staff;
@property (strong, nonatomic) NSDate *up_date;
@property (nonatomic) CGSize imageSize;

- (void)setJSONValue:(NSDictionary *)attch_dict;

@end

/////////////////////////////////

@interface SNSReply : SNSDataClass

@property (strong, nonatomic) NSString *comefrom;
@property (strong, nonatomic) NSString *reply_id;
@property (strong, nonatomic) NSString *reply_staff;
@property (strong, nonatomic) SNSStaff *reply_staff_obj;
@property (strong, nonatomic) NSDate *reply_date;
@property (strong, nonatomic) NSString *reply_content;
@property (strong, nonatomic) NSString *reply_to;
@property (strong, nonatomic) NSString *reply_to_nickname;
@property (strong, nonatomic) NSMutableArray *attachs;
@property (strong, nonatomic) NSMutableArray *likes;
@property (nonatomic) int like_num;

- (void)setJSONValue:(NSDictionary *)reply_dict;

@end

//////////////////////////////////////////////////////////////////
@interface SNSConv : SNSConvCopy

@property (strong, nonatomic) NSMutableArray *replys;
@property (strong, nonatomic) NSMutableString *iscollect;
@property (strong, nonatomic) SNSTogether *together;
@property (strong, nonatomic) SNSVote *vote;
@property (strong, nonatomic) SNSConvCopy *conv_copy;
@property (nonatomic,strong) NSDictionary *conv_link_url;
@property (nonatomic) int attachHeight;

@end

//////////////////////////////////////////////////////////////////
@interface SNSMicroAccount : SNSDataClass

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *wm_number;
@property (strong, nonatomic) NSString *wm_name;
@property (strong, nonatomic) NSString *jid;
@property (strong, nonatomic) NSString *im_state;
@property (strong, nonatomic) NSString *im_resource;
@property (strong, nonatomic) NSNumber *im_priority;
@property (strong, nonatomic) NSString *wm_type;
@property (strong, nonatomic) NSString *micro_use;
@property (strong, nonatomic) NSString *logo_path;
@property (strong, nonatomic) NSString *logo_path_big;
@property (strong, nonatomic) NSString *logo_path_small;
@property (strong, nonatomic) NSString *introduction;
@property (strong, nonatomic) NSString *eno;
@property (strong, nonatomic) NSString *wm_limit;
@property (strong, nonatomic) NSString *concern_approval;
@property (strong, nonatomic) NSNumber *wm_level;
@property (strong, nonatomic) NSNumber *fans_count;
@property (strong, nonatomic) NSString *window_template;
@property (strong, nonatomic) NSString *salutatory;
@property (strong, nonatomic) NSString *send_status;

@end

/////////////////////////////////

@interface SNSEnterprise : SNSDataClass

@property (strong, nonatomic) NSString *eno;
@property (strong, nonatomic) NSString *ename;

- (void)setJSONValue:(NSDictionary *)en_dict;

@end
/////////////////////////////////

@interface SNSEnterpriseStaff : SNSDataClass

@property (strong, nonatomic) NSString *login_account;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *fafa_jid;
@property (strong, nonatomic) NSString *photo_path;

- (void)setJSONValue:(NSDictionary *)staff_dict;

@end
/////////////////////////////////

@interface SNSRecommendUser : SNSDataClass

@property (strong, nonatomic) NSString *classify_name;
@property (strong, nonatomic) NSString *classify_parent_name;
@property (strong, nonatomic) NSString *duty;
@property (strong, nonatomic) NSString *ename;
@property (strong, nonatomic) NSString *eno;
@property (strong, nonatomic) NSString *eshortname;
@property (strong, nonatomic) NSString *hobby;
@property (strong, nonatomic) NSString *login_account;
@property (strong, nonatomic) NSString *logo;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *nick_name;
@property (strong, nonatomic) NSString *photo_path;
@property (strong, nonatomic) NSString *photo_path_big;
@property (strong, nonatomic) NSString *photo_path_small;
@property (strong, nonatomic) NSString *sex_id;

- (void)setJSONValue:(NSDictionary *)dict;

@end


/////////////////////////////////
@interface SNSCircleStaff : SNSStaff

@property (strong, nonatomic) NSString *ename;

- (void)setJSONValue:(NSDictionary *)staff_dict;

@end

/////////////////////////////////

@interface SNSRecommendCircle : SNSCircle

//@property (strong, nonatomic) NSString *circle_id;
//@property (strong, nonatomic) NSString *circle_name;
//@property (strong, nonatomic) NSString *circle_desc;
//@property (strong, nonatomic) NSDate *create_date;
//@property (strong, nonatomic) NSString *create_staff;
//@property (strong, nonatomic) NSString *logo_path;
//@property (strong, nonatomic) NSString *logo_path_big;
//@property (strong, nonatomic) NSString *logo_path_small;
//@property (assign, nonatomic) int staff_num;
@property (strong, nonatomic) SNSStaff *create_staff_obj;
//@property (strong, nonatomic) NSMutableArray *members;  //SNSCircleStaff数组

- (void)setJSONValue:(NSDictionary *)dict;

@end


/////////////////////////////////

@interface SNSTagInfo : SNSDataClass

@property (strong, nonatomic) NSDate *create_date;
@property (strong, nonatomic) NSString *tag_desc;
@property (strong, nonatomic) NSString *tag_id;
@property (strong, nonatomic) NSString *tag_name;

- (void)setJSONValue:(NSDictionary *)tag_dict;

@end

/////////////////////////////////

@interface SNSCircleClass : SNSDataClass

@property (strong, nonatomic) NSString *classify_id;
@property (strong, nonatomic) NSString *classify_name;
@property (strong, nonatomic) NSString *parent_classify_id;

- (void)setJSONValue:(NSDictionary *)dict;

@end

/////////////////////////////////

@interface SNSDept : SNSDataClass

@property (strong, nonatomic) NSString *dept_id;
@property (strong, nonatomic) NSString *dept_name;
@property (strong, nonatomic) NSString *parent_deptid;
@property (strong, nonatomic) NSString *fafa_deptid;

- (void)setJSONValue:(NSDictionary *)dict;

@end



