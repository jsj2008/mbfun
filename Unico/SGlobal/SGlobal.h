//
//  SGlobal.h
//  Story
//
//  Created by Ryan on 15/4/26.
//  Copyright (c) 2015年 Unico. All rights reserved.
//  此处处理一些需要全局初始化的东西。
//

#import <Foundation/Foundation.h>

#define SHOW_TOPIC_TYPE 1
#define SHOW_SPECIAL_TYPE 2
#define SHOW_ATTENTION_TYPE 3
#define SGLOBAL_DATA_INSTANCE  ((SGlobal*)[SGlobal shared])
@interface SGlobal : NSObject

// 工具方法最要不要用静态的。
+(id)shared;
//专题显示的类型
@property (nonatomic) NSInteger showFlowType;

@property (strong, nonatomic) NSMutableArray *specialArray;
@property (nonatomic) NSInteger specialLastIndex;
//滚动偏移量
@property (nonatomic) NSInteger scrollSelectedOffset;


// 暂时没有完成的2个函数，需要设计一下。
-(void)animatePushVC:(UIViewController*)oldVC newVC:(UIViewController*)newVC type:(STransitionType)type complete:(SVoidFunc)complete;
-(void)animatePopVC:(UIViewController*)vc parentVC:(UIViewController*)parentVC type:(STransitionType)type complete:(SVoidFunc)complete;
//专题评论数 操作
-(void)calculateCommentNum:(NSInteger)topicId addNum:(NSInteger)num;
//专题收藏数 操作
-(void)calculateLikeNum:(NSInteger)topicId addNum:(NSInteger)num;
@end
