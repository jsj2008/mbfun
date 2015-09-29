//
//  ScanCodeInfo.h
//  Wefafa
//
//  Created by Miaoz on 15/2/9.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "total" : 0,
 "results" : [
 {
 "shoP_CODE" : "",
 "sigN_TIME" : "\/Date(-62135596800000-0000)\/",
 "id" : 0,
 "seller_UserId" : "",
 "useR_ID" : "4a035629-f68d-4723-815b-c9efd62d7f11",
 "loseHours" : 0,
 "loseTime" : "\/Date(1423481093102+0800)\/",
 "isLose" : true
 }
 ],
 "message" : "",
 "isSuccess" : true
 }
 
 ID	Int	主键id
 SHOP_CODE	string	门店编码
 USER_ID	string	用户UserId
 SIGN_TIME	string	签到日期
 Seller_UserId	String	导购UserID
 LoseHours	int	失效时间段
 LoseTime	DateTime	失效时间
 IsLose	bool	是否失效（true 失效 false 未失效）
 */
@interface ScanCodeInfo : NSObject
@property(nonatomic,strong) NSString *shoP_CODE;
@property(nonatomic,strong) NSString *sigN_TIME;
@property(nonatomic,strong)  NSString *id;
@property(nonatomic,strong)  NSString *seller_UserId;
@property(nonatomic,strong)  NSString *useR_ID;
@property(nonatomic,strong)  NSString *loseHours;
@property(nonatomic,strong)  NSString *loseTime;
@property(nonatomic,strong)  NSString *isLose;


@property(nonatomic,strong) NSString *orG_NAME;//门店名称
@end
