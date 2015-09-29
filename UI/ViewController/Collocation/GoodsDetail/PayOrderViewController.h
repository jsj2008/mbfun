//
//  PayOrderViewController.h
//  Wefafa
//
//  Created by mac on 14-10-31.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PayOrderVCSourceVoBlock) (id sender);
typedef void (^PayOrderVCPayCompleteBlock) (id sender);

@interface PayOrderViewController : UIViewController
{
    NSArray *dataArray;
   
}
@property (strong, nonatomic) IBOutlet UIView *viewHead;
@property (strong, nonatomic) IBOutlet UITableView *tvPayMethod;
@property (strong, nonatomic) NSMutableDictionary *param;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (copy,nonatomic)PayOrderVCSourceVoBlock myblock;
@property (copy,nonatomic)PayOrderVCPayCompleteBlock paycompleteBlock;
@property (nonatomic,strong) NSString *selectedPayType;
//通过我的订单未支付进来 不需要选择支付方式
@property (nonatomic,retain) NSArray *paymentList;


- (IBAction)btnPayClick:(id)sender;
-(void)payOrderVCSourceVoBlock:(PayOrderVCSourceVoBlock) block;
-(void)payOrderVCPayCompleteBlock:(PayOrderVCPayCompleteBlock) block;
+ (PayOrderViewController *)sharedPayOrderViewController;
@end
