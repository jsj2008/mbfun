//
//  SUtilityTool.h
//  Wefafa
//
//  Created by unico on 15/5/16.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+AFNetworking.h"
#import "CoverStickerView.h"

@class SLeftMainViewModel;

#import "Utils.h"
#define SUTILITY_TOOL_INSTANCE ((SUtilityTool*)[SUtilityTool shared])
// 更短一点
#define SUTIL SUTILITY_TOOL_INSTANCE
#define  FONT_SIZE(A) ([UIFont systemFontOfSize:(A)])
#define  FONT_Bold_SIZE(A) ([UIFont boldSystemFontOfSize:(A)])
#define  AUTO_SIZE(A) ([[UIScreen mainScreen] bounds].size.width/375*A)
#define STATUS_BAR_HEIGHT_U ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define NAVIGATION_STATUSBAR (self.navigationController.navigationBar.height +STATUS_BAR_HEIGHT_U)
//图片规格转换
#define REVERT_FROM_3X_TO_2X(par) par*2/3

//及时消息通知
//#define kMessageNavigation @"MBFUN_CHAT_MESSAGE_SOCKET"

//数据转换
#define OTHER_TO_STRING(pattern,value) ([NSString stringWithFormat:(pattern),(value) ])

//按钮tag的基数
#define BASE_BTN_TAG 10000

//颜色
#define COLOR_WHITE ([UIColor whiteColor])
#define COLOR_BLACK ([UIColor blackColor])
#define COLOR_GREY (UIColorFromRGB(0xc4c4c4))
#define COLOR_LINE (UIColorFromRGB(0xd9d9d9))
#define COLOR_NORMAL (UIColorFromRGB(0xf2f2f2))


#define COLOR_C1 (UIColorFromRGB(0xfedc32))
#define COLOR_C2 (UIColorFromRGB(0x3b3b3b))
#define COLOR_C3 (UIColorFromRGB(0xffffff))
#define COLOR_C4 (UIColorFromRGB(0xf2f2f2))
#define COLOR_C5 (UIColorFromRGB(0x666666))
#define COLOR_C6 (UIColorFromRGB(0x999999))
#define COLOR_C7 (UIColorFromRGB(0xbbbbbb))
#define COLOR_C8 (UIColorFromRGB(0xc4c4c4))
#define COLOR_C9 (UIColorFromRGB(0xd9d9d9))
#define COLOR_C10 (UIColorFromRGB(0xfd5b5e))
#define COLOR_C11 (UIColorFromRGB(0xe2e2e2))
#define COLOR_C12 (UIColorFromRGB(0xfd5b4e))
#define COLOR_C13 (UIColorFromRGB(0x4ab9e2))
#define COLOR_C14 (UIColorFromRGB(0x9dcb47))
#define COLOR_C15 (UIColorFromRGB(0xffc13c))

#define FONT_T1 FONT_Bold_SIZE(18)
#define FONT_T2 FONT_Bold_SIZE(17)
#define FONT_T3 FONT_Bold_SIZE(15)
#define FONT_T4 FONT_Bold_SIZE(14)
#define FONT_T5 FONT_Bold_SIZE(13)
#define FONT_T6 FONT_Bold_SIZE(12)
#define FONT_T7 FONT_Bold_SIZE(10)
#define FONT_T8 FONT_Bold_SIZE(9)

#define FONT_t1 FONT_SIZE(18)
#define FONT_t2 FONT_SIZE(17)
#define FONT_t3 FONT_SIZE(15)
#define FONT_t4 FONT_SIZE(14)
#define FONT_t5 FONT_SIZE(13)
#define FONT_t6 FONT_SIZE(12)
#define FONT_t7 FONT_SIZE(10)
#define FONT_t8 FONT_SIZE(9)

