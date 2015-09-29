//
//  MBHttpBase.h
//  Wefafa
//
//  Created by su on 15/3/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#define __Text_Environment__   //测试环境

#ifdef __Text_Environment__

#define kUrlPath @"/CallCenter/InvokeSecurity.ashx"
#define kTokenPath @"/CallCenter/OAuth/AccessToken.ashx"


#else
#define kUrlPath @"/CallCenter/InvokeSecurity.ashx"
#define kTokenPath @"/CallCenter/OAuth/AccessToken.ashx"

#endif

