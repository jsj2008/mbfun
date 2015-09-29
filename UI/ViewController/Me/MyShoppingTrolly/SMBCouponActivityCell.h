//
//  SMBCouponActivityCell.h
//  Wefafa
//
//  Created by Miaoz on 15/6/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlatFormBasicInfo.h"
@interface SMBCouponActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;
@property (weak, nonatomic) IBOutlet UILabel *oneLab;
@property (weak, nonatomic) IBOutlet UILabel *twoLab;
@property (weak, nonatomic) IBOutlet UILabel *threeLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic,strong)NSMutableArray *remarkLabArray;

//@property (nonatomic,strong) PlatFormBasicInfo *platFormBasicInfo; 
@property (nonatomic,strong)ActivityOrderModel *activityOrdermodel;

@end
