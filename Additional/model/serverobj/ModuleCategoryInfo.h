//
//  ModuleCategoryInfo.h
//  Wefafa
//
//  Created by Miaoz on 15/4/2.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 参数	类型	说明	备注
 Id	Int	主键
 Name	string	名称
 UnLockTip	string	未达到点赞数是，进入当前等级系统模板的提示
 LockedStar	Int	等级信息
 UnLockedCount
	Int	解锁的点赞数
 PicUrl	string	分类的图片地址
 FavCount
 Int	点赞数
 IsLocked
	Int	是否被锁住	1，表示被锁住，0，表示没有锁住
 {
 "unLockTip" : "无门槛yyyy,0\/20",
 "isLocked" : 1,
 "id" : 4,
 "name" : "时尚优等生1",
 "favCount" : 0,
 "lockedStar" : 11,
 "picUrl" : "http:\/\/img.51mb.com:5659\/sources\/designer\/Collocation\/20150324\/1427190416--300x300.jpg",
 "unLockedCount" : 20
 }

 */

@interface ModuleCategoryInfo : NSObject
@property(nonatomic,strong) NSString * unLockTip;
@property(nonatomic,strong) NSString * isLocked;
@property(nonatomic,strong) NSString * id;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * favCount;
@property(nonatomic,strong) NSString * lockedStar;
@property(nonatomic,strong) NSString * picUrl;
@property(nonatomic,strong) NSString * unLockedCount;

@end