//无数据图片
#define NONE_DATA_ITEM @"Unico/ico_noitem"//衣服外形 116*100
#define NONE_DATA_MAN @"Unico/btn_man"//人的头像外形
#define NONE_DATA_CAR @"Unico/btn_car"//小车子外形
#define NONE_DATA_COLLOCATION @"Unico/btn_collocation"//衣架外形134*100
#define NONE_DATA_DRAFT @"Unico/btn_draft"//草稿纸笔外型
#define NONE_DATA_MESSAGE @"Unico/btn_message"//消息外形
#define NONE_DATA_NOTICE @"Unico/btn_notice"//提醒喇叭外形
#define NONE_DATA_ORDER @"Unico/ico_noorder"//卷子外形 78*100
#define NONE_DATA_REWARD @"Unico/btn_reward"//钻石外形
#define NONE_DATA_SHOPPING_BAG @"Unico/ico_nobag"//包包外形 104*104
#define NONE_DATA_STORE @"Unico/btn_store"//房子外形
#define NONE_DATA_ADDRESS @"Unico/ico_noaddress"
#define NONE_DATA_COMMENT @"Unico/ico_nocomment"//评论图片
//默认头像
#define DEFAULT_HEADIMG @"http://img.mixme.cn/sources/designer/account/HeadPortrait/defmale.png"

#define IS_ARRAY(ary) (ary == nil || [ary isKindOfClass:[NSArray class]]  || ary.count == 0 || [ary isKindOfClass:[NSArray class]]) ? NO : YES

#define IS_STRING(str) (str == nil || ![str isKindOfClass:[NSString class]] || str.length == 0 || ![str isKindOfClass:[NSString class]] || [str isEqualToString:@""]) ? NO : YES
#define AUTO(a) UI_SCREEN_WIDTH*a/375

typedef enum : NSUInteger {
    shadowShowBottem = 0,
    shadowShowTop,
    shadowShowLeft,
    shadowShowRight
} ShowShadowDirection;

@class LNGood;
@interface SUtilityTool : NSObject
+(id)shared;
//label得到一行长度
-(CGSize) getStrLenByFontStyle:(NSString*) str fontStyle:(UIFont*) fontStyle;
//根据label指定长度，得到高度
-(CGSize) getStrLenByFontStyle:(NSString*) str fontStyle:(UIFont*) fontStyle textWidth:(float) textWidth;
//带箭头的线
-(UIImage*)getArrowLine;
//带箭头的线
-(UIView*)getArrowLineUIView;
//普通线
-(UIImage*)getNormalLine;
//虚线
-(UIImage*)getDottedLine;
//根据大小返回线，不用图片
-(UIView*)getNormalLineBySize:(float)width height:(float)height color:(UIColor*)color;
//根据rect返回线
-(UIView*)getNormalLineByRect:(CGRect)rect color:(UIColor*)color;
//添加标签
-(UIImageView*)addTag:(NSString*) str fontStyle:(UIFont*)fontStyle boardingView:(UIView*)boardingView point:(CGPoint)point;
//添加标签,限制字符长度 八个字符，多余的省略号
- (UIImageView *)addTagWithDict:(NSDictionary *)dict inView:(UIImageView *)imageView limited:(BOOL)isLimited;
//-(UIImageView*)addTag:(NSString*) str
//            fontStyle:(UIFont*)fontStyle
//            imageView:(UIImageView*)imageView
//                point:(CGPoint)point
//            isLimited:(BOOL)isLimited;

- (UIView *)addTagWithDict:(NSDictionary *)dict inView:(UIImageView *)imageView;

//创建UI组件 函数
// 创建UILabel 根据字符串长度 自定义 label长度
-(UILabel*) createUILabelByStyle:(NSString*)str fontStyle:(UIFont*)fontStyle color:(UIColor*)fontColor rect:(CGRect)rect isFitWidth:(BOOL) isFit isAlignLeft:(BOOL) isLeft;
// 创建UILabel 根据字符串长度 自定义 高度
-(UILabel*) createUILabelByStyleFitHeight:(NSString*)str fontStyle:(UIFont*)fontStyle color:(UIColor*)fontColor width:(float)width point:(CGPoint)point;
// 创建UILabel 文字居中
-(UILabel*) createUILabelMiddleText:(NSString*)str fontStyle:(UIFont*)fontStyle color:(UIColor*)fontColor bgColor:(UIColor*)bgColor rect:(CGRect)rect ;

