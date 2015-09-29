//
//  TencentQQClient.h
//  Wefafa
//
//  Created by mac on 14-11-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface TencentQQClient : NSObject
{
    TencentOAuth *_tencentOAuth;
}

-(void)setTencentOAuth:(TencentOAuth *)tencentOAuth1;

- (void)addShareNewsUrl:(NSString *)newsUrl title:(NSString *)title description:(NSString *)description previewImageUrl:(NSString *)previewImageUrl;
- (void)addShareNewsUrl:(NSString *)newsUrl title:(NSString *)title description:(NSString *)description previewImage:(UIImage *)previewImage;
- (void)addShareNewsUrl:(NSString *)newsUrl title:(NSString *)title description:(NSString *)description previewImagePath:(NSString *)previewImagePath;
- (void)addShareImage:(UIImage *)image title:(NSString *)title description:(NSString *)description;
- (void)addShareImagePath:(NSString *)imagePath title:(NSString *)title description:(NSString *)description;
- (void)addShareText:(NSString *)text;

@end
