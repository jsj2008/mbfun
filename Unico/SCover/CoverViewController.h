//
//  CoverViewController.h
//  StoryCam
//
//  Created by Ryan on 15/4/20.
//  Copyright (c) 2015年 Unico. All rights reserved.
//  封面查看VC
//

#import <UIKit/UIKit.h>


@interface CoverViewController : SBaseViewController

@property (nonatomic) BOOL autoPop; // 首页全屏模式的效果。
@property (nonatomic) TopicViewType type;
@property (nonatomic) NSDictionary *data;
@property (nonatomic,strong) SCoverForkFunc forkFunc;

-(NSMutableArray*)topicData;
@end
