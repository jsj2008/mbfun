//
//  ClsPicUrl.h
//  newdesigner
//
//  Created by Miaoz on 14-9-30.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
{
    "srC_ID" : 875,
    "custoM_FILE_PATH" : "http:\/\/222.66.95.239\/MB.WeiXin.Management.External\/PicHandler.ashx?type=ProdCls&id=875&s=2",
    "height" : 0,
    "id" : 67343,
    "width" : 0,
    "smalL_FILE_PATH" : "http:\/\/222.66.95.239\/MB.WeiXin.Management.External\/PicHandler.ashx?type=ProdCls&id=875&s=1",
    "srC_TYPE" : "ProdCls",
    "filE_PATH" : "http:\/\/10.100.20.22\/sources\/BoutiqueProd\/ProdCls\/33a9a66-08e4-44f7-a6d6-909e7cb5e7fd0.jpg",
    "isMainImage" : 1
}
*/


@interface ClsPicUrl : NSObject
@property(nonatomic,strong)NSString *srC_ID;
@property(nonatomic,strong)NSString *custoM_FILE_PATH;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *height;
@property(nonatomic,strong)NSString *width;
@property(nonatomic,strong)NSString *smalL_FILE_PATH;
@property(nonatomic,strong)NSString *srC_TYPE;
@property(nonatomic,strong)NSString *filE_PATH;
@property(nonatomic,strong)NSString *isMainImage;
@end
