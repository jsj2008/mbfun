//
//  SCollocationDetailViewController.h
//  Wefafa
//
//  Created by unico_0 on 7/24/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"
@class SMDataModel;


@interface SCollocationDetailViewController : SBaseViewController

@property (nonatomic, strong) NSString* collocationId;
@property(nonatomic,strong) NSDictionary *collocationInfo;
@property (nonatomic, strong) NSString *mb_collocationId;
@property (nonatomic, strong) NSArray *promPlatModelArray;
@property (nonatomic, strong) NSString *promotion_ID;
@property (nonatomic, copy) NSString *fromControllerName;
@property (nonatomic,strong) SMDataModel *smdataModel;//相关搭配传递过来 喜欢 取消喜欢 图标更改
@property (nonatomic, strong) SCollocationDetailModel *contentModel;
@property (nonatomic, strong) void (^isLikeBlock)(BOOL isLike); // ps:（9.25）用于相关搭配中的喜欢
#pragma mark - 高度返回
- (CGFloat)cellHeightWithType:(int)type;
- (void)requestData;

@end
