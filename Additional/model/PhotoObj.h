//
//  PhotoObj.h
//  newdesigner
//
//  Created by Miaoz on 14-9-24.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoObj : NSObject
@property(nonatomic,strong)NSString *goodsID;//商品id
@property(nonatomic,strong)NSString *goodsName;//商品名字

@property (nonatomic,strong)NSString     *position;//位置层
@property (nonatomic,strong)NSString * height;
@property (nonatomic,strong)NSString * width;
@property (nonatomic,strong)NSString * pinchGesturescale;//缩放手势scale
@property (nonatomic,strong)NSString * rotation;//旋转手势rotation
@property(nonatomic,strong)NSString * transform;//缩Transform
@property(nonatomic,strong)NSString *center;//中心位置
@property(nonatomic,strong)NSString *imageURL;//图片url标示
@property(nonatomic,strong) NSData *imageData;

@property(strong,nonatomic) NSString *draftid;//外键
@property(strong,nonatomic)NSString *savetag;//保存草稿标示 0 是未保存草稿 1是保存草稿
@end
