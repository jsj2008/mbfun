//
//  ZaoXingShiCell.h
//  Wefafa
//
//  Created by su on 15/1/28.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DesignerModel;

@interface SearchDesignerCell : UITableViewCell
@property(nonatomic,strong)UIButton *favoriteBtn;

- (void)updateDataWithDictionary:(DesignerModel *)model;
@end

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