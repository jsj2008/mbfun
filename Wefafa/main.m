
//  main.m
//  Wefafa
//
//  Created by fafa  on 13-6-21.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "CCRuntime.h"
#import "SUploadColllocationControlCenter.h"


int main(int argc, char *argv[])
{
    @autoreleasepool {
        /*
         该处执行函数替换，将NSArray的@selector(objectAtIndex:)、NSMutableArray的@selector(objectAtIndex:)、@selector(addObject:)和NSMutableDictionary的@selector(setObject:forKey:)替换成了安全的实现代码，之后出现数组NSArray、NSMutableArray越界或往字典NSMutableDictionary里面添加空值时程序将不再闪退。若有特殊需求，需要测试这类闪退，可将下面这行代码注释掉。
         */
        //[CCRuntime replaceMethods];暂时注释掉该行代码，因为在某些手机上，当程序进入后台后，如果有这行代码的话有很大概率会出现一个僵尸对象调用release函数，从而导致程序闪退。—— 陈诚 6月26日
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
