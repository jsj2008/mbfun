//
//  ShareRelated.h
//  Wefafa
//
//  Created by Miaoz on 14/11/22.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globle.h"

typedef NS_ENUM(NSInteger, ShareReatedType) {
    kShareTypeTimeline,//微信朋友圈
    kShareTypeWXFriend,//微信好友
    kShareTypeSina,//新浪微博
    kShareTypeQQZone,//qq空间
};

@protocol kShareRelatedShareDelegate <NSObject>
- (void)kShareRelatedDidClickShareButtonWithType:(ShareReatedType)type;
@end
@interface ShareData : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *descriptionStr;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)NSString *shareUrl;
@property(nonatomic,strong)NSString *shopId;//单品或者搭配id
@end

@interface ShareRelated : NSObject
{
}

+ (ShareRelated *)sharedShareRelated;

#pragma mark--添加分享图片
@property (nonatomic,assign) enum WXScene scene;
@property(nonatomic,assign)id<kShareRelatedShareDelegate>delegate;
-(void)sendCollocationImage:(UIImage *)image;
-(void)sendLinkContent:(NSString *)title description:(NSString *)description image:(UIImage *)image url:(NSString *)url;


- (void)showInTarget:(UIViewController *)target withData:(ShareData *)shareData;

- (void)shareDismiss;

@end
