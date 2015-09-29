//
//  FontInfo.h
//  Wefafa
//
//  Created by Miaoz on 15/1/19.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "remark" : "仿宋",
 "fontId" : 1001,
 "order" : 1001,
 "imagePath" : "http:\/\/img.51mb.com:5659\/sources\/sys\/fonts\/picture\/simfang.png",
 "name" : "simfang",
 "charset" : "GBK"
 }
 */
 
 
 
 
@interface FontInfo : NSObject
@property(nonatomic,strong)NSString * fontId;
@property(nonatomic,strong)NSString * order;
@property(nonatomic,strong)NSString * remark;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * imagePath;
@property(nonatomic,strong)NSString * charset;


@property(nonatomic,strong)UIImage *showImage;
@end
