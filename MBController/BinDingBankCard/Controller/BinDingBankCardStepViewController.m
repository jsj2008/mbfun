//
//  BinDingBankCardStepViewController.m
//  Wefafa
//
//  Created by Jiang on 2/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "BinDingBankCardStepViewController.h"
#import "BinDingBankCardFinishViewController.h"
#import "MBShoppingGuideInterface.h"
#import "Toast.h"
#import "BaseBankFilterModel.h"

@interface BinDingBankCardStepViewController ()

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIDCardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNumberLabel;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *settingDefaultButton;
- (IBAction)settingDefaultButtonAction:(UIButton *)sender;


@property (nonatomic, assign, getter=isBackCardDefault) BOOL bankCardDefault;

@end

@implementation BinDingBankCardStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self setTitle:@"绑定银行卡"];
    [self setLeftButtonImage:@"ion_back" target:self selector:@selector(navigationBarLeftButton)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubView
{
    UIImage *image = [UIImage imageNamed:@"btn_orderdetail_gray.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.nextButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.bankNameLabel.text = self.bankName;
    NSInteger userNameRangLenth = self.userName.length/2;
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < userNameRangLenth; i ++) {
        [string appendString:@"*"];
    }
    NSString *userName = [NSString stringWithFormat:@"%@%@", string,[self.userName substringWithRange:NSMakeRange(userNameRangLenth, self.userName.length - userNameRangLenth)]];
    self.userNameLabel.text = userName;
    
    [self.settingDefaultButton setTitle:@"设置默认" forState:UIControlStateNormal];
    [self.settingDefaultButton setTitle:@"已为默认" forState:UIControlStateSelected];
}

- (void)requestData{
//    NSString *urlName = @"WxSellerCardCreate";
//    NSMutableDictionary *requestBankDic = [NSMutableDictionary dictionary];
//    NSMutableString *returnMsg=[NSMutableString string];
//    NSString *cardNo = self.bankCardNumber;
//    NSString *cardName = self.userName;
//    NSString *isDefault = [NSString stringWithFormat:@"%d", self.bankCardDefault];
//    NSNumber *bank_id = self.baseBankFilterModel.aID;
//    NSDictionary *paramDic=@{@"UserId":sns.ldap_uid,@"CARD_NO":cardNo,@"CARD_NAME":cardName,@"IS_DEFAULT":isDefault,@"BANK_ID":bank_id};
//    [Toast makeToastActivity:@"绑定中..." hasMusk:YES];
//    __unsafe_unretained typeof(self) p = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        BOOL success = [SHOPPING_GUIDE_ITF requestPostUrlName:urlName param:paramDic responseAll:requestBankDic responseMsg:returnMsg];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [Toast hideToastActivity];
//            BinDingBankCardFinishViewController *controller = [[BinDingBankCardFinishViewController alloc]initWithNibName:@"BinDingBankCardFinishViewController" bundle:nil];
//            controller.bindingSucceed = success;
//            controller.errorContent = returnMsg;
//            [p.navigationController pushViewController:controller animated:YES];
//        });
//    });
}

- (void)navigationBarLeftButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextButtonAction:(UIButton *)sender {
    [self requestData];
}

- (void)jumbFinishController{
    
}

#pragma mark - set AND get


- (IBAction)settingDefaultButtonAction:(UIButton *)sender {
    self.bankCardDefault = ![self isBackCardDefault];
    [self.settingDefaultButton setSelected:self.bankCardDefault];
}
@end
