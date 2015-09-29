//
//  DataCache.h
//  StoryCam
//
//  Created by Ryan on 15/4/20.
//  Copyright (c) 2015年 Unico. All rights reserved.
//
//  实现内容上传和数据加载等
//  单例
//  后续的网络操作都在这里进行，统一管理Session等
//  类名可以再调整。
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 *   排序方式
 */
typedef NS_ENUM(NSInteger, SCShortType)
{
    SCShortDefault = 0,
    SCShortAscByPrice,
    SCShortDescByPrice
};

#define SDATACACHE_INSTANCE ([SDataCache sharedInstance])
@interface SDataCache : NSObject{
    SDataVoidFunc _loginFunc;
}

@property (nonatomic,strong) SFloatFunc uploadProgress;
@property (nonatomic,strong) SNetworkFailFunc failedFunc;

+(SDataCache*)sharedInstance;
@property (nonatomic, strong, readonly) NSDictionary *userInfo;
@property (nonatomic,strong) NSData *deviceToken;

//-(NSDictionary*)userInfo;

// 登录后获得用户数据，也可以用来是否已经登陆
/*
 headPortrait = "http://img.mixme.cn/sources/designer/account/HeadPortrait/defmale.png";
 id = "79178bc0-4730-4a95-9d43-13b6b5479455";
 nickName = iyaya;
 phoneNumber = 18616772423;
 token = 6885a61c7849c9e764133ca12a5b1f09;
 */
-(NSDictionary*)userInfo;
//退出登录清除用户信息
- (void)clearUserInfoWhenLogout;


#pragma mark - network

-(void)loadConfig;

-(void)get:(NSString*)m action:(NSString*)a param:(NSDictionary*)data success:(SNetworkSucFunc)suc fail:(SNetworkFailFunc)fail;
-(void)quickGet:(NSString*)urlStr parameters:(NSDictionary*)data success:(SNetworkSucFunc)suc failure:(SNetworkFailFunc)fail;
// new login( with our new service )


-(void)quickPost:(NSString*)urlStr parameters:(NSDictionary*)data success:(SNetworkSucFunc)suc failure:(SNetworkFailFunc)fail;

-(void)loginAccount:(NSString*)account password:(NSString*)pwd json:(NSDictionary*)json;
// 上传视频
-(void)uploadVideo:(NSURL*)url stickerImage:(UIImage*)stickerImage contentInfo:(NSDictionary*)contentInfo withData:(NSArray*)data complete:(SDataStringFunc)complete;
-(void)uploadImage:(UIImage*)image stickerImage:(UIImage*)stickerImage contentInfo:(NSDictionary*)contentInfo withData:(NSArray*)data complete:(SDataStringFunc)complete;


-(void)uploadImageToQiNiuWithImage:(UIImage*)image complete:(SDataStringFunc)complete;
-(void)uploadVideoToQiNiuWithURL:(NSURL*)url  videoSize:(CGSize)videoSize complete:(SDataStringFunc)complete;


//上传个人背景图片
-(void)uploadBackImgView:(UIImage *)image stickerImage:(UIImage*)stickerImage contentUrl:(NSString*)infoUrl withData:(NSArray*)data complete:(SDataStringFunc)complete;
//-(void)uploadBackImgView:(UIImage *)image stickerImage:(UIImage*)stickerImage contentUrl:(NSString*)infoUrl withData:(NSArray*)data complete:(SDataStringFunc)complete;

// 上传单品
-(void)uploadProductImgView:(UIImage *)image stickerImage:(UIImage*)stickerImage contentUrl:(NSString*)infoUrl withData:(NSDictionary*)data complete:(SDataStringFunc)complete;

-(void)uploadProductDetailWithDic:(NSDictionary *)dic complete:(SObjectFunc)complete;

-(void)logout;


