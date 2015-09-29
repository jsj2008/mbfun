//
//  SMineLikeViewController.h
//  Wefafa
//
//  Created by Funwear on 15/8/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//我的喜欢

#import <UIKit/UIKit.h>
#import "CommunityCollectionView.h"
@interface SMineLikeViewController : SBaseViewController

@property (strong, nonatomic) NSString *person_id;
@property (nonatomic) CommunityCollectionView *collectionView;//搭配
@end
