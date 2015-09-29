//
//  HttpRequest.h
//  InSquare
//
//  Created by ming on 14-6-10.
//  Copyright (c) 2014年 com.cwvs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "MBHttpClient.h"

typedef NS_ENUM(NSInteger, MBLoginType) {
    kMBLoginTypeDefault,
    kMBLoginTypeWeiXin,
    kMBLoginTypeQQ
};

typedef NS_ENUM(NSInteger, MBServerNameType) {
    kMBServerNameTypeCollocation,//搭配  //WXSC_Collocation
    kMBServerNameTypeProduct,//产品    WXSC_Product
    kMBServerNameTypeOrder,//订单      WXSC_Order
    kMBServerNameTypeAccout,//账户     WXSC_Account
    kMBServerNameTypeUpgrade,//升级    VCL_Upgrade
    kMBServerNameTypePromotion, //促销  WXSC_Promotion
    kMBServerNameTypeStatistics, // 统计服务
    kMBServerNameTypeNoWXSCProduct,//没有wxsc的商品服务
    kMBServerNameTypeNoWXSCOrder,
    kMBServerNameTypeCart,  //购物袋
    kMBServerNameTypeUser//user
};

typedef void (^RequestSucessBlock) (id obj);
typedef void (^RequestFailBlock) (NSString* errorMsg);
//214
#define MAIN_SERVICE_URL16 @"http://10.100.20.180:8016"
#define MAIN_SERVICE_URL15 @"http://10.100.20.180:8015"
#define MAIN_SERVICE_URL18 @"http://10.100.20.180:8018"

//
@interface HttpRequest : NSObject
+(void)printObject:(NSDictionary*)dic isReq:(BOOL)isReq;

+ (void)getRequestPath:(MBServerNameType)serverType
                       methodName:(NSString *)method
                           params:(NSDictionary *)param
                          success:(RequestSuccessBlock)success
                           failed:(RequestFailedBlock)failed;


+ (void)postRequestPath:(MBServerNameType)serverType
                        methodName:(NSString *)method
                            params:(NSDictionary *)param
                           success:(RequestSuccessBlock)success
                            failed:(RequestFailedBlock)failed;

//不需要 token的网络请求 获取token im好友列表等
+ (void)requestWithOutTokenWithDomian:(NSString *)domain
                                Path:(NSString *)path
                                param:(NSDictionary *)params
                              success:(RequestSuccessBlock)success
                               failed:(RequestFailedBlock)failed;
/*
@param from 请求来源：1. 注册；2. 找回密码
 */
+ (void)requestInviteCodeWithPhone:(NSString *)phoneNum
                              from:(NSString *)from
                           success:(RequestSuccessBlock)success
                            failed:(RequestFailedBlock)failed;

/*
 *登陆接口
 *根据 logintype 确定登陆类型，
 *默认是kMBLoginTypeDefault，用户名密码登录
 *account，password 可以为空
 */

//+ (void)mbLoginRequestWithType:(MBLoginType)type
//                       account:(NSString *)account
//                      password:(NSString *)password
//                       success:(RequestSuccessBlock)success
//                        failed:(RequestFailedBlock)failed;

/*
 //搭配相关的网络请求
 //servername   WXSC_Collocation
 */

+ (void)collocationGetRequestPath:(NSString *)path
                       methodName:(NSString *)method
                           params:(NSDictionary *)param
                          success:(RequestSuccessBlock)success
                           failed:(RequestFailedBlock)failed;


+ (void)collocationPostRequestPath:(NSString *)path
                        methodName:(NSString *)method
                            params:(NSDictionary *)param
                           success:(RequestSuccessBlock)success
                            failed:(RequestFailedBlock)failed;

/*
 //产品相关的网络请求
 //servername   WXSC_Product
 */

+ (void)productGetRequestPath:(NSString *)path
                   methodName:(NSString *)method
                       params:(NSDictionary *)param
                      success:(RequestSuccessBlock)success
                       failed:(RequestFailedBlock)failed;


+ (void)productPostRequestPath:(NSString *)path
                    methodName:(NSString *)method
                        params:(NSDictionary *)param
                       success:(RequestSuccessBlock)success
                        failed:(RequestFailedBlock)failed;

/*
 //订单相关的网络请求
 //servername   WXSC_Order
 */

+ (void)orderGetRequestPath:(NSString *)path
                 methodName:(NSString *)method
                     params:(NSDictionary *)param
                    success:(RequestSuccessBlock)success
                     failed:(RequestFailedBlock)failed;


