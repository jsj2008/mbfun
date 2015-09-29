//
//  GoodCategoryObj.h
//  newdesigner
//
//  Created by Miaoz on 14/10/22.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "url" : "http:\/\/img8.ibanggo.com\/sources\/images\/goods\/MB\/223279\/223279_01--w_76_h_76.jpg",
 "tiP_FLAG" : "0",
 "id" : 1,
 "code" : "cloth",
 "flaT_URL" : "www.qq.com",
 "name" : "衣服",
 "parent_Id" : 0
 }
 */
/*
 {
 "url" : "http:\/\/img5.ibanggo.com\/sources\/images\/goods\/MB\/223279\/223279_01--w_76_h_76.jpg",
 "tiP_FLAG" : "0",
 "id" : 26,
 "code" : "服装",
 "subItem" : [
 {
 "url" : "http:\/\/10.100.20.22\/sources\/Boutique\/LmProductCategory\/3e11a316-42b8-43bc-bbcd-55cfbbe003592.bmp",
 "tiP_FLAG" : "0",
 "id" : 28,
 "code" : "man",
 "flaT_URL" : "http:\/\/10.100.20.22\/sources\/Boutique\/LmProductCategory\/c5c417a0-044d-4d48-8a22-0954fb73995a1.png",
 "name" : "男装",
 "parent_Id" : 26
 }
 
 */

@interface GoodCategoryObj : NSObject
@property(nonatomic,strong)NSString * id;
@property(nonatomic,strong)NSString * parent_Id;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * code;
@property(nonatomic,strong)NSString * flaT_URL;
@property(nonatomic,strong)NSString * tiP_FLAG;
@property(nonatomic,strong)NSString * url;
@end
