//
//  TencentQQClient.m
//  Wefafa
//
//  Created by mac on 14-11-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "TencentQQClient.h"

@implementation TencentQQClient

-(void)setTencentOAuth:(TencentOAuth *)tencentOAuth1
{
    _tencentOAuth=tencentOAuth1;
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"QQ错误" message:@"App未注册！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"QQ错误" message:@"发送参数错误！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"QQ错误" message:@"未安装QQ！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"QQ错误" message:@"API接口不支持！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"QQ错误" message:@"发送失败！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"QQ错误" message:@"空间分享不支持纯文本分享，请使用图文分享！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"QQ错误" message:@"空间分享不支持纯图片分享，请使用图文分享！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}


//- (void)onShareAudio:(QElement *)sender
//{
//    [self.view endEditing:YES];
//    [self.root fetchValueUsingBindingsIntoObject:self];
//    
//    NSData *previewData = nil;
//    
//    NSString *utf8String = self.binding_url;
//    
//    QQApiAudioObject* audioObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
//                                                           title:self.binding_title ? : @""
//                                                     description:self.binding_description ? : @""
//                                                previewImageData:previewData];
//    
//    utf8String = self.binding_previewImageUrl;
//    [audioObj setPreviewImageURL:[NSURL URLWithString: utf8String? : @""]];
//    
//    utf8String = self.binding_streamUrl;
//    [audioObj setFlashURL:[NSURL URLWithString:utf8String ? : @""]];
//    [audioObj setCflag:[self shareControlFlags]];
//    
//    _qqApiObject = audioObj;
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择分享的平台" message:@"请选择你要分享内容的平台" delegate:self cancelButtonTitle:@"QZone" otherButtonTitles:@"QQ", nil];
//    [alertView show];
//}
//
//- (void)onShareVideo:(QElement *)sender
//{
//    [self.view endEditing:YES];
//    [self.root fetchValueUsingBindingsIntoObject:self];
//    
//    NSString *previewPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"video.jpg"];
//    NSData* previewData = [NSData dataWithContentsOfFile:previewPath];
//    if (self.binding_previewImage)
//    {
//        NSData *selectedImgData = UIImageJPEGRepresentation(self.binding_previewImage, 0.85);
//        if (selectedImgData)
//        {
//            previewData = selectedImgData;
//        }
//    }
//    
//    NSString *utf8String = self.binding_url;
//    QQApiVideoObject *videoObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
//                                                           title:self.binding_title ? : @""
//                                                     description:self.binding_description ? : @""
//                                                previewImageData:previewData];
//    
//    utf8String = self.binding_streamUrl;
//    
//    [videoObj setFlashURL:[NSURL URLWithString:utf8String ? : @""]];
//    [videoObj setCflag:[self shareControlFlags]];
//    
//    _qqApiObject = videoObj;
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择分享的平台" message:@"请选择你要分享内容的平台" delegate:self cancelButtonTitle:@"QZone" otherButtonTitles:@"QQ", nil];
//    [alertView show];
//}
//
//- (NSInteger)GetRandomNumber:(NSInteger)start to:(NSInteger)end
//{
//    return (NSInteger)(start + (arc4random() % (end - start + 1)));
//}
//
//- (void)onCreateOrderNum:(QElement *)sender
//{
//    if (self.requestQRStr)
//    {
//        self.requestQRStr.delegate = nil;
//        [self.requestQRStr cancel];
//        self.requestQRStr = nil;
//    }
//    
//    NSNumber *Billno_Tail = [NSNumber numberWithInteger:[self GetRandomNumber:0 to:9999]];
//    NSString *Param = [NSString stringWithFormat:@"attach=test&bank_type=0&bargainor_id=1900000109&callback_url=http://abc&charset=1&desc=test&fee_type=1&notify_url=http://abc&purchaser_id=583873140&sp_billno=19000001094949%@&total_fee=1&ver=2.0", [Billno_Tail stringValue]];
//    NSString *ParamMD5 = [NSString stringWithFormat:@"%@&key=8934e7d15453e97507ef794cf7b0519d", Param];
//    NSString *url = [NSString stringWithFormat:@"https://wap.tenpay.com/cgi-bin/wappayv2.0/wappay_init.cgi?%@&sign=%@", Param, [[ParamMD5 md5Hash] uppercaseString]];
//    NSString *PayIDInfo = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
//    //@"https://wap.tenpay.com/cgi-bin/wappayv2.0/wappay_init.cgi?attach=test&bank_type=0&bargainor_id=1900000109&callback_url=http://abc&charset=1&desc=test&fee_type=1&notify_url=http://abc&purchaser_id=583873140&sp_billno=190000010949497578&total_fee=1&ver=2.0&sign=2CC44AB13B9FD4131240FCC74AD8E988"] encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"%s|PayIDInfo:\n%@", __FUNCTION__, PayIDInfo);
//    
//    NSString *PayID = nil;
//    NSRange start = [PayIDInfo rangeOfString:@"<token_id>"];
//    if (NSNotFound != start.location)
//    {
//        PayID = [PayIDInfo substringFromIndex:start.location + start.length];
//        NSRange end = [PayID rangeOfString:@"</token_id>"];
//        if (NSNotFound != end.location)
//        {
//            PayID = [PayID substringToIndex:end.location];
//        }
//        else
//        {
//            PayID = nil;
//        }
//    }
//    
//    NSLog(@"%s|PayID:\n%@", __FUNCTION__, PayID);
//    // https://graph.qq.com/vendor/open_qr?d=1234567&sign=3bf68cf5669f2a51a65189dc3c13831f&appid=100442986
//    //    APP ID：100442986
//    //    APP KEY：40836535e61977a2da874ba3ad09607c
//    self.tenpayID = PayID;
//    if (PayID)
//    {
//        NSString *appKey = @"40836535e61977a2da874ba3ad09607c";
//        NSString *d = PayID;
//        NSString *sign = [[NSString stringWithFormat:@"d=%@&type=%@%@", [d urlEncoded], [@"4" urlEncoded], appKey] md5Hash];
//        NSString *appId = @"100442986";
//        NSMutableDictionary *reqParams = [NSMutableDictionary dictionaryWithDictionary:@{
//                                                                                         @"type": @"4",
//                                                                                         @"d": d,
//                                                                                         @"sign": sign,
//                                                                                         @"appid": appId}];
//        self.requestQRStr = [TencentRequest getRequestWithParams:reqParams httpMethod:@"POST" delegate:self requestURL:@"https://graph.qq.com/vendor/open_qr"];
//        [self.requestQRStr connect];
//    }
//    else
//    {
//        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"PayID获取失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//        [msgbox show];
//    }
//}
//
//- (void)onQQPay:(QElement *)sender
//{
//    QQApiPayObject *payObj = [QQApiPayObject objectWithOrderNo:self.tenpayID ? : @""];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:payObj];
//    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
//    [self handleSendResult:sent];
//}
//
//- (void)onOpenWPA:(QElement *)sender
//{
//    [self.view endEditing:YES];
//    [self.root fetchValueUsingBindingsIntoObject:self];
//    
//    QQApiWPAObject *wpaObj = [QQApiWPAObject objectWithUin:self.binding_uin];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:wpaObj];
//    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
//    [self handleSendResult:sent];
//}
//
//- (void)getQQUinOnlineStatues:(QElement *)sender
//{
//    [self.view endEditing:YES];
//    [self.root fetchValueUsingBindingsIntoObject:self];
//    
//    NSArray *ARR = [NSArray arrayWithObjects:self.binding_uin, nil];
//    [QQApiInterface getQQUinOnlineStatues:ARR delegate:self];
//}

- (void)addShareNewsUrl:(NSString *)newsUrl title:(NSString *)title description:(NSString *)description previewImageUrl:(NSString *)previewImageUrl
{
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:newsUrl]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    //QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
}

