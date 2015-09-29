//
//  NewBingBankViewController.m
//  Wefafa
//
//  Created by fafatime on 15-2-4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "NewBingBankViewController.h"
#import "MBShoppingGuideInterface.h"
#import "NavigationTitleView.H"
#import "Toast.h"
#import "Utils.h"

@interface NewBingBankViewController ()

@end

@implementation NewBingBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"绑定银行卡";
    [self.headView addSubview:view];

    
    //绑定银行卡
    NSString *urlName=@"WxSellerCardCreate";
    NSMutableDictionary *requestBankDic = [NSMutableDictionary new];
    NSMutableString *returnMsg=[NSMutableString new];
    NSString *cardNo=[NSString stringWithFormat:@""];
    NSString *cardName=[NSString stringWithFormat:@""];
    NSString *isDefault = [NSString stringWithFormat:@"0"];
    NSString *bank_id=[NSString stringWithFormat:@""];
    NSDictionary *paramDic=@{@"UserId":sns.ldap_uid,@"CARD_NO":cardNo,@"CARD_NAME":cardName,@"IS_DEFAULT":isDefault,@"BANK_ID":bank_id};
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL success = [SHOPPING_GUIDE_ITF requestPostUrlName:urlName param:paramDic responseAll:requestBankDic responseMsg:returnMsg];
        
        if (success) {
//            pickData = [requestBankDic objectForKey:@"results"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });
// 查询了银行卡
    NSString *searchUrlName=@"WxSellerCardFilter";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:searchUrlName param:@{@"UserId":sns.ldap_uid} responseAll:requestBankDic responseMsg:returnMsg];

        if (success) {
            NSLog(@"reuestBankDic---%@",requestBankDic);
            //银行
            dispatch_async(dispatch_get_main_queue(), ^{
             
            });
            
        }
        else
        {
         
        }
        //银行
        dispatch_async(dispatch_get_main_queue(), ^{
        });    });
   //查询银行信息
    NSString *st = @"BaseBankFilter";
    NSMutableArray *requestBankArray=[NSMutableArray new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:st param:nil responseAll:requestBankDic responseMsg:returnMsg];
        
        BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:st param:nil responseList:requestBankArray responseMsg:returnMsg];
        if (success) {
//            pickData = [requestBankDic objectForKey:@"results"];
            NSLog(@"银行卡---%@",requestBankArray);
        }
        
        //银行
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            [self initPackView];
        });
    });
    

    
    
}
- (void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
