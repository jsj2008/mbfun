//
//  TemplateInfo.h
//  newdesigner
//
//  Created by Miaoz on 14/10/21.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "moduleInfo" : {
 "userId" : "23213",
 "status" : 4,
 "id" : 4,
 "creatE_DATE" : "\/Date(1416463983050-0000)\/",
 "creatE_USER" : "234234",
 "lasT_MODIFIED_DATE" : "\/Date(1416463983050-0000)\/",
 "lasT_MODIFIED_USER" : "234234",
 "description" : "234234",
 "pictureUrl" : "http:\/\/10.100.20.22\/sources\/",
 "name" : "23424",
 "thrumbnailUrl" : ""
  "backWidth" : 600,
 }
*/
//返回的moduleInfo
@interface TemplateInfo : NSObject
@property(nonatomic,strong)NSString *  id;
@property(nonatomic,strong)NSString *  name;
@property(nonatomic,strong)NSString *  pictureUrl;
@property(nonatomic,strong)NSString *  thrumbnailUrl;
@property(nonatomic,strong)NSString *  userId;
@property(nonatomic,strong)NSString *  status;
@property(nonatomic,strong)NSString *  creatE_DATE;
@property(nonatomic,strong)NSString *  creatE_USER;
@property(nonatomic,strong)NSString *  lasT_MODIFIED_DATE;
@property(nonatomic,strong)NSString *  lasT_MODIFIED_USER;
@property(nonatomic,strong)NSString *  backWidth;
@property(nonatomic,strong)NSString *  templateId;
//@property(nonatomic,strong)NSString *  description;

@end
