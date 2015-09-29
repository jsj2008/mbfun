//
//  DetailReturnMoneyViewController.h
//  Wefafa
//
//  Created by fafatime on 14-12-10.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface DetailReturnMoneyViewController :SBaseViewController/* UIViewController*/

@property (weak,nonatomic)IBOutlet UIView *headView;
@property (weak,nonatomic)IBOutlet UITableView *showDetailTableView;
@property (weak,nonatomic)IBOutlet UIView *tableViewHeadView;
@property (weak,nonatomic)IBOutlet UILabel *statesLabel;
@property (weak,nonatomic)IBOutlet UILabel *reasonLabel;
@property (weak,nonatomic)IBOutlet UILabel *timeLabel;
@property (weak,nonatomic)IBOutlet UILabel *moneyLabel;

@property (weak,nonatomic)IBOutlet UIView *returnGoodHeadView;
@property (weak,nonatomic)IBOutlet UIImageView *hasReplyImgView;
@property (weak,nonatomic)IBOutlet UIImageView *processingImgView;
@property (weak,nonatomic)IBOutlet UIImageView *finishImgView;
@property (weak,nonatomic)IBOutlet UILabel *hasReplyLabel;
@property (weak,nonatomic)IBOutlet UILabel *processLabel;
@property (weak,nonatomic)IBOutlet UILabel *finishLabel;


@property (retain,nonatomic) NSDictionary *detailGoodDic;
@property (retain,nonatomic) NSDictionary *colloctionDic;
@property (retain,nonatomic)NSString *titleStr;
@property (retain,nonatomic)NSString *isReturn;
@property (strong,nonatomic)OrderModel *colloctionDicOrderModel;
@property (nonatomic,strong)OrderModelDetailListInfo *detaiGoodDicOrderModel;

@end
