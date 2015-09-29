//
//  CommunityCollectionViewCell.h
//  Wefafa
//
//  Created by wave on 15/8/17.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNGood.h"
static NSString *communityCollectionViewCellID = @"communityCollectionViewCellID";
@interface CommunityCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSString *userID;
@property (nonatomic) LNGood *model;
@end
