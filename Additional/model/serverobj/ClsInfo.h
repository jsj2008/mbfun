//
//  ClsInfo.h
//  newdesigner
//
//  Created by Miaoz on 14-9-30.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
"clsInfo" : {
 "accounT_ORIGINAL_CODE" = "gh_d6e75bc5e759";
 brand = "Metersbonwe\U54c1\U724c";
 category = "\U7537\U88c5";
 code = 111555;
 description = "\U521b\U610f\U5f39\U529b\U97f3\U4e50\U5185\U88e4";
 id = 660;
 name = "\U54c8\U54c8";
 price = 49;
 "proD_TAG" = "108|\U54c6\U5566a\U68a6";
 "salE_ATTRIBUTE" = "\U96f6\U552e";
 "scenE_FLAG" = 1;
 status = 1;
 "uP_COUNT" = 0;

}
 */
/*"clsInfo" : {
 "id" : 874,
 "code" : "593282",
 "sale_price" : 349,
 "uP_COUNT" : 0,
 "price" : 399,
 "brand" : "ME&CITY KIDS",
 "description" : "此款男童棉背心可双面穿着，让他拥有双份抢眼！在立体裁剪基础上的设计显得非常精致到位，融入时下潮流拼接撞色元素结合精湛的制作工艺，轻盈的版型刻画出满满的温暖感，把这个季节的些许寒意驱散得无影无踪，搭配酷范十足的连帽设计，小小男子汉的气质被无形中突出渲染，并像小孩子们丰富的想象力般充满了俏皮和活泼的气质，展现了天真和单纯的气息，让他们轻松自在度过整个季节。",
 "name" : "MCK男童撞色轻薄双面穿羽绒背心【冬装新品】",
 "stockCount" : 19
 }
 "clsInfo" : {
 "id" : 933,
 "sale_price" : 20,
 "proD_FLAG" : "1",
 "salE_ATTRIBUTE" : "零售",
 "description" : "在越来越推崇个性的今天，潮流不再仅仅作为一种趋势而存在，而是一种自我的畅快表达和自由舒适的生活方式。作为大时代的新青年，要勇于表现自己，别再压抑自己的个性和情感需求，由内而外，表达自我吧！有爱就要说出来！这款音乐内裤是美邦和网易云音乐合作推出的新产品，只要用手机扫描内裤上的二维码，就能进入网易云音乐，畅享最新最潮最热的音乐！潮流就要由内而外，酣畅淋漓！",
 "remark" : "CMS批量导入",
 "stockCount" : 20,
 "price" : 49,
 "name" : "女网易（恋爱ING）低腰平角裤",
 "code" : "289115",
 "status" : "1",
 "uP_COUNT" : 0
 }
 
 */

@interface ClsInfo : NSObject
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *remark;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *sale_price;
//@property(nonatomic,strong)NSString *description;
@property(nonatomic,strong)NSString *uP_COUNT;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *brand;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *stockCount;
@property(nonatomic,strong)NSString *proD_FLAG;//判断1商品 2素材

@end
