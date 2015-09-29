//
//  ExpressageViewController.h
//  Wefafa
//
//  Created by fafatime on 14-12-12.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@class OrderModelDetailListInfo;

@interface ExpressageViewController : SBaseViewController/*UIViewController*/<UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,weak)IBOutlet UIView *headView;
@property(nonatomic,weak)IBOutlet UITableView *listTableView;
@property(nonatomic,retain)NSDictionary *goodsDic;//所有信息
@property(nonatomic,retain)NSDictionary *returnDataDic;//退货信息退款信息
@property (nonatomic,assign)BOOL isReturn;//判断是否来自退货退款
@property(nonatomic,strong)OrderModelDetailListInfo *goodsDicOrderModel;

//@property(nonatomic,retain)NSString *returnID;
//
@end