#pragma mark - 获取搭配信息
//获取单个搭配详情
- (void)getCollocationInfo:(NSInteger)collocationId complete:(SDataArrayFunc)complete;
//获取首页搭配列表(按time排序)
-(void)getCollocationList:(NSInteger)page complete:(SDataResponseFunc)complete;
//获取首页精选热门列表(按hot_level排序)
-(void)getCollocationListHot:(NSInteger)page complete:(SDataResponseFunc)complete;
//获取首页关注列表(暂时先上传 关注的人idList_json到服务器)
-(void)getCollocationListFollows:(NSInteger)page complete:(SDataResponseFunc)complete;
//获取推荐品牌搭配列表   type 类型： 0单品，1品牌，2设计师，3话题  type 对应的 id
-(void)getCollocationListForBrand:(NSInteger)page bid:(NSString *)bid complete:(SDataArrayFunc)complete;
//获取我的搭配列表(发现列表)
-(void)getMyCollocationList:(NSInteger)page complete:(SDataArrayFunc)complete;
//获取我喜欢的搭配列表(收藏列表)瀑布流
-(void)getMyLikeCollocationList:(NSInteger)page complete:(SDataArrayFunc)complete;

//获取别人喜欢的搭配列表(收藏列表)瀑布流
-(void)getOtherCollocationList:(NSString*)userIdStr page:(NSInteger)page complete:(SDataArrayFunc)complete;
//获取他人喜欢的搭配列表(收藏列表)瀑布流
-(void)getOtherLikeCollocationList:(NSString*)userIdStr page:(NSInteger)page complete:(SDataArrayFunc)complete;

//删除一个搭配    -1 已添加喜欢
-(void)delCollocationInfo:(NSString*)token collocationId:(NSInteger)collocationId complete:(SDataResponseFunc)complete;
//喜欢某个搭配    -1 已添加喜欢
-(void)likeCollocation:(NSString*)collocationId complete:(SDataArrayFunc)complete;
-(void)likeCollocation:(NSString*)collocationId complete:(SDataArrayFunc)complete failure:(FailureResponseError)failure;
//取消喜欢搭配   -1 已取消喜欢
-(void)delLikeCollocation:(NSString *)collocationId complete:(SDataArrayFunc)complete;
-(void)delLikeCollocation:(NSString*)collocationId complete:(SDataArrayFunc)complete failure:(FailureResponseError)failure;
//获取全部品牌列表 //获取全部品牌列表(旧) 调用原有的接口  BrandAction,getAllBrandListForShow
-(void)getAllBrandListForShow:(NSInteger)page complete:(SDataArrayFunc)complete;
//获取推荐品牌列表
-(void)getRecommendBrandList:(NSInteger)page complete:(SDataArrayFunc)complete;
//标签列表
-(void)searchTagDetailList:(NSDictionary *)param complete:(SDataResponseFunc)complete;
//获取品牌详情
-(void)getBrandDetails:(NSString *)brandId complete:(SDataResponseFunc)complete;
//喜欢某个品牌 -1 已添加喜欢
-(void)likeBrand:(NSString*)token brandId:(NSString *)brandId complete:(SDataArrayFunc)complete;
//取消喜欢品牌 -1 已取消喜欢
-(void)delLikeBrand:(NSString*)token brandId:(NSString *)brandId complete:(SDataArrayFunc)complete;
//获取话题列表
-(void)getTopicList:(NSInteger)page complete:(SDataArrayFunc)complete;
//获取所有话题搭配列表
-(void)getCollocationListForTopic:(NSInteger)page topicId:(NSInteger)topicId complete:(SDataArrayFunc)complete;
//获取精选话题搭配列表
-(void)getCollocationListForSelectTopic:(NSInteger)page topicId:(NSInteger)topicId complete:(SDataArrayFunc)complete;
//获取话题详情
-(void)getTopicDetails:(NSInteger)topicId complete:(void (^)(NSDictionary* data))complete;
//获取喜欢此搭配的用户
-(void)getCollocationLikeUserList:(NSInteger)page collocationId:(NSInteger)collocationId complete:(SDataArrayFunc)complete;
//设置图片
-(void)setUserImage:(UIImage *)image complete:(SDataStringFunc)complete;
//设置昵称
-(void)setUserNickName:(NSString*)newName complete:(SDataStringFunc)complete;