+ (void)orderPostRequestPath:(NSString *)path
                  methodName:(NSString *)method
                      params:(NSDictionary *)param
                     success:(RequestSuccessBlock)success
                      failed:(RequestFailedBlock)failed;

+ (void)LogisticsGetRequestPath:(NSString *)path
                     methodName:(NSString *)method
                         params:(NSDictionary *)param
                        success:(RequestSuccessBlock)success
                         failed:(RequestFailedBlock)failed;
/*
 //账户相关的网络请求
 //servername   WXSC_Account
 */

+ (void)accountGetRequestPath:(NSString *)path
                   methodName:(NSString *)method
                       params:(NSDictionary *)param
                      success:(RequestSuccessBlock)success
                       failed:(RequestFailedBlock)failed;


+ (void)accountPostRequestPath:(NSString *)path
                    methodName:(NSString *)method
                        params:(NSDictionary *)param
                       success:(RequestSuccessBlock)success
                        failed:(RequestFailedBlock)failed;

/*
 //升级相关的网络请求
 //servername   VCL_Upgrade
 */

+ (void)upgradeGetRequestPath:(NSString *)path
                   methodName:(NSString *)method
                       params:(NSDictionary *)param
                      success:(RequestSuccessBlock)success
                       failed:(RequestFailedBlock)failed;


+ (void)upgradePostRequestPath:(NSString *)path
                    methodName:(NSString *)method
                        params:(NSDictionary *)param
                       success:(RequestSuccessBlock)success
                        failed:(RequestFailedBlock)failed;



/*
 //promotion的网络请求
 //servername   VCL_Upgrade
 */

+ (void)promotionGetRequestPath:(NSString *)path
                   methodName:(NSString *)method
                       params:(NSDictionary *)param
                      success:(RequestSuccessBlock)success
                       failed:(RequestFailedBlock)failed;


+ (void)promotionPostRequestPath:(NSString *)path
                    methodName:(NSString *)method
                        params:(NSDictionary *)param
                       success:(RequestSuccessBlock)success
                        failed:(RequestFailedBlock)failed;


/********************************************************************************************/

/** 
 *  接口请求对象
 *
 *  @return HttpRequest
 */
+ (HttpRequest *)shareRequst;

/**
 *  判断网络状态
 *
 *  @return NetworkStatus
 */
+ (NetworkStatus)networkStatus;


//add by miao 11.25  图片缓存
@property(nonatomic,strong)NSString *localImageFilePath;

-(void)downloadImageUrl:(NSString *)imageUrl  defaultImageName:(NSString *)defaultImageName WithImageView:(UIImageView *)imageView;

/**
 *  开始请求
 *
 *  @param param       请求参数
 *  @param finishBlock 成功
 *  @param failBlock   失败
 */
+(void)startHTTPRequestWithMethod:(NSString *)method
                            param:(NSDictionary*)param
                          success:(RequestSucessBlock)finishBlock
                             fail:(RequestFailBlock)failBlock;


+(void)startPostRequestWithMethod:(NSString *)method                //接口方法名
                          istoken:(BOOL)istoken                     //是否有token
                          isToast:(BOOL)isToast
                            param:(NSDictionary*)param              //请求参数
                          success:(RequestSucessBlock)finishBlock   //请求成功
                             fail:(RequestFailBlock)failBlock;
#pragma mark ----------------------------
#pragma mark ----------------------------接口---------------------------------------

#pragma mark --用户相关
/**
 *  1.搭配主信息创建
 *
 *  @param postdic 搭配主信息创建参数
 *  @param success    成功
 *  @param fail       失败
 */
//搭配主信息创建
-(void)httpRequestPostCollocationCreateWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;
/**
 *  2.商品类别请求
 *
 *  @param getdic 商品类别查询参数
 *  @param success    成功
 *  @param fail       失败
 */
//
-(void)httpRequestGetProductCategoryFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;
/**
 *  3.根据分类id请求商品
 *
 *  @param Categoryid 商品分类id
 *  @param success    成功
 *  @param fail       失败
 */
//
-(void)httpRequestGetProductCategoryClsFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 4 .请求所有模板
 *
 *  @param getdic
 *  @param success    成功
 *  @param fail       失败
 */
//4
-(void)httpRequestGetWxCollocationTemplateFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 5 .根据id请求点击草稿信息
 *
 *  @param getdic   id
 *  @param success    成功
 *  @param fail       失败
 */
//5.
-(void)httpRequestGetCollocationEditFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 6 .搭配主信息查询（我的界面搭配接口）
 *
 *  @param getdic  搭配精选查询 按照status=2 查询
                    草稿箱按照 status=1 查询
 *  @param success    成功
 *  @param fail       失败
 */
