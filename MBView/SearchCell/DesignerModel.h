//
//  DesignerModel.h
//  Wefafa
//
//  Created by su on 15/2/11.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesignerModel : NSObject
@property(assign,nonatomic)NSInteger concernsCount;
@property(assign,nonatomic)NSInteger designCount;
@property(assign,nonatomic)NSInteger fansCount;
@property(nonatomic,strong)NSString *grade;
@property(nonatomic,strong)NSString *headPortrait;
@property(nonatomic,assign)BOOL isConcerned;
@property(nonatomic,assign)NSInteger points;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *userSignature;
@property(nonatomic,strong)NSMutableArray * collocationList;
@property(nonatomic,strong)NSNumber *head_v_type;

- (id)initWithDesignerInfo:(NSDictionary *)dict;

/*
 concernsCount = 1;
 designCount = 0;
 fansCount = 1;
 grade = V1;
 headPortrait = "http://180.168.84.206:5659/sources/account/HeadPortrait/defmale.png";
 isConcerned = 0;
 points = 0;
 userId = "fa2412eb-8bba-4212-90e5-6bcf9c8673db";
 userName = MD00000295;
 userSignature = "";
 */
@end
