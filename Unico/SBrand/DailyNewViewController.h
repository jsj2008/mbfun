//
//  DailyNewViewController.h
//  Wefafa
//
//  Created by metesbonweios on 15/7/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDiscoveryPicAndTextConfigModel;
@class SBrandStoryDetailModel;
@interface DailyNewViewController : SBaseViewController
@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) NSDictionary *brandDic;//传递的字典或者model
@property (nonatomic, assign) BOOL isCanSocial;//购物属性  。 社交属性 
@property (nonatomic, strong) SDiscoveryPicAndTextConfigModel *ptConfigMode;
@property (nonatomic, strong) SBrandStoryDetailModel *brandStoryDeatilModel;



@end
