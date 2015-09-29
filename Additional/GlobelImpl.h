//
//  GlobelImpl.h
//  Wefafa
//
//  Created by Miaoz on 14/12/9.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#ifndef Wefafa_GlobelImpl_h
#define Wefafa_GlobelImpl_h

static inline float radians(double degrees) { return degrees * M_PI / 180; }

#define headerWidth 140
#define headerHeight 140

#define headerCenterWidth headerWidth/2
#define headerCenterHeight headerHeight/2


#define headerRadius 70

#define headerClipHalfAngle 10  //裁剪弧度的一般的读书


/*

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088511504634465"
//收款支付宝账号
#define SellerID  @"13182998355@126.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @""

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAJ1t5rhOOAcAON5rzMOdT4qbCX6eWUgxn5yjwkMqYiK7lSiM4mS56pjYD6FoWaTrqkXSepOjJJ37Uy4bKSNmjwmT3pMz7+5HcRvejuY+PEbaAMpVvVQ2cQ7+n4a/BHUvXruOB6+QctiYP7RyYy0c8KXCAs9eif/bk8qTljywj3xJAgMBAAECgYBhNSJYvZuk3wM+e8vlIbaivFahg39Xr6SB4TArrvkHv1I7xrpoPdBY7ljAbqGjzwzFrlCX5w3OKwjSmFzPih1ZcbQLEiXYz475qMVpdijbASOmZ4tKaA5vHgssBsUNpxa1DccBCqa5L6722wQZ+octB/WGE+YtePlzhlEakgalAQJBAMjU5YK5ykCd4QaeEPwRBvFBDY6egjivWs2t0xOKknf8cz55q2cczPPXHNEK+0EuaLx763c0w3TpUqYBZAdOYukCQQDIrNGHU51PE8ymabYklF6/yHbL+xWO/kTuKEBwhBZGBGUxX1L7JoMKDLu6M0AIBZOc6683g+OORJ1KreYIprJhAkAAqKokFqXyNlJhqi0WFpw2OGdp+10kAHdEy3gwzTiTyjE6mD2WtgJ6Hk+K5AVU/mj7jVCFcJffj1BlGQYR/BDZAkA4XAEExsD5gpAJdMsI/vqVVlG2/C+T12m4kWl3sEEpLPbWpPUDQE+xNN5MbzRejGJmwfKV3t68CB086hYe++JBAkBNWgLd0ocn3Y7Lcw3HokENfm2dDHqGjllK1rLPlUQUlFPZXE58ZE+vm/1TzQplxWG/3pnDTljLu9NxllbGzO6i"
////支付宝公钥
#define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"


*/

// 放到global变量了

//// 合作商户ID。用签约支付宝账号登录ms.alipay.com后，在账户信息页面获取。
////#define  PartnerID  @"2088701263026887"
//#define  PartnerID  @"2088501752273875"
//// 账户ID。用签约支付宝账号登录ms.alipay.com后，在账户信息页面获取。
////#define SellerID  @"banggo@banggo.com"
//#define SellerID  @"banggo@metersbonwe.com"
//// 商户（RSA）私钥
//#define PartnerPrivKey  @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMK3GTWHKW1xPWCVqle0WW04kH9aAI2FaXSF18KzdVJ0GvXOowksdx3A1gVF8yAziWxTMEJcTA4l3YEq5UV2+scJRWdYhkPG+ZvY2qdzGLQ2eJb+ehuJhIq4dsgYPDqLU56AYEgAOry2s1GWmtgQUERP5sWIhatfrGD+Yb64T65jAgMBAAECgYAUQ0GYVGx3OyWL+4cygU4dE5nV5uPP1mZW/eaqGErJPdPgaJSGy93JdtvOyKy4WSSf5ThMb5Zqkn4uhuw9AliuV0KGsixNauNKuv0GbwMBqCiayN3zb0Blfj9VWrOqroSmx3demeTVlYJzVaeAEhfr456Cw2tty4Ose/qXyyCGAQJBAOjAd+GQ1Xj4kCWx2ubSnWEDDp66VZh/dI2mzEWrUGQWX20XnZkWMR/TsDF4bmmo8XJnvlsRcWM05KqRQz1HMiMCQQDWKgX13sYrvnhSBg/P75RjQ0X0N23CoYLsnuaTUOZ3vixz5cqjEowaGbScIb9TLCEIpfoK1obmo+3Z7hHc6rbBAkEA3Z1NSDBAooOBtPKI7JkDkrh3djkTgTVyg+GaxIde7z3CNLx0qavQsG4+aIw0DVT4OKeBP3L3VK+rPqE7taARowJBAI3IFlgW2sU8/LT4tGEpr+gjMl2ikHSorl9uNyHSDjG54f38ZDGfZscku3Ad22b5sQjjsOyZ54crgZykQokpjkECQFPtwWI7ke++bUjPyZY3/ehQauco3qt+gDxRqxTzdIDULg0THzRADQ3AypUbVNn7aIaq+bQSiJXjh578uOKmmzs="
//
//
//// 支付宝（RSA）公钥 用签约支付宝账号登录ms.alipay.com后，在密钥管理页面获取。
//#define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC7uLJTJxwvbcQ3q04UaNgpwxV+zVtpFWeb/I5U0Plde+taYd0K5UvFFn7swAa0Yflgxnnj1mZ/LlIrlil6sBWQhdJYS6yCrAy7vtUimA1QIoqtEapDyPKs51qoUQfwkqPcZAKI7lOn4ZsZ0Lwl1cebsa1Awx8IdNjLBN6UCJpqvQIDAQAB"
////#define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCtxk1hyltcT1glapXtFltOJB/WgCNhWl0hdfCs3VSdBr1zqMJLHcdwNYFRfMgM4lsUzBCXEwOJd2BKuVFdvrHCUVnWIZDxvmb2Nqncxi0NniW/nobiYSKuHbIGDw6i1OegGBIADq8trNRlprYEFBET+bFiIWrX6xg/mG+uE+uYwIDAQAB"
//


#endif


