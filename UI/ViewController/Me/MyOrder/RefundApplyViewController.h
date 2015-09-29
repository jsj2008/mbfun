//
//  RefundApplyViewController.h
//  Wefafa
//
//  Created by fafatime on 14-12-5.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@class OrderModelDetailListInfo;

@interface RefundApplyViewController : SBaseViewController/*UIViewController*/<UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,weak)IBOutlet UIView *headView;
@property(nonatomic,weak)IBOutlet UIView *tableViewHeadView;
@property(nonatomic,weak)IBOutlet UITableView *listTableView;
@property(nonatomic,weak)IBOutlet UILabel *allMoneyLabel;
@property(nonatomic,weak)IBOutlet UILabel *nameLabel;
@property(nonatomic,weak)IBOutlet UILabel *priceLabel;

@property(nonatomic,weak)IBOutlet UILabel *goodOrMoneyLabel;
@property(nonatomic,weak)IBOutlet UILabel *goodPriceLabel;
@property(nonatomic,retain) NSDictionary *goodDic;
@property(nonatomic,retain) NSDictionary *collocationDic;
@property(nonatomic,retain) NSString *titleStr;
@property (nonatomic,retain) NSString *isReturn;
@property (nonatomic,strong)OrderModel *collocationDicOrderModel;
@property (nonatomic,strong)OrderModelDetailListInfo *goodDicOrderModel;


@end
