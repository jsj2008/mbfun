//
//  JSAPIWebView.h
//  Wefafa
//
//  Created by chencheng on 15/9/6.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSAPIWebView : UIWebView

/**
 *   设置JS函数jsFunName调用本地OC代码的API
 *
 *   @param target——本地API的target
 *   @param action——本地API的action
                    1、action的参数类型必须为JSValue *类型，该类型可以转化成大部分类型————toBool toDouble toInt32 toUInt32 toNumber toString toDate toArray toDictionary。
                    2、action对应的函数可以有返回值，也可以没有。如果有返回值，该返回值会同步返回给JS函数。返回值只能为NSString*类型，其它数据类型可自行转化成JSON字符串后再返回（后续会尽可能支持更多数据类型）。
 *   @param jsFunName——JS端的函数名称, 该名称不包含参数信息。JS的函数jsFunName的参数的个数与类别应与本地API 的action的参数一致。否则会闪退。
 *
 *   无返回值
 */
- (void)setTarget:(id)target action:(SEL)action forJSFunName:(NSString *)jsFunName;


/**
 *   执行JS函数jsFun，这是同步调用，该调用会等待JS函数执行完才返回，如需异步操作，可自行用多线程API实现。
 *
 *   @param jsFun——要执行的JS函数, 需要传入JS函数所需要的参数
 *
 *   JSValue：JS函数的返回值，可转化成大部分数据类型——toBool toDouble toInt32 toUInt32 toNumber toString toDate toArray toDictionary
 */
- (JSValue *)evaluateJSFun:(NSString *)jsFun;

@end
