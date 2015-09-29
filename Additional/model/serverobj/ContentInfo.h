//
//  ContentInfo.h
//  Wefafa
//
//  Created by Miaoz on 15/4/8.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrossInfo.h"
/*
 "contentList" : [
 {
 "id" : 72423,
 "rectRx" : 0,
 "index" : 1,
 "itemType" : 2,
 "rectSy" : 1,
 "xPosition" : 218,
 "productName" : "男拼色斜挎包",
 "pictureUrl" : "http:\/\/img.51mb.com:5659\/sources\/$blank_{\"w\":209,\"h\":209,\"b\":1,\"bc\":\"FF0000\"}--182x182.png",
 "width" : 182,
 "rectSx" : 1,
 "collocationId" : 74262,
 "height" : 182,
 "rectRy" : 0,
 "yPosition" : 160,
 "productClsId" : 9560
 "crossInfo" : {
 "y" : 100,
 "p" : "$blank_{"w":200,"h":200}.png",
 "w" : 200,
 "x" : 82,
 "iw" : 162
 }

 }
 ]
 */
@interface ContentInfo : NSObject
@property(nonatomic,strong)NSString *  id;
@property(nonatomic,strong)NSString *  rectRx;
@property(nonatomic,strong)NSString *  index;
@property(nonatomic,strong)NSString *  itemType;
@property(nonatomic,strong)NSString *  rectSy;
@property(nonatomic,strong)NSString *  xPosition;
@property(nonatomic,strong)NSString *  productName;
@property(nonatomic,strong)NSString *  pictureUrl;
@property(nonatomic,strong)NSString *  width;
@property(nonatomic,strong)NSString *  rectSx;
@property(nonatomic,strong)NSString *  collocationId;
@property(nonatomic,strong)NSString *  height;
@property(nonatomic,strong)NSString *  rectRy;
@property(nonatomic,strong)NSString *  yPosition;
@property(nonatomic,strong)NSString *  productClsId;
@property(nonatomic,strong)CrossInfo * crossInfo;

@end