// 创建UILabel 中间有根线
-(UILabel*) createUILabelMiddleLine:(NSString*)str fontStyle:(UIFont*)fontStyle color:(UIColor*)fontColor rect:(CGRect)rect isFitWidth:(BOOL) isFit  isAlignLeft:(BOOL)isLeft;
//生成View阴影
+ (void)createViewShadow:(UIView*)view direction:(ShowShadowDirection)diretion;

// 创建UIImageView
-(UIImageView*) createUIImageViewByStyle:(NSString*)imageName  rect:(CGRect)rect;
//创建图像 带事件
-(UIImageView*) createUIImageViewByStyleAction:(NSString*)imageName  rect:(CGRect)rect target:(id)target action:(SEL)action;

// 创建UIImageView 通过url
-(UIImageView*) createUIImageViewByUrl:(NSString*)url  rect:(CGRect)rect;

// 创建带圆度的UIImageView
-(UIImageView*) createRoundUIImageView:(NSString*)imageName  rect:(CGRect)rect cornerRadius:(float) value;

// 创建带圆度的UIImageView 通过url
-(UIImageView*) createRoundUIImageViewByUrl:(NSString*)url  rect:(CGRect)rect cornerRadius:(float) value;

//生成一个uiimageview 上面图片 下面label
-(UIImageView*)generateImageAndLabel:(NSString*)str color:(UIColor*) fontColor fontStyle:(UIFont*)fontStyle interval:(float) interval imageName:(NSString*) nameStr placeHolderImgStr:(NSString*)placeHolderImgStr imageSize:(CGSize)size;

// 创建uiview 宽度为屏幕宽度 高度自定义
-(UIView*) createUIViewByHeight:(CGFloat)height coordY:(CGFloat)coordY;

-(UIView*) createUIViewByHeightAndWidth:(CGFloat)height width:(CGFloat)width coordY:(CGFloat)coordY;

//创建一个uiview 可以设置边框和边框颜色
-(UIView*) createUIViewWithBorder:(UIColor*)borderColor borderWidth:(CGFloat)width rect:(CGRect)rect;

//生成label 中间文字 两边虚线
-(UIView*)createUILabelDottedLine:(NSString*)str height:(float)height color:(UIColor*) fontColor fontStyle:(UIFont*)fontStyle interval:(float) interval;

//生成label 中间文字 两边实线
-(UIView*)createUILabeLine:(NSString*)str color:(UIColor*) fontColor fontStyle:(UIFont*)fontStyle interval:(float) interval;

//生成一个uiview 上面图片 下面label
-(UIView*)createImageAndLabel:(NSString*)str color:(UIColor*) fontColor fontStyle:(UIFont*)fontStyle interval:(float) interval imageName:(NSString*) nameStr imageSize:(CGSize)size;

//生成一个无数据界面的view
-(UIView*)createLayOutNoDataViewRect:(CGRect)rect WithImage:(NSString*)image andImgSize:(CGSize)imgSize andTipString:(NSString *)tipString font:(UIFont*)font textColor:(UIColor*)textColor andInterval:(CGFloat)interval;

//创建一个scrollview
-(UIScrollView*)createScrollView:(id)delegate rect:(CGRect)rect;

//创建按钮 中间字体 背景颜色
-(UIButton*)createTitleButton:(NSString*) str bgColor:(UIColor*)bgColor fontColor:(UIColor*)fontColor fontStyle:(UIFont*)fontStyle rect:(CGRect)rect;
//创建按钮 带事件
-(UIButton*)createTitleButtonAction:(NSString*) str bgColor:(UIColor*)bgColor fontColor:(UIColor*)fontColor fontStyle:(UIFont*)fontStyle rect:(CGRect)rect target:(id)target action:(SEL)selector ;