//获取发现页的信息
-(void)getFindHomeLayoutInfo:(SDataArrayFunc)complete;

/*
 //获取喜欢某个搭配的所有 造型师
 collocationId 搭配id
 page 当前页
 */
- (void)getCollocationLikeUserListWithCollocationId:(NSString *)collocationId
                                               page:(NSInteger)page
                                           complete:(SDataResponseFunc)complete;
/*
 举报
 collocationId 搭配id
 */
- (void)addMyComplaintsInfoWithCollocationId:(NSString *)collocationId
                                           complete:(SDataResponseFunc)complete;
// 品牌
- (void)getBrandLikeUserListWithBrandId:(NSString *)brandId
                                   page:(NSInteger)page
                               complete:(SDataResponseFunc)complete;

//获得全部设计师
-(void)getAllDesignerList :(NSInteger)page complete:(SDataResponseFunc)complete;
//获得明星设计师
-(void)getStarDesignerList :(NSInteger)page complete:(SDataArrayFunc)complete;

//获取品牌搭配列表
-(void)getCollocationListForBrand:(NSString *)brandId page:(NSInteger)page complete:(SDataArrayFunc)complete;

//搭配页推荐搭配列表
-(void)getCollocationListForDetails:(NSInteger)page complete:(SDataArrayFunc)complete;
//发现页推荐搭配列表
-(void)getCollocationListForMain:(NSInteger)page tabString:(NSString*)tabString complete:(SDataArrayFunc)complete;
//单品页推荐瀑布流搭配列表
-(void)getCollocationListForItem:(NSInteger)tid page:(NSInteger)page complete:(SDataArrayFunc)complete failure:(FailureResponseError)failure;

//单品页推荐搭配列表
-(void)getRelevantCollocationForItem:(NSInteger)tid  complete:(SDataArrayFunc)complete failure:(FailureResponseError)failure;

//最佳搭配列表
-(void)getBestCollocationList:(NSInteger)page tabstr:(NSString *)tabStr complete:(SDataArrayFunc)complete;

//读取最佳搭配广告
-(void)getBestCollocationBanner:(SDataArrayFunc)complete;

//时尚资讯
-(void)getAllFashionList:(NSInteger)page complete:(SDataArrayFunc)complete;
//活动列表
-(void)getActivityList:(NSInteger)page complete:(SDataArrayFunc)complete;

// 获得贴纸和tag列表
-(void)getStickImgWithTabList:(NSString *)topicId complete:(SObjectFunc)complete;

// 获得边框图片列表
-(void)getBorderImageList:(NSString *)topicId borderHeight:(int)borderHeight complete:(SObjectFunc)complete;


//获取品类详情头部的接口
-(void)getClothingCategoryDetailsWithFid:(NSString *)fid complete:(SObjectFunc)complete failure:(FailureResponseError)failure;

//获取品类详情头部的接口
- (void)newGetClothingCategoryDetailsWithFid:(NSString *)fid complete:(SObjectFunc)complete failure:(FailureResponseError)failure;

//获取品类详情下面的单品信息
- (void) getItemListForClsWith:(NSString *)tid shortType:(SCShortType)shortType isNew:(BOOL)isNew  filterDictionary:(NSDictionary *)filterDictionary  page:(int)page numberOfPage:(int)numberOfPage complete:(SObjectFunc)complete failure:(FailureResponseError)failure;

//获取创建搭配时选择话题的列表
- (void) getTagEditTopicListWithPage:(int)page numberOfPage:(int)numberOfPage complete:(SObjectFunc)complete failure:(FailureResponseError)failure;

#pragma mark - chat 
-(void)addMessageInfo:(NSString*)userId msg:(NSString*)msg complete:(SObjectFunc)complete;
-(void)uploadChatImage:(UIImage*)img complete:(SDataStringFunc)suc fail:(SVoidFunc)fail;
-(void)uploadChatVoice:(NSData*)voice complete:(SDataStringFunc)suc fail:(SVoidFunc)fail;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
