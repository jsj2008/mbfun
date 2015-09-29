//
//  SinaWeiboClient.m
//  Wefafa
//
//  Created by mac on 14-11-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "SinaWeiboClient.h"
#import "WeiboSDK.h"

@implementation SinaWeiboClient

- (void)shareSend:(WBMessageObject *)wbobject
{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kSinaRedirectURI;
    authRequest.scope = @"all";
    
//    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:wbobject authInfo:authRequest access_token:_token];
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:wbobject];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}

- (void)ssoLoginSend
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kSinaRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)ssoLogoutButtonPressed
{
    [WeiboSDK logOutWithToken:_token delegate:self withTag:@"user1"];
}

- (void)payButtonPressed
{
    WBOrderObject *order = [[WBOrderObject alloc] init];
    [order setOrderString:@"type=test"];
    
    WBPaymentRequest *request = [WBPaymentRequest requestWithOrder:order];
    [WeiboSDK sendRequest:request];
}

- (void)requestOpenAPI
{
//    HttpRequestDemoTableViewController* httpRequestDemoVC = [[[HttpRequestDemoTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
//    
//    [self presentViewController:httpRequestDemoVC animated:YES completion:^{
//    }];
    
}

- (void)checkCommentButtonPressed
{
    commentButton.accessToken = _token;
}

- (void)checkRelationShipButtonPressed
{
    relationshipButton.accessToken = _token;
    relationshipButton.currentUserID = _currentUserID;
    [relationshipButton checkCurrentRelationship];
}


#pragma mark -
#pragma WBHttpRequestDelegate

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"收到网络回调", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"请求异常", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}


#pragma mark -
#pragma Internal Method

- (void)messageToShareText:(NSString *)text
{
    WBMessageObject *message = [WBMessageObject message];
    
    message.text = text;
    [self shareSend:message];
}

- (void)messageToShareImage:(UIImage *)previewImage
{
    WBMessageObject *message = [WBMessageObject message];
    
    WBImageObject *image = [WBImageObject object];
    image.imageData = UIImageJPEGRepresentation(previewImage, 0.85);
    message.imageObject = image;
    [self shareSend:message];
}

- (void)messageToShareImagePath:(NSString *)imagePath
{
    WBMessageObject *message = [WBMessageObject message];
    
    WBImageObject *image = [WBImageObject object];
    UIImage *previewImage = [UIImage imageWithContentsOfFile:imagePath];
    image.imageData = UIImageJPEGRepresentation(previewImage, 0.85);
    message.imageObject = image;
    [self shareSend:message];
}

- (void)messageToShare:(NSString *)objectID title:(NSString *)title description:(NSString *)description thumbnailData:(NSData*)thumbnailData url:(NSString*)url
{
    WBMessageObject *message = [WBMessageObject message];
    
//    WBImageObject *img=[WBImageObject object];
//    img.imageData=thumbnailData;
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = objectID;
    webpage.title = title;
    webpage.description = description;
    webpage.thumbnailData = thumbnailData;
    webpage.webpageUrl = url;
    message.text=[[NSString alloc] initWithFormat:@"[%@]来自有范%@",title,description ];
    message.mediaObject = webpage;
//    message.imageObject = img;
    [self shareSend:message];
    
    

}


@end
