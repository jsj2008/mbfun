//
//  ShareRelated.m
//  Wefafa
//
//  Created by Miaoz on 14/11/22.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "ShareRelated.h"
#import "CustomActionSheet.h"
#import "ShareCellView.h"

@interface ShareView : UIView{
    __weak id _target;
    UIView *bgView;
}
- (instancetype)initWithTarget:(id)target;
- (void)moveShareBgViewIsShow:(BOOL)isShow;
@end
CGFloat height = (37 + 32)/2 + 75 + 100/2;
@implementation ShareView
- (instancetype)initWithTarget:(id)target
{
    CGRect frame = [UIScreen mainScreen].bounds;
//    frame.origin.y = frame.size.height;
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    _target = target;
    [self setBackgroundColor:[Utils HexColor:0X333333 Alpha:0.6]];
    NSArray *array = [NSArray arrayWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:@"微信",@"title",@"btn_wechat_normal@2x.png",@"image",@"btn_wechat_pressed@3x.png",@"highlight", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"朋友圈",@"title",@"btn_friend_normal@2x.png",@"image",@"btn_friend_pressed@3x.png",@"highlight", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"微博",@"title",@"btn_weibo_normal@2x.png",@"image",@"btn_weibo_pressed@3x.png",@"highlight", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"QQ",@"title",@"btn_QQ_normal@2x.png",@"image",@"btn_QQ_pressed@3x.png",@"highlight", nil],
                      nil];
    [self configShareCellViewWithArray:array];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:_target action:@selector(shareDismiss)];
    [self addGestureRecognizer:tap];
    return self;
}

- (void)configShareCellViewWithArray:(NSArray *)array
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - height, UI_SCREEN_WIDTH, height)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgView];
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 37/2, UI_SCREEN_WIDTH, 75)];
    [bgView addSubview:shareView];
    NSInteger indexBtn = 0;
    CGFloat width = SCREEN_WIDTH / 4.0f;
    /*
    for(NSDictionary *dict in array){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(indexBtn * width + (width - 55)/2, 0, 55, 75)];
        [btn setTag:100 + indexBtn];
        [btn addTarget:_target action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:[dict objectForKey:@"image"]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[dict objectForKey:@"highlight"]] forState:UIControlStateHighlighted];
        if ([dict objectForKey:@"title"]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 55, 30)];
            [label setText:[dict objectForKey:@"title"]];
            [label setFont:[UIFont systemFontOfSize:13.0f]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTextColor:[UIColor blackColor]];
            [btn addSubview:label];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 30, 10)];
        }else{
            [btn setImageEdgeInsets:UIEdgeInsetsMake(20, 10, 20, 10)];
        }
        [shareView addSubview:btn];
        indexBtn ++;
    }
    */
    array = @[ @{@"image" : @"Unico/share_weixin.png"},
               @{@"image" : @"Unico/share_friend.png"},
               @{@"image" : @"Unico/share_sina.png"},
               @{@"image" : @"Unico/share_qqkongjian2.png"}, ];//share_qqkongjian  share_qq.png
    //image QQ好友
    for(NSDictionary *dict in array){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(indexBtn * width + (width - 55)/2, 0, 55, 75)];
        [btn setTag:100 + indexBtn];
        [btn addTarget:_target action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:[dict objectForKey:@"image"]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[dict objectForKey:@"highlight"]] forState:UIControlStateHighlighted];
        [shareView addSubview:btn];
        indexBtn ++;
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = [Utils HexColor:0xc4c4c4 Alpha:1].CGColor;
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:_target action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setFrame:CGRectMake(0, (37 + 32)/2 + 75, SCREEN_WIDTH, 50)];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [bgView addSubview:cancelBtn];
}

- (void)moveShareBgViewIsShow:(BOOL)isShow
{
    CGRect frame = bgView.frame;
    if (isShow) {
        frame.origin.y = self.frame.size.height - height;//130;
        
    }else{
        frame.origin.y = self.frame.size.height;
    }
    bgView.frame = frame;
}

@end

