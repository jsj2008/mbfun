//
//  RequstInfo.h
//  One
//
//  Created by fafatime on 14-3-24.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@interface RequstInfo : NSObject<ASIHTTPRequestDelegate>
{
    ASIHTTPRequest *scrollViewImgViewRequest;
    ASIHTTPRequest *tabbarImgViewRequest;
    ASIHTTPRequest *detailModel;
}
@property (nonatomic,retain)NSString *dataString;//scrollview数据
@property (nonatomic,retain)NSString *tabbarDataString;
@property (nonatomic,retain)NSString *detailModelDataString;

@property (nonatomic,retain)NSString *scrollViewImgViewURL;//展示图片URL
@property (nonatomic,retain)NSString *tabbarImgViewURL;
+(id)getSignalInstance;
+(BOOL)isNetWork;
-(void)requestScrollViewImgView;
-(void)requesttabbarImgView;
@end
