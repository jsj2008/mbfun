//
//  CollocationInfo.h
//  newdesigner
//
//  Created by Miaoz on 14-10-11.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "collocationInfo" : {
 "id" : 3,
 "creatE_DATE" : "\/Date(1414402487770-0000)\/",
 "userId" : "9999",
 "description" : "ios测试测试草稿",
 "templateId" : 0,
 "lasT_MODIFIED_USER" : "Miaozhang",
 "creatE_USER" : "Miaozhang",
 "lasT_MODIFIED_DATE" : "\/Date(1414403214087-0000)\/",
 "pictureUrl" : "http:\/\/10.100.20.22\/sources\/Collocation\/20141027\/1414403210",
 "name" : "DesignfortheMiaotest",
 "thrumbnailUrl" : "http:\/\/10.100.20.22\/sources\/Collocation\/20141027\/1414403210--300x300",
 "status" : 1,
 "approved" : 2
 }
 "collocationInfo" : {
 "userId" : "cbdbe443-865a-43ab-bf00-b7433ca654d5",
 "templateId" : 0,
 "id" : 296,
 "code" : "10000296",
 "creatE_USER" : "MD00000041",
 "creatE_DATE" : "\/Date(1416018117727-0000)\/",
 "description" : "",
 "pictureUrl" : "http:\/\/10.100.20.22\/sources\/Collocation\/20141115\/1416018121.png",
 "name" : "搭配保存",
 "thrumbnailUrl" : "http:\/\/10.100.20.22\/sources\/Collocation\/20141115\/1416018121--300x300.png"
 }
 
 */
@interface CollocationInfo : NSObject
@property(nonatomic,strong)NSString *id;
//@property(nonatomic,strong)NSString *description;
@property(nonatomic,strong)NSString *creatE_DATE;
@property(nonatomic,strong)NSString *templateId;
@property(nonatomic,strong)NSString *approved;
@property(nonatomic,strong)NSString *pictureUrl;
@property(nonatomic,strong)NSString *designerId;
@property(nonatomic,strong)NSString *lasT_MODIFIED_USER;
@property(nonatomic,strong)NSString *lasT_MODIFIED_DATE;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *thrumbnailUrl;
@property(nonatomic,strong)NSString *creatE_USER;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *backWidth;

@property(nonatomic,strong)UIImage *showImage;
@end