- (void)addShareNewsUrl:(NSString *)newsUrl title:(NSString *)title description:(NSString *)description previewImage:(UIImage *)previewImage
{
//    NSString *utf8String = @"http://www.163.com";
//    NSString *title = @"新闻标题";
//    NSString *description = @"新闻描述";
//    NSString *previewImageUrl = @"http://cdni.wired.co.uk/620x413/k_n/NewsForecast%20copy_620x413.jpg";
    
    
//    UIImage *image = [UIImage imageWithContentsOfFile:previewImagePath];
    NSData *imgData = UIImageJPEGRepresentation(previewImage, 0.85);
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:newsUrl]
                                title:title
                                description:description
                                previewImageData:imgData];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    //QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
}

- (void)addShareNewsUrl:(NSString *)newsUrl title:(NSString *)title description:(NSString *)description previewImagePath:(NSString *)previewImagePath
{
    //    NSString *utf8String = @"http://www.163.com";
    //    NSString *title = @"新闻标题";
    //    NSString *description = @"新闻描述";
    //    NSString *previewImageUrl = @"http://cdni.wired.co.uk/620x413/k_n/NewsForecast%20copy_620x413.jpg";
    
    
    UIImage *image = [UIImage imageWithContentsOfFile:previewImagePath];
    NSData *imgData = UIImageJPEGRepresentation(image, 0.85);
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:newsUrl]
                                title:title
                                description:description
                                previewImageData:imgData];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    //QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
}

- (void)addShareImage:(UIImage *)image title:(NSString *)title description:(NSString *)description
{
    NSData *imgData = UIImageJPEGRepresentation(image, 0.85);
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                               previewImageData:imgData
                                                          title:title
                                                    description:description];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)addShareImagePath:(NSString *)imagePath title:(NSString *)title description:(NSString *)description
{
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    NSData *imgData = UIImageJPEGRepresentation(image, 0.85);
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                               previewImageData:imgData
                                                          title:title
                                                    description:description];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)addShareText:(NSString *)text
{
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:text];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}


@end
