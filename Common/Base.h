//
//  Base.h
//  Wefafa
//
#import "ModelBase.h"
#import "QuartzCore/QuartzCore.h"

#if ! __has_feature(objc_arc)
#define OBJC_RELEASE(x) if (x != nil) [x release]; x = nil;
#else
#define OBJC_RELEASE(x) x = nil;
#endif

#define OBJC_RELEASE_TIMER(tmr) [tmr invalidate]; OBJC_RELEASE(tmr)

//是否ios5及以后版本，在appdelegate中初始化赋值
extern bool IS_IOS5_LATER;

//ios6编译宏
//#define WEFAFA_IOS6_VERSION_COMPILE YES

//Appstore update switch
//#define APPSTORE

#define FAFADOMAIN @"fafacn.com" //fafajid domain

//定义应用使用中的颜色
#define RED_VIEW_BACKCOLOR    [Utils HexColor:0xB71717 Alpha:1.0]

#define VIEWDARK_BACKCOLOR [Utils HexColor:0xe0e0e0 Alpha:1.0]
#define VIEW_BACKCOLOR2    [Utils HexColor:0xeaeaea Alpha:1.0]
//#define TABLEVIEW_BACKCOLOR [Utils HexColor:0xf8f8f8 Alpha:1.0]
#define TABLEVIEW_BACKCOLOR [Utils HexColor:0xffffff Alpha:1.0]

#define BLUE_GRAY_COLOR [Utils HexColor:0x576c89 Alpha:1.0]

#define RED_GRAY_COLOR [Utils HexColor:0xb71717 Alpha:1.0]

#define GRAY_COLOR [Utils HexColor:0xa2a4a5 Alpha:1.0]

#define SNS_CONTENT_TEXTCOLOR [Utils HexColor:0x333333 Alpha:1.0]
#define SNS_TIME_TEXTCOLOR [Utils HexColor:0x6c6c6c Alpha:1.0]
#define SNS_NAME_TEXTCOLOR [Utils HexColor:0x333333 Alpha:1.0]
#define SNS_BOTTOMNUM_TEXTCOLOR [Utils HexColor:0x8497b6 Alpha:1.0]
#define SNS_TOGETHER_TITLE_TEXTCOLOR [Utils HexColor:0xde850a Alpha:1.0]
#define SNS_BACKGROUND_SILVERCOLOR [Utils HexColor:0xe4e4e4 Alpha:1.0]

#define SCREEN_WIDTH [[UIScreen mainScreen] applicationFrame].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height

//#define CHENGYB_DEBUG_DATA

////整体背景颜色
//#define VIEW_BACKGROUNDCOLOR [UIColor colorWithRed:49/255.0 green:154/255.0 blue:61/255.0 alpha:1.0]
////账号密码输入区域背景
//#define Login_BACKCOLOR [Utils HexColor:0xffffff Alpha:1.0]
////账号密码输入字体颜色
//#define Login_TEXTCOLOR [Utils HexColor:0x999999 Alpha:1.0]
////登陆按钮字体颜色
//#define Login_BTNBACKCOLOR [Utils HexColor:0x319a3d Alpha:1.0]
////登陆设置字体颜色
//#define Login_SETTINGBTNBACKCOLOR [Utils HexColor:0xffffff Alpha:1.0]
////顶部的背景颜色
//#define HEADVIEW_BACKGROUNDCOLOR [UIColor colorWithRed:49/255.0 green:154/255.0 blue:61/255.0 alpha:1.0]
////底部的背景颜色
//#define BOTTOM_BACKGROUNDCOLOR 
////底部的选中背景颜色
//#define BOTTOM_SELECT_BACKGROUNDCOLOR [UIColor colorWithRed:49/255.0 green:154/255.0 blue:61/255.0 alpha:1.0]
////底部未选中背景颜色
//#define BOTTOM_NORMAL_BACKGROUNDCOLOR
//
//// 会话窗口背景
//#define SPEAK_BACKGROUNDCOLOR [UIColor colorWithRed:49/255.0 green:154/255.0 blue:61/255.0 alpha:1.0]

///////////////////////////////////////

@interface NSArray (FirstObject)
- (id)firstObject;
@end

///////////////////////////////////////