@implementation ShareRelated{
    __weak UIViewController *_target;
    ShareData *currentData;
    CustomActionSheet *actionView;
    
    ShareView *shareView;
}
-(id)init{
    
    self= [super init];
     if (self) {
        _scene = WXSceneTimeline;
     }
   
    return self;
}
+ (ShareRelated *)sharedShareRelated
{
    static ShareRelated *sharedShareRelatedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedShareRelatedInstance = [[self alloc] init];
    });
    return sharedShareRelatedInstance;
}

- (void)shareDismiss
{
    if (shareView) {
        [UIView animateWithDuration:0.2 animations:^{
            [shareView moveShareBgViewIsShow:NO];
        } completion:^(BOOL finished) {
            [shareView removeFromSuperview];
            shareView = nil;
        }];
    }
    _target = nil;
    currentData = nil;
    actionView = nil;
}

- (void)showInTarget:(UIViewController *)target withData:(ShareData *)shareData
{
    _target = target;
    currentData = shareData;
    if (!_target || !currentData) {
        return;
    }
    if ([shareData.descriptionStr length] ==0 || [shareData.descriptionStr isEqual:[NSNull null]]) {
        shareData.descriptionStr = @"全球时尚，有范搭配";
    }
    shareView = [[ShareView alloc] initWithTarget:self];
    [[AppDelegate shareAppdelegate].window addSubview:shareView];
    [UIView animateWithDuration:0.2 animations:^{
        [shareView moveShareBgViewIsShow:YES];
    }];
//    return;
//    actionView = [[CustomActionSheet alloc] initWithTitle:@"" viewHeight:0];
//    [self sheetView_loadActionViewEvent:actionView.view];
//    [actionView showInView:_target.view];
}


- (void)buttonClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
            [self shareDismiss];
            break;
        case 100:
            [self btnWeiXinClicked:btn];
            break;
        case 101:
            [self btnCircleClicked:btn];
            break;
        case 102:
            [self btnSinaClicked:btn];
            break;
        case 103:
            [self btnQQclicked:btn];
            break;
        default:
            break;
    }
//    [self shareDismiss];
}

//微信好友
-(void)btnWeiXinClicked:(id)sender
{
    if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]))
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"安装微信" message:@"您需要安装新版微信后再分享:)" delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles:nil];
        alertView.tag=100;
        [alertView show];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(kShareRelatedDidClickShareButtonWithType:                  )]) {
        [_delegate kShareRelatedDidClickShareButtonWithType:kShareTypeWXFriend];
    }
    ShareRelated *_shareRelated = [ShareRelated sharedShareRelated];
    _shareRelated.scene=WXSceneSession;
    NSString *title=[NSString stringWithFormat:@"%@",currentData.title];
    if ([Utils getSNSString:title].length==0) {
        title=@"有范";
    }
    [_shareRelated sendLinkContent:title description:currentData.descriptionStr image:currentData.image url:currentData.shareUrl];
      [self shareDismiss];
//    [_shareRelated sendLinkContent:@"有范" description:currentData.descriptionStr image:currentData.image url:currentData.shareUrl];
}

//QQ空间
-(void)btnQQclicked:(id)sender
{
    
    if (![TencentOAuth iphoneQQInstalled])
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"安装QQ" message:@"您需要安装QQ后再分享到QQ空间:)" delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
        alertView.tag=101;
        [alertView show];
        return;
    }
    
    sns.shareOrLogin=YES;
    if (_delegate && [_delegate respondsToSelector:@selector(kShareRelatedDidClickShareButtonWithType:                  )]) {
        [_delegate kShareRelatedDidClickShareButtonWithType:kShareTypeQQZone];
    }
    TencentQQClient *tencentClient=[[TencentQQClient alloc] init];
//    NSString *url=[SHOPPING_GUIDE_ITF createShareCollocationUrl:sns.ldap_uid CollocationID:[Utils getSNSInteger:currentData.shopId]];
//    UIImage *imgNew=[Utils reSizeImage:currentData.image toSize:CGSizeMake(57,57)];
    NSString *title=[NSString stringWithFormat:@"%@",currentData.title];
    if ([Utils getSNSString:title].length==0) {
        title=@"有范";
    }
        [tencentClient addShareNewsUrl:currentData.shareUrl title:title description:currentData.descriptionStr previewImage:currentData.image];
      [self shareDismiss];
