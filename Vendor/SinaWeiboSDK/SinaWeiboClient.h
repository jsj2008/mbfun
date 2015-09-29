//
//  SinaWeiboClient.h
//  Wefafa
//
//  Created by mac on 14-11-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

//sina
#define kSinaAppKey         @"2045436852"
#define kSinaRedirectURI    @"http://www.sina.com"

@interface SinaWeiboClient : NSObject<WBHttpRequestDelegate>
{
    WBSDKRelationshipButton *relationshipButton;
    WBSDKCommentButton *commentButton;
}
@property (nonatomic,strong) NSString * token;
@property (nonatomic,strong) NSString * currentUserID;

- (void)messageToShareText:(NSString *)text;
- (void)messageToShareImage:(UIImage *)previewImage;
- (void)messageToShareImagePath:(NSString *)imagePath;
- (void)messageToShare:(NSString *)objectID title:(NSString *)title description:(NSString *)description thumbnailData:(NSData*)thumbnailData url:(NSString*)url;

@end