//创建按钮 选中与非选中状态
-(UIButton*)createSelectButtonImage:(UIImage*)selectImg andDeSelectImg:(UIImage*)deselectImg rect:(CGRect)rect target:(id)target action:(SEL)selector ;
//创建uiview 上面线，下边带箭头线 中间文件中描述
-(UIView*)createUIViewByArrowLine:(NSString*)str height:(float)height bgColor:(UIColor*)bgColor fontColor:(UIColor*)fontColor fontStyle:(UIFont*)fontStyle;

//创建一个带着图片的button
-(UIButton*)createButtonByImage:(NSString*)imgStr target:(id)target action:(SEL)action rect:(CGRect)rect;
//创建一个like背景的图标，带数字
-(UIImageView*)createImageViewByLike:(NSInteger) likeNum;



//加载图片
-(void)setImageViewByUrl:(NSString*)url size:(CGSize)size imageView:(UIImageView*)imageView;
//给view添加事件
-(void) addViewAction:(UIView*)view target:(id)target action:(SEL)action;


//根据datetime获取与当前时间的差值
-(NSString*) getTimeByToday:(NSDate*)time;
//日期转换为字符串
- (NSDate *)dateFromString:(NSString *)dateString;
//字符串转换为日期
-(NSString*) getTimeByTodayWithString:(NSString*)dateString;
//UIButton WITH TWO LINE
- (UIButton*)buttonDoubleLine:(NSString*)topText font:(UIFont*)topFont subLine:(NSString*)subText font:(UIFont*)subFont color:(UIColor*)textColor;

//图片url拼接 缩略版
+ (NSString*)utilltyImageUrlFactory:(NSString*)imageUrl imageWidth:(CGFloat)width;

// 从UIColor中创建一个UIImage
- (UIImage *)imageFromColor:(UIColor *)color;

//手机号码验证
- (BOOL)validateMobile:(NSString *)mobile;


// 从string获得时间
+(NSString *)getdate:(NSString *)datestr;

#pragma mark - jump other VC
-(void)jumpControllerWithContent:(NSDictionary*)dict target:(id)target;

- (void)jumpControllerWithType:(NSInteger)type target:(id)target;

#pragma mark - Share Helper
- (NSString*)getWatermarkImageURLWithGood:(LNGood *)info;
- (NSString*)getWatermarkImageURL:(NSDictionary*)info;
- (NSString*)getCollocationURL:(NSDictionary*)data;

#pragma mark - UI Helper
- (void)showHome;


- (void)showCamera:(NSDictionary*)tag;

- (void)showUser:(NSString*)uid;

- (void)showCollection:(NSString*)cid;

- (void)showBrand:(NSString*)bid;

- (void)showTopic:(NSString*)tid;

- (void)showItem:(NSString*)iid;

- (void)showSpecial:(NSString*)sid;

- (void)showWebpage:(NSString*)url titleName:(NSString*)titleName shareImg:(NSString *)shareImgurl;

- (void)showSearch;

- (void)showTodo;

- (void)showIntro;

- (void)showIntro:(BOOL)first;

- (void)showService;

- (void)showOrHideLeftSideView;

#pragma mark -recorder
- (NSArray*)recorderFilters;
- (void)getRecentImage:(UIImageView*)container;
- (void)getRecentImage:(UIImageView*)container assetsFilter:(ALAssetsFilter *)assetsFilter;

#pragma mark - json helper
- (NSString*)getJSON:(NSObject*)info;
- (id)getObject:(NSString*)json;
//数据转换string 转 NSArray
- (NSArray*)getArray:(NSString*)json;
#pragma mark - Image Helper
- (NSString*)getThumbImageUrl:(NSString*)url;

#pragma mark - leftMenuView
- (void)showLeftMenuViewWithTarget:(id)delegate;
- (void)hideLeftMenuView;

#pragma mark - app stroe评价
- (void)showPraiseBox;

@end

@interface NSString (SString)

- (CGFloat)heightWithRestrictedWidth:(CGFloat)width font:(UIFont*)font;


@end
