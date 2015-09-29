//
//  LayoutMapping.h
//  newdesigner
//
//  Created by Miaoz on 14-10-11.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "id" : 530,
 "rectRx" : 0,
 "layoutId" : 1,
 "rectSy" : 1,
 "templateId" : 0,
 "xPosition" : "502",
 "width" : 502,
 "pictureUrl" : "http:\/\/222.66.95.239\/MB.WeiXin.Management.External\/PicHandler.ashx?type=ProdCls&id=715&s=1",
 "rectSx" : -1,
 "lasT_MODIFIED_USER" : "joejoe",
 "creatE_DATE" : "\/Date(1413019394540-0000)\/",
 "lasT_MODIFIED_DATE" : "\/Date(1413019442133-0000)\/",
 "maskFilterList" : [
 
 ],
 "height" : 0,
 "creatE_USER" : "joejoe",
 "rectRy" : 0,
 "yPosition" : "797"
 }
 
 {
 "creatE_USER" : "234234",
 "itemType" : 0,
 "rectRx" : 0,
 "rectSy" : 1,
 "productClsId" : 864,
 "index" : 2,
 "creatE_DATE" : "\/Date(1416463983643-0000)\/",
 "lasT_MODIFIED_DATE" : "\/Date(1416463983643-0000)\/",
 "pictureUrl" : "http:\/\/10.100.20.22\/sources\/BoutiqueProd\/ProdColor\/f2f8b9c-a300-48ba-8309-a94414ebf2cb0.jpg",
 "rectSx" : 1,
 "maskFilterList" : [
 
 ],
 "id" : 15,
 "xPosition" : 218,
 "rectRy" : 0,
 "lasT_MODIFIED_USER" : "234234",
 "height" : 0,
 "width" : 50,
 "productName" : "MooMoo女童基本针织裤【冬装新品】",
 "moduleId" : 4,
 "yPosition" : 139
 }

 */
#import "ContentInfo.h"


@interface LayoutMapping : NSObject
@property(nonatomic,strong)NSString * id;
@property(nonatomic,strong)NSString * layoutId;
@property(nonatomic,strong)NSString * collocationId;
@property(nonatomic,strong)NSString * creatE_DATE;
@property(nonatomic,strong)NSString * templateId;
@property(nonatomic,strong)NSString * xPosition;
@property(nonatomic,strong)NSString * width;
@property(nonatomic,strong)NSString * productClsId;
@property(nonatomic,strong)NSString * productName;
@property(nonatomic,strong)NSString * pictureUrl;
@property(nonatomic,strong)NSString * pictureServerUrl;
//@property(nonatomic,strong)NSString * maskFilterList;
//@property(nonatomic,strong)NSString *mattingList;
@property(nonatomic,strong)NSString * lasT_MODIFIED_USER;
@property(nonatomic,strong)NSString * lasT_MODIFIED_DATE;
@property(nonatomic,strong)NSString * height;
@property(nonatomic,strong)NSString * creatE_USER;
@property(nonatomic,strong)NSString * yPosition;
@property(nonatomic,strong)NSString * index;
@property(nonatomic,strong)NSString * rectSx;
@property(nonatomic,strong)NSString * rectRx;
@property(nonatomic,strong)NSString * rectRy;
@property(nonatomic,strong)NSString * rectSy;

@property(nonatomic,strong)NSString * textFont_Id;
@property(nonatomic,strong)NSString * textPoint;
@property(nonatomic,strong)NSString * textScale;
@property(nonatomic,strong)NSString * textContent;
@property(nonatomic,strong)NSString * textColor;

@property(nonatomic,strong)ContentInfo * contentInfo;
//模板时多两个参数
@property(nonatomic,strong)NSString * moduleId;
@property(nonatomic,strong)NSString * itemType;//属性类型 1 占位符 2 图片
@end