//    [tencentClient addShareNewsUrl:currentData.shareUrl title:@"有范" description:currentData.descriptionStr previewImage:currentData.image];
}
//新浪
-(void)btnSinaClicked:(id)sender
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(kShareRelatedDidClickShareButtonWithType:                  )]) {
        [_delegate kShareRelatedDidClickShareButtonWithType:kShareTypeSina];
    }
    SinaWeiboClient *weibo=[[SinaWeiboClient alloc] init];
    
//    NSString *url=[SHOPPING_GUIDE_ITF createShareCollocationUrl:sns.ldap_uid CollocationID:[Utils getSNSInteger:currentData.shopId]];
//    UIImage *imgNew=[Utils reSizeImage:currentData.image toSize:CGSizeMake(57,57)];
    NSString *title=[NSString stringWithFormat:@"%@",currentData.title];
    if ([Utils getSNSString:title].length==0) {
        title=@"有范";
    }
    
    [weibo messageToShare:@"" title:title description:currentData.descriptionStr thumbnailData:UIImagePNGRepresentation(currentData.image) url:currentData.shareUrl];
      [self shareDismiss];
//    [weibo messageToShare:@"" title:@"有范" description:currentData.descriptionStr thumbnailData:UIImagePNGRepresentation(currentData.image) url:currentData.shareUrl];
    
}
//微信朋友圈
-(void)btnCircleClicked:(id)sender
{
    if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]))
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"安装微信" message:@"您需要安装新版微信后再分享:)" delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles:nil];
        alertView.tag=100;
        [alertView show];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(kShareRelatedDidClickShareButtonWithType:                  )]) {
        [_delegate kShareRelatedDidClickShareButtonWithType:kShareTypeTimeline];
    }
    ShareRelated *_shareRelated = [ShareRelated sharedShareRelated];
    _shareRelated.scene=WXSceneTimeline;
//    NSString *url=[SHOPPING_GUIDE_ITF createShareCollocationUrl:sns.ldap_uid CollocationID:[Utils getSNSInteger:currentData.shopId]];
//    UIImage *imgNew=[Utils reSizeImage:currentData.image toSize:CGSizeMake(57,57)];
    NSString *title=[NSString stringWithFormat:@"%@",currentData.title];
    if ([Utils getSNSString:title].length==0) {
        title=@"有范";
    }
    [_shareRelated sendLinkContent:title description:currentData.descriptionStr image:currentData.image url:currentData.shareUrl];
      [self shareDismiss];
//    [_shareRelated sendLinkContent:@"有范" description:currentData.descriptionStr image:currentData.image url:currentData.shareUrl];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
//        RespForWeChatViewController* controller = [[RespForWeChatViewController alloc]autorelease];
//        controller.delegate = self;
//        [self.viewController presentModalViewController:controller animated:YES];
    }
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];

    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
}

- (void) sendTextContent
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
    req.bText = YES;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespTextContent
{
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init] ;
    resp.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
    resp.bText = YES;
    
    [WXApi sendResp:resp];
}

- (void) sendImageContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res5thumb.png"]];
    
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5thumb" ofType:@"png"];
    NSLog(@"filepath :%@",filePath);
    ext.imageData = [NSData dataWithContentsOfFile:filePath];
    
    //UIImage* image = [UIImage imageWithContentsOfFile:filePath];
    UIImage* image = [UIImage imageWithData:ext.imageData];
    ext.imageData = UIImagePNGRepresentation(image);
    
    //    UIImage* image = [UIImage imageNamed:@"res5thumb.png"];
    //    ext.imageData = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

#pragma mark--添加分享图片
-(void)sendCollocationImage:(UIImage *)image{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(image);
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void) RespImageContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res5thumb.png"]];
    
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5thumb" ofType:@"png"];
    ext.imageData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

#pragma mark link content
- (void)sendLinkContent:(NSString *)title description:(NSString *)description image:(UIImage *)image url:(NSString *)url
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    BOOL isOk = [WXApi sendReq:req];
    
}