//6.
-(void)httpRequestGetCollocationFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 7 .搭配信息删除接口
 *
 *  @param getdic  主键ID、姓名
 
 *  @param success    成功
 *  @param fail       失败
 */
//7.
-(void)httpRequestPostCollocationDeleteWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 8 .搭配自身主题信息查询接口
 *
 *  @param getdic
 
 *  @param success    成功
 *  @param fail       失败
 */
//8.
-(void)httpRequestGetWxCollocationShowTopicFilter:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 9 .搭配信息保存到草稿箱接口//搭配保存在草稿箱，未发布的时候，不会推送到精选中
 *
 *  @param getdic
 
 *  @param success    成功
 *  @param fail       失败
 */
//9.
-(void)httpRequestPostCollocationDraftCreate:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 10 .搭配风格信息查询接口
 *
 *  @param getdic
 
 *  @param success    成功
 *  @param fail       失败
 */
//10.
-(void)httpRequestGetWxCollocationShowTagFilter:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 11 .搭配系统模板信息查询接口
 *
 *  @param Id	int	主键
            IDS	String	主键批量查询	比如传参数
            IDS=1,2,3
            Name	string	模板名称
            UserId	String	造型师UserId
            UserIds	String	UserId 批量查询	比如传参数
            UserIds=’1’,’2’,’3’
            Status	Int	状态(无效 、草稿、上架、下架)	-1 无效1 草稿 2 上架 3 下架 4 待审核
            CollocationModuleCategoryId Int	搭配模板分类Id
 
 *  @param success    成功
 *  @param fail       失败
 */
//11.
-(void)httpRequestGetCollocationSystemModuleFilter:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 12 .商品颜色查询接口调用
 *
 *  @param getdic  lM_PROD_CLS_ID:商品款id
 
 *  @param success    成功
 *
 */
//12.
-(void)httpRequestGetBaseColorFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 13 .素材上传
 *
 *  @param postdic  UserId:用户ID  PictureData:图片二进制流信息 PictureType:图片类型 CREATE_USER:创建人名称 Description:描述信息
 
 *  @param success    成功
 *
 */
//13.
-(void)httpRequestPostWXPicMaterialCreateWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 14 .查询素材
 *
 *  @param postdic  UserId:用户ID
 
 *  @param success    成功
 *
 */
//14.
-(void)httpRequestGetWXPicMaterialFilterWithdic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 15 .品牌查询
 *
 *  @param getdic
 
 *  @param success    成功
 *
 */
//15.
-(void)httpRequestGetBrandFilterWithdic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 16 .商品搜索
 *
 *  @param getdic Desc:描述 ColorId:基础颜色ID PriceId:价格区间ID CategoryId:商品分类ID BrandId:品牌ID
 
 *  @param success    成功
 *
 */
//16.
-(void)httpRequestGetProductClsSearchFilterWithdic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 17 .价格区间查询接口
 *
 *  @param getdic
 
 *  @param success    成功
 *
 */
//17.
-(void)httpRequestGetBasePriceFilterWithdic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 18 .商品品分类二级分类查询接口 （一二级同事全部获得分类）
 *
 *  @param getdic
 
 *  @param success    成功
 *
 */
//18.
-(void)httpRequestGetProductCategorySubItemFilterWithdic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail;

/**
 * 19 .SOA获取AccessToken
 *
 *  @param getdic AppId=<<AppId>>&Secret=<<Secret>>
 
 *  @param success    成功
 *
 */
//19.SOA获取
-(void)httpRequestGetSOAaccessTokenWithdic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;


/**
 * 20 .(商品)喜欢创建
 *
 *  @param postdic UserId	Int	用户ID	必填
                    SOURCE_ID	Int	搭配或者商品ID	商品ID，搭配ID
                    SOURCE_TYPE	Int	类型（搭配或者商品）	1 商品 2搭配
                    Create_User	String	用户名称
 *  @param success    成功
 *
 */
//20.

-(void)httpRequestPostFavoriteCreateWithdic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;

/**
 * 21 .(商品)喜欢删除及取消喜欢
 *
 *  @param postdic IDS 为 来源id （可多个id,以, 隔开） ，SOURCE_TYPE 为来源类型 1 商品 2 搭配 3 是订单
 第一个是string 型 第二个 整形
 UserId	String	用户id
 *  @param success    成功
 *
 */

//21.
-(void)httpRequestPostFavoriteDeleteWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;

//22.剪切图查询接口
-(void)httpRequestGetWXPicShearFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;

