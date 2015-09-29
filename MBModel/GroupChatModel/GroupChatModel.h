//
//  GroupChatModel.h
//  Wefafa
//
//  Created by su on 15/5/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupChatModel : NSObject
@property(nonatomic,assign)NSInteger gender;
@property(nonatomic,strong)NSString *headPortrait;
@property(nonatomic,strong)NSString *idValue;
@property(nonatomic,assign)BOOL isActive;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,assign)NSInteger userLevel;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *fafa_jid;
@property(nonatomic,assign)BOOL isSelected;

- (id)initWithDict:(NSDictionary *)dict;
@end
