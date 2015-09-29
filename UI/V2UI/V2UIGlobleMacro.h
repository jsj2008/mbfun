//
//  V2UIGlobleMacro.m
//  Wefafa
//
//  Created by mac2015 on 15/1/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#define kiPhone5  ([[UIScreen mainScreen] currentMode].size.height == 1136) ? YES : NO
#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)


//字体
#define TABLECELLFONT [UIFont systemFontOfSize:12]//页面主字体
#define TABLECELLSMALLFONT [UIFont systemFontOfSize:10]//页面二级字体
#define NAVHEADFONT  [UIFont systemFontOfSize:20]//标题字体
#define BUTTONBIGFONT  [UIFont boldSystemFontOfSize:16]//按钮大号字体
#define BUTTONSMALLRFONT  [UIFont boldSystemFontOfSize:12]//按钮小号字体
#define BUTTONBIGGIGFONT  [UIFont boldSystemFontOfSize:18]//按钮大号字体
#define BUTTONMEDIUMFONT  [UIFont boldSystemFontOfSize:14]//按钮中号字体



#define LineColor [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1]//线颜色

#define BtnUnSelColor [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1];//按钮未选择背景颜色
#define TABLECELLCOLOR kUIColorFromRGB(0x221e21)

#define DEFAULTCOLOR [UIColor colorWithRed:1 green:221.0/255.0 blue:73.0/255.0 alpha:1];//橙色


#define IOS7  [DetectionSystem SystemVersion]

//版本比较
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#ifdef DEBUG
#	define MBLog(fmt, ...) NSLog((@"%s #%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define MBLog(...)
#endif

#define cellEdge [DetectionSystem CellRight]
#define WINDOWH  [[UIScreen mainScreen] bounds].size.height
#define WINDOWW  [[UIScreen mainScreen] bounds].size.width
//颜色
#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]