-(void) RespLinkContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"专访张小龙：产品之上的世界观";
    message.description = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
    [message setThumbImage:[UIImage imageNamed:@"res2.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

-(void) sendMusicContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"一无所有";
    message.description = @"崔健";
    [message setThumbImage:[UIImage imageNamed:@"res3.jpg"]];
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = @"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4B880E697A0E68980E69C89222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696334382E74632E71712E636F6D2F586B30305156342F4141414130414141414E5430577532394D7A59344D7A63774D4C6735586A4C517747335A50676F47443864704151526643473444442F4E653765776B617A733D2F31303130333334372E6D34613F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D30222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31342E71716D757369632E71712E636F6D2F33303130333334372E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E4B880E697A0E68980E69C89222C22736F6E675F4944223A3130333334372C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E5B494E581A5222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D313574414141416A41414141477A4C36445039536A457A525467304E7A38774E446E752B6473483833344843756B5041576B6D48316C4A434E626F4D34394E4E7A754450444A647A7A45304F513D3D2F33303130333334372E6D70333F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D3026616D703B73747265616D5F706F733D35227D";
    ext.musicDataUrl = @"http://stream20.qqmusic.qq.com/32464723.mp3";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespMusicContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"一无所有";
    message.description = @"崔健";
    [message setThumbImage:[UIImage imageNamed:@"res3.jpg"]];
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = @"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4B880E697A0E68980E69C89222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696334382E74632E71712E636F6D2F586B30305156342F4141414130414141414E5430577532394D7A59344D7A63774D4C6735586A4C517747335A50676F47443864704151526643473444442F4E653765776B617A733D2F31303130333334372E6D34613F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D30222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31342E71716D757369632E71712E636F6D2F33303130333334372E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E4B880E697A0E68980E69C89222C22736F6E675F4944223A3130333334372C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E5B494E581A5222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D313574414141416A41414141477A4C36445039536A457A525467304E7A38774E446E752B6473483833344843756B5041576B6D48316C4A434E626F4D34394E4E7A754450444A647A7A45304F513D3D2F33303130333334372E6D70333F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D3026616D703B73747265616D5F706F733D35227D";
    ext.musicDataUrl = @"http://stream20.qqmusic.qq.com/32464723.mp3";
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

-(void) sendVideoContent:(NSString *)title
             description:(NSString *)description
                videoUrl:(NSString *)videlUrl
                     url:(NSString *)url
{
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"乔布斯访谈";
    message.description = @"饿着肚皮，傻逼着。";
    [message setThumbImage:[UIImage imageNamed:@"res7.jpg"]];
    
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = @"http://v.youku.com/v_show/id_XNTUxNDY1NDY4.html";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespVideoContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"楚门的世界";
    message.description = @"一样的监牢，不一样的门";
    [message setThumbImage:[UIImage imageNamed:@"res4.jpg"]];
    
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = @"http://video.sina.com.cn/v/b/65203474-2472729284.html";
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

#define BUFFER_SIZE 1024 * 100
- (void) sendAppContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"App消息";
    message.description = @"这种消息只有App自己才能理解，由App指定打开方式！";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>extend info</xml>";
    ext.url = @"http://www.qq.com";
    
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    ext.fileData = data;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespAppContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"App消息";
    message.description = @"这种消息只有App自己才能理解，由App指定打开方式！";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>extend info</xml>";
    ext.url = @"http://weixin.qq.com";
    
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    ext.fileData = data;
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void) sendNonGifContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res5thumb.png"]];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5" ofType:@"jpg"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)RespNonGifContent{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res5thumb.png"]];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5" ofType:@"jpg"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init] ;
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void) sendGifContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res6thumb.png"]];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res6" ofType:@"gif"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath] ;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)RespGifContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res6thumb.png"]];
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res6" ofType:@"gif"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath] ;
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void) RespEmoticonContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res5thumb.png"]];
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5" ofType:@"jpg"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void)sendFileContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"ML.pdf";
    message.description = @"Pro CoreData";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = @"pdf";
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ML" ofType:@"pdf"];
    ext.fileData = [NSData dataWithContentsOfFile:filePath];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)RespFileContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"ML.pdf";
    message.description = @"机器学习与人工智能学习资源导引";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = @"pdf";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ML" ofType:@"pdf"];
    ext.fileData = [NSData dataWithContentsOfFile:filePath];
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

@end

@implementation ShareData

@end