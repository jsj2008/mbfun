//
//  SMBRedPacketViewController.h
//  Wefafa
//
//  Created by metesbonweios on 15/6/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RedPacketVCSourceVoBlock) (id sender,id object);


@interface SMBRedPacketViewController :SBaseViewController/* UIViewController*/
@property (nonatomic, assign)BOOL isFromOrder;
@property(strong,nonatomic)RedPacketVCSourceVoBlock myblock;
@property (nonatomic, strong) NSArray *prodList;
@property (nonatomic, strong)NSString *redPacketId;

-(void)RedPacketVCSourceVoBlock:(RedPacketVCSourceVoBlock) block;

@end