/**
 * 23 .(商品)相似商品id是商品款ID
 *
 *  @param postdic IDS 为 来源id （可多个id,以, 隔开） ，SOURCE_TYPE 为来源类型 1 商品 2 搭配 3 是订单
 第一个是string 型 第二个 整形
 UserId	String	用户id
 *  @param success    成功
 *
 */
-(void)httpRequestGetProductClsFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;

/**
 * 24.左右滑动随机搭配接口
 *
 *  @param
 *  @param success    成功
 *
 */
//
-(void)httpRequestGetWxCollocationRandomFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;
/**
 * 25.获取文字信息的接口
 *
 *  @param
 *  @param success    成功
 *
 */
//
-(void)httpRequestGetTextFontInfoFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;

/**
 *  26.购物车统计查询
 *
 *  @param UserId	string	用户ID	必填
 *  @param success    成功
 *
 */
//
-(void)httpRequestGetShoppingCartStaticFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;




/**
 *  27.查询门店导购信息
 *
 *  @param SHOP_CODE	String	门店编码	选填
            USER_ID     String	用户UserId	必填
 *  @param success    成功
 *
 */
-(void)httpRequestGetSCSIGNRECORDFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;


/**
 * //28.门店基础信息查询
 *
 *  @param ID           INT	门店ID	默认不填显示15条分页
            ORG_CODE	String	门店编码	模糊查询
            ORG_NAME	String	门店名称	模糊查询
 *  @param success    成功
 *
 */

-(void)httpRequestGetOrgBasicInfoFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;

/**
 * //29.记录滑酷信息创建记录滑酷信息
 *
 *  @param USER_ID	String	用户id	 必填
        public List<int> COLLOCATION_ID_LIST	List	搭配id列表	必填
 *  @param success    成功
 *
 */

-(void)httpRequestPostWXSlideCoolInfoCreateWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;

/**
 * //30.通过用户商品信息计算运费
 *
 **  @param USER_ID	String	用户id
 List<ProdInfo> PROD_LIST	List	商品明细列表
 *  @param success    成功
 *
 */
-(void)httpRequestPostPromotionFeeCalcWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;

/**
 * //31.通过用户商品信息计算优惠金额
 *
 *  @param USER_ID	String	用户id
 List<ProdInfo> PROD_LIST	List	商品明细列表
 *  @param success    成功
 *
 */
//31.
-(void)httpRequestPostPromotionDisCalcWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;

/**
 * //32.门店信息取最低优惠价格
 *
 @param shopCode	String	门店id
        List<int> prodIdList	List	商品id
 *
 */
//
-(void)httpRequestPostBatchProductPriceFilterWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;


/**
 * //33.服务万能获取接口get
 *
    @param code ALIPAY_NOTIFY_URL
	@param success    成功
 *
 */
//
//33.
-(void)httpRequestGetBSParamFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;
#pragma mark --
/**
 *34.	系统模板分类查询（供app使用）
 * @param UserId	string	名称	必填，唯一
    @param success    成功
 
 */

-(void)httpRequestGetCollocationModuleCategoryUserFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;

/**
 *35.	系统模板查询单个模板详细信息（根据模板id）
 * @param id	模板id
 @param success    成功
 
 */
#pragma mark -35.
-(void)httpRequestGetCollocationModuleEditFilterWithDic:(NSMutableDictionary *)gettdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;
/**
 *36..(商品)判断是否喜欢
 * @param @"UserId":sns.ldap_uid, @"SOURCE_ID":sourceid, @"SOURCE_TYPE":@"1"
 @param success    成功
 
 */
#pragma mark -- 36
-(void)httpRequestGetJugeFavoriteFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;
/**
 *37..(商品)获取喜欢列表
 * @param @"userId":userId, @"LoginUserId": sns.ldap_uid
 @param success    成功
 
 */
#pragma mark -- 37.(商品)获取喜欢列表
-(void)httpRequestGetFavoriteProductClsFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail;
//-(void)testrequestsuccess:(RequestSucessBlock)success fail:(RequestFailBlock)fail;



+ (void)vouchersGetRequestPath:(NSString *)path
                    methodName:(NSString *)method
                        params:(NSDictionary *)param
                       success:(RequestSuccessBlock)success
                        failed:(RequestFailedBlock)failed;

+ (void)vouchersPostRequestPath:(NSString *)path
                     methodName:(NSString *)method
                         params:(NSDictionary *)param
                        success:(RequestSuccessBlock)success
                         failed:(RequestFailedBlock)failed;
@end
