//
//  MaterialMapping.h
//  newdesigner
//
//  Created by Miaoz on 14/10/24.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
//素材实例类  生成文字字体实例类
/*{
 "id" : 94,
 "width" : 0,
 "pictureUrl" : "http:\/\/10.100.20.22\/sources\/WXPicMaterial\/201411161438341416119914.png",
 "height" : 0
 }*/
@class LayoutMapping;
@interface MaterialMapping : NSObject
@property(nonatomic,strong)NSString * id;
@property(nonatomic,strong)NSString * pictureUrl;
@property(nonatomic,strong)NSString * width;
@property(nonatomic,strong)NSString * height;


@property(nonatomic,strong)LayoutMapping *layoutMapping;//生成文字需要
@property(nonatomic,strong)UIImage *showImage;
@property(nonatomic,strong)NSString *sourceType;//标示2是素材 1是商品 3是文字
@property(nonatomic,strong)NSString *shearPicUrl;//裁剪过后url
@end
