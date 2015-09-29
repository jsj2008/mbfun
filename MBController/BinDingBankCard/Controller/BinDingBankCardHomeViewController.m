//
//  BinDingBankCardViewController.m
//  Wefafa
//
//  Created by Jiang on 2/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "BinDingBankCardHomeViewController.h"
#import "BinDingBankCardStepViewController.h"
#import "BinDingBankCardFinishViewController.h"
#import "AlreadyBinDingBankCardViewController.h"
#import "NavigationTitleView.h"
#import "MBShoppingGuideInterface.h"
#import "BaseBankFilterModel.h"
#import "BinDingSubContentView.h"
#import "UIImageView+AFNetworking.h"
#import "Toast.h"
#import "Utils.h"

@interface BinDingBankCardHomeViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) NavigationTitleView *navigationBarView;

@property (weak, nonatomic) IBOutlet UITextField *bankCardNumberField;
@property (nonatomic, copy) NSMutableString *bankCardNumberString;
@property (weak, nonatomic) IBOutlet UITextField *bankBranchCardField;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *defalutButton;
- (IBAction)defalutButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *bankCardIconImage;

@property (weak, nonatomic) UIPickerView *pickerView;
@property (weak, nonatomic) UIButton *dismissPickerViewButton;

@property (strong, nonatomic) NSArray *baseBankFilterModelArray;
@property (strong, nonatomic) BaseBankFilterModel *baseBankFilterModel;
@property (nonatomic, assign) CGFloat showAllContentY;
@property (nonatomic, assign) CGRect nextButtonOriginFrame;

@property (strong, nonatomic) IBOutletCollection(BinDingSubContentView) NSArray *subContentView;

@property (assign, nonatomic) BOOL showContentList;
@end

@implementation BinDingBankCardHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self initSubContentView];
    [self initNavigationBar];
    self.nextButton.userInteractionEnabled = NO;
}

- (void)initNavigationBar{
    [self setTitle:@"绑定银行卡"];
    [self setRightButton:@"取消" target:self selector:@selector(navigationBarRightButtonTag)];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.defalutButton.selected = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)initSubView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.bankBranchCardField.delegate = self;
    self.bankCardNumberField.delegate = self;
    self.userNameField.delegate = self;
    
    self.nextButton.layer.cornerRadius = 3.0;
    self.nextButtonOriginFrame = self.nextButton.frame;
    _nextButtonOriginFrame.size.width = UI_SCREEN_WIDTH - _nextButtonOriginFrame.origin.x * 2;
    [self.nextButton setTitle:@"提交" forState:UIControlStateSelected];
}

- (void)initSubContentView{
    CGRect subRect = CGRectMake(0, 45.0, UI_SCREEN_WIDTH, 45);
    for (BinDingSubContentView *view in self.subContentView) {
        view.frame = subRect;
    }
    CGRect rect = self.nextButton.frame;
    rect.origin.y = 100;
    self.nextButton.frame = rect;
}

- (void)closeKeyboard{
    [self dismissPickerView];
    [self.bankCardNumberField resignFirstResponder];
    [self.userNameField resignFirstResponder];
    [self.bankBranchCardField resignFirstResponder];
    __unsafe_unretained typeof(self) p = self;
    [UIView animateWithDuration:0.25 animations:^{
        p.contentScrollView.contentOffset = CGPointZero;
    }completion:^(BOOL finished) {
        p.contentScrollView.contentSize = CGSizeZero;
    }];
}

- (void)keyboardDidShow{
    UITextField *textField = nil;
    if ([self.bankCardNumberField isEditing]) {
        textField = self.bankCardNumberField;
    }else if([self.userNameField isEditing]){
        textField = self.userNameField;
    }else if([self.bankBranchCardField isEditing]){
        textField = self.bankBranchCardField;
    }else{
        return;
    }
    CGFloat filed_Y = textField.superview.frame.origin.y - textField.superview.frame.size.height;
    if (self.showAllContentY > SCREEN_HEIGHT) {
        CGFloat maxMove_Y = self.showAllContentY - self.contentScrollView.frame.size.height;
        filed_Y = MIN(filed_Y, maxMove_Y);
        self.contentScrollView.contentSize = CGSizeMake(0, self.showAllContentY);
        [self.contentScrollView setContentOffset:CGPointMake(0, MIN(filed_Y, CGRectGetMaxY(self.nextButtonOriginFrame))) animated:YES];
    }
}

- (CGFloat)showAllContentY{
    CGFloat nextShowLocation = CGRectGetMaxY(self.nextButton.frame);
    CGFloat move_Distance = nextShowLocation + 250 + 10;
    _showAllContentY = move_Distance;
    return _showAllContentY;
}

- (void)setShowBackButton:(BOOL)showBackButton{
    _showBackButton = showBackButton;
    
    if (showBackButton) {
        [self setLeftButtonImage:@"ion_back.png" target:self selector:@selector(navigationBarLeftButton)];
    }else{
        [self setLeftButton:@"关闭" target:self selector:@selector(dismissCurrentController)];
    }
    
//    self.navigationItem.hidesBackButton = YES;
//    if (showBackButton) {
//        [self setLeftButtonImage:@"ion_back" target:self selector:@selector(navigationBarLeftButton)];
//    }
}

- (void)dismissCurrentController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)navigationBarLeftButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationBarRightButtonTag{
    if (self.bankBranchCardField.text.length != 0 || self.bankCardNumberField.text.length != 0 || self.userNameField.text.length != 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认退出！" message:@"退出将丢失您现在正在编辑的内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }else{
        [super dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}
//提交创建银行卡信息
- (void)requestCreateData{
    [Toast makeToastActivity:@"正在提交您银行卡信息..." hasMusk:YES];
    NSString *urlName = @"WxSellerCardCreate";//WxSellerCardCreate
    NSMutableDictionary *requestBankDic = [NSMutableDictionary dictionary];
    NSMutableString *returnMsg=[NSMutableString string];
    NSString *cardNo = self.bankCardNumberField.text;
    NSString *cardName = self.userNameField.text;
    NSString *isDefault = [NSString stringWithFormat:@"%d", [self.defalutButton isSelected]];
    NSNumber *bank_id = self.baseBankFilterModel.aID;
    NSString *branchName = self.bankBranchCardField.text;
    
    NSDictionary *paramDic = @{@"userId":sns.ldap_uid,
                               @"carD_NO":cardNo,
                               @"carD_NAME":cardName,
                               @"is_DEFAULT":isDefault,
                               @"banK_ID":bank_id,
                               @"BANK_DTNAME": branchName,
                               @"protocol": @2};
    
    __weak typeof(self) p = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL success = [SHOPPING_GUIDE_ITF requestPostUrlName:urlName param:paramDic responseAll:requestBankDic responseMsg:returnMsg];

        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            if (success) {
//                BinDingBankCardFinishViewController *controller = [[BinDingBankCardFinishViewController alloc]initWithNibName:@"BinDingBankCardFinishViewController" bundle:nil];
//                controller.bindingSucceed = success;
//                controller.errorContent = returnMsg;
//                [p.navigationController pushViewController:controller animated:YES];
                [p.navigationController popToRootViewControllerAnimated:YES];
                for (UIViewController *controll in p.navigationController.viewControllers) {
                    if ([controll isKindOfClass:[AlreadyBinDingBankCardViewController class]]) {
                        [(AlreadyBinDingBankCardViewController*)controll showSuccessAndRequest];
                    }
                }
            }else{
                NSString *showMessage;
                if (returnMsg.length==0) {
                    showMessage = @"绑定失败";
                    
                }
                else
                {
                    showMessage = returnMsg;
                }
                [Toast makeToast:showMessage duration:2.0 position:@"center"];
            }
        });
    });
}

- (void)requestBankNumberOfBankName:(NSString*)bankNumber{
    if(bankNumber.length == 0){
        [Toast makeToast:@"请输入银行卡号" duration:1.0 position:@"center"];
        return;
    }
    [Toast makeToastActivity:@"正在加载数据..." hasMusk:YES];
    NSMutableString *returnMsg=[NSMutableString string];
    NSString *st = @"BaseBankFilter";
    NSMutableArray *requestBankArray = [NSMutableArray array];
    NSDictionary *paramDictionary = @{@"BankCode": bankNumber};
    __weak typeof(self) p = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [SHOPPING_GUIDE_ITF requestGetUrlName:st param:paramDictionary responseList:requestBankArray responseMsg:returnMsg];
        //银行
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            if (success) {
                if (requestBankArray.count == 0) {
                    [Toast makeToast:@"卡号有误,请检查您的输入!" duration:1.0 position:nil];
                }else{
                    p.baseBankFilterModel = [[BaseBankFilterModel alloc]initWithDictionary:requestBankArray[0]];
                }
            }
        });
    });
}

//请求获得银行卡
- (void)requestBankArrayData{
    [Toast makeToastActivity:@"正在加载数据..." hasMusk:YES];
    NSMutableString *returnMsg=[NSMutableString string];
    NSString *st = @"BaseBankFilter";
    NSMutableArray *requestBankArray=[NSMutableArray array];
    __weak typeof(self) p = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:st param:nil responseList:requestBankArray responseMsg:returnMsg];
        //银行
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            if (success) {
                p.baseBankFilterModelArray = requestBankArray;
                p.baseBankFilterModel = p.baseBankFilterModelArray[0];
                [p showBaseBankArrayView];
            }
        });
    });
}
//显示银行列表
- (void)showBaseBankArrayView{
    [self closeKeyboard];
    UIPickerView *pickerView = [[UIPickerView alloc]init];
    pickerView.backgroundColor = [UIColor whiteColor];
    CGRect rect = pickerView.frame;
    rect.origin.y = self.view.frame.size.height - rect.size.height;
    pickerView.frame = rect;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    CGRect buttonRect = button.frame;
    buttonRect.origin.x = rect.size.width - buttonRect.size.width;
    buttonRect.origin.y = rect.origin.y;
    button.frame = buttonRect;
    [button addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.dismissPickerViewButton = button;
    
}
//检测文本框合法性
- (BOOL)checkBankNumberIsEffective{
    BOOL isEffective = YES;
    NSString *textBankNumber = self.bankCardNumberString;
    NSString *textBankName = self.bankBranchCardField.text;
    NSString *userName = self.userNameField.text;
    BOOL isTextBankName = [textBankName isEqualToString:@""] || !textBankName;
    BOOL isTextBankNumber = [textBankNumber isEqualToString:@""] || !textBankNumber;
    BOOL isTextUserName = [userName isEqualToString:@""] || !userName;
    NSString *errorName = nil;
    if (isTextBankName || isTextBankNumber || isTextUserName) {
        if (isTextBankName) {
            errorName = @"您的银行卡支行名称不能为空";
        }else if(isTextBankNumber){
            errorName = @"请输入银行卡号";
        }else if (isTextUserName){
            errorName = @"请输入用户名";
        }
        isEffective = NO;
    }else {
        NSScanner *scanner = [NSScanner scannerWithString:textBankNumber];
        int val;
        BOOL isBankNumberAllNumber = [scanner scanInt:&val] && [scanner isAtEnd];
        if (!isBankNumberAllNumber) {
            errorName = @"银行卡号含有非法字符";
            isEffective = NO;
        }
    }
    if (!isEffective) {
        self.nextButton.userInteractionEnabled = NO;
        [Toast makeToast:errorName duration:1.0 position:@"center"];
        [self performSelector:@selector(nextButtonActionOpenUserInteractionEnabled) withObject:nil afterDelay:1.5];
    }
    return isEffective;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [Toast hideToastActivity];
    [self closeKeyboard];
    [self dismissPickerView];
    [super viewWillDisappear:animated];
}

- (void)nextButtonActionOpenUserInteractionEnabled{
    self.nextButton.userInteractionEnabled = YES;
}

- (void)setBaseBankFilterModelArray:(NSArray *)baseBankFilterModelArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in baseBankFilterModelArray) {
        BaseBankFilterModel *model = [[BaseBankFilterModel alloc] initWithDictionary:dict];
        [array addObject:model];
    }
    _baseBankFilterModelArray = array;
}

- (void)setBaseBankFilterModel:(BaseBankFilterModel *)baseBankFilterModel{
    _baseBankFilterModel = baseBankFilterModel;
    [self.bankCardNumberField endEditing:YES];
    self.showContentList = YES;
    NSString *urlString = [NSString stringWithFormat:@"http://10.100.5.12/Stylistoriginal/bank/logoicon/%@.png", baseBankFilterModel.shorT_CODE];
    NSURL *url = [NSURL URLWithString:urlString];
    [self.bankCardIconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    NSString *string = [NSString stringWithFormat:@"%@ %@", baseBankFilterModel.name, baseBankFilterModel.carD_TYPE];
    NSInteger nameLength = baseBankFilterModel.name.length;
    NSMutableAttributedString *attributString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, nameLength)];
    [attributString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(nameLength + 1, baseBankFilterModel.carD_TYPE.length)];
    self.bankNameLabel.attributedText = attributString;
}

- (void)setShowContentList:(BOOL)showContentList{
    if (showContentList == _showContentList) return;
    _showContentList = showContentList;
    if (showContentList) {
        [self showListContent];
    }else{
        [self closeListContent];
    }
}

- (void)showListContent{
    self.view.userInteractionEnabled = NO;
    [self.bankCardNumberField setClearButtonMode:UITextFieldViewModeAlways];
    for (BinDingSubContentView *view in self.subContentView) {
        CGFloat move_Y = fabs(view.originFrame.origin.y - view.frame.origin.y);
        CGFloat duration = move_Y / 45.0 / 6.0;
        [UIView animateWithDuration:duration animations:^{
            view.frame = view.originFrame;
        }];
    }
    CGFloat move_Y = self.nextButtonOriginFrame.origin.y - self.nextButton.frame.origin.y;
    CGFloat duration = move_Y / 45.0 / 7.0;
    __weak typeof(self) p = self;
    [UIView animateWithDuration:duration animations:^{
        p.nextButton.frame = p.nextButtonOriginFrame;
    }completion:^(BOOL finished) {
        [p.nextButton setSelected:YES];
        p.nextButton.backgroundColor = [Utils HexColor:0xe2e2e2 Alpha:1];
        p.nextButton.userInteractionEnabled = NO;
        p.view.userInteractionEnabled = YES;
    }];
}

- (void)closeListContent{
    self.view.userInteractionEnabled = NO;
    self.nextButton.selected = NO;
    [self.bankCardNumberField setClearButtonMode:UITextFieldViewModeWhileEditing];
    CGRect rect = CGRectMake(0, 45.0, UI_SCREEN_WIDTH, 45.0);
    CGRect nextButtonRect = self.nextButton.frame;
    nextButtonRect.origin.y = 100;
    for (BinDingSubContentView *view in self.subContentView) {
        CGFloat move_Y = fabs(view.frame.origin.y - 45.0);
        CGFloat duration = move_Y / 45.0 / 6.0;
        [UIView animateWithDuration:duration animations:^{
            view.frame = rect;
        }completion:^(BOOL finished) {
            self.view.userInteractionEnabled = YES;
        }];
    }
    CGFloat move_Y = fabs(nextButtonRect.origin.y - self.nextButton.frame.origin.y);
    CGFloat duration = move_Y / 45.0 / 6.0;
    __weak typeof(self) p = self;
    [UIView animateWithDuration:duration animations:^{
        p.nextButton.frame = nextButtonRect;
    }];
}

- (IBAction)nextButtonAction:(UIButton *)sender {
    if([self.nextButton isSelected]){
        BOOL isCheckPass = [self checkBankNumberIsEffective];
        if (isCheckPass) {
            [self requestCreateData];
        }
    }else{
        NSScanner *scanner = [NSScanner scannerWithString:self.bankCardNumberString];
        int val;
        BOOL isBankNumberAllNumber = [scanner scanInt:&val] && [scanner isAtEnd];
        if (!isBankNumberAllNumber && ![self.bankCardNumberString isEqualToString:@""]) {
            [Toast makeToast:@"银行卡号含有非法字符" duration:1.0 position:@"center"];
        }else{
            [self requestBankNumberOfBankName:self.bankCardNumberString];
        }
    }
}

- (IBAction)bankCardFieldActionButton:(UIButton *)sender {
    [self requestBankArrayData];
}

- (void)dismissPickerView{
    [self.dismissPickerViewButton removeFromSuperview];
    [self.pickerView removeFromSuperview];
}

#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"确认退出！"]) {
        if (buttonIndex == 1) {
            [super dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

#pragma mark - pickerDelegate DataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.baseBankFilterModelArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    BaseBankFilterModel *model = self.baseBankFilterModelArray[row];
    NSString *string = [NSString stringWithFormat:@"%@[%@]", model.name, model.carD_NAME];
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    label.text = string;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.baseBankFilterModel = self.baseBankFilterModelArray[row];
    self.bankBranchCardField.text = self.baseBankFilterModel.name;
}

#pragma mark - textFiledDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.bankBranchCardField) {
//        if (self.pickerView != nil) return NO;
//        [self requestBankArrayData];
//        return NO;
    }else if(textField == self.userNameField || textField == self.bankCardNumberField){
        if ([self.nextButton isSelected] && textField == self.bankCardNumberField) {
            return NO;
        }
//        if (self.pickerView != nil) {
//            [self dismissPickerView];
//        }
        return YES;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //卡号输入框
    if (textField == self.bankCardNumberField) {
        NSInteger length = self.bankCardNumberString.length;
        if (self.bankCardNumberString.length >= 4) {
            length = self.bankCardNumberString.length + (self.bankCardNumberString.length - 1)/4;
        }
        NSScanner *scanner = [NSScanner scannerWithString:string];
        int val;
        BOOL isBankNumberIsNumber = [scanner scanInt:&val] && [scanner isAtEnd];
        NSInteger textLength = self.bankCardNumberString.length;
        if ([string isEqualToString:@""]) {
            if (textLength > 0) {
                [self.bankCardNumberString deleteCharactersInRange:NSMakeRange(textLength - 1, 1)];
            }
        }else if(!isBankNumberIsNumber || !(length == range.location)){
                return NO;
        }else{
            if(textLength + 1 > 20){
                [Toast makeToast:@"您输入的卡号过长" duration:1.0 position:@"center"];
                return NO;
            }else{
                [self.bankCardNumberString appendString:string];
//                [self.bankCardNumberString insertString:string atIndex:location];
            }
        }
        NSMutableString *mutableString = [NSMutableString string];
        int i = 0;
        textLength = self.bankCardNumberString.length;
        while (i < (textLength - 1)/4) {
            NSString *rangeString = [self.bankCardNumberString substringWithRange:NSMakeRange(i * 4, 4)];
            [mutableString appendString:[NSString stringWithFormat:@"%@ ", rangeString]];
            i++;
        }
        [mutableString appendString:[self.bankCardNumberString substringWithRange:NSMakeRange(i * 4, textLength - i * 4)]];
        self.bankCardNumberField.text = mutableString;
        if (mutableString.length == 0) {
            self.nextButton.userInteractionEnabled = NO;
            self.nextButton.backgroundColor = [Utils HexColor:0xe2e2e2 Alpha:1];
        }else{
            self.nextButton.userInteractionEnabled = YES;
            self.nextButton.backgroundColor = [Utils HexColor:0x333333 Alpha:1];
        }
        return NO;
    }else{
        NSMutableString *branchString = [NSMutableString stringWithString:self.bankBranchCardField.text];
        NSMutableString *userNameString = [NSMutableString stringWithString:self.userNameField.text];
        if ([string isEqualToString:@""]) {
            if (textField == self.bankBranchCardField) {
                [branchString deleteCharactersInRange:range];
            }else if(textField == self.userNameField){
                [userNameString deleteCharactersInRange:range];
            }
        }else{
            if (textField == self.bankBranchCardField) {
                [branchString appendString:string];
            }else if(textField == self.userNameField){
                [userNameString appendString:string];
            }
        }
        NSInteger length = MIN(branchString.length, userNameString.length);
        if (length == 0) {
            self.nextButton.userInteractionEnabled = NO;
            self.nextButton.backgroundColor = [Utils HexColor:0xe2e2e2 Alpha:1];
        }else{
            self.nextButton.userInteractionEnabled = YES;
            self.nextButton.backgroundColor = [Utils HexColor:0x333333 Alpha:1];
        }
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.bankCardNumberString deleteCharactersInRange:NSMakeRange(0, self.bankCardNumberString.length)];
    if (textField == self.bankCardNumberField && [self.nextButton isSelected]) {
        self.userNameField.text = @"";
        self.bankBranchCardField.text = @"";
        self.showContentList = NO;
    }
    self.nextButton.backgroundColor = [Utils HexColor:0xe2e2e2 Alpha:1];
    self.nextButton.userInteractionEnabled = NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    
//    return YES;
//}

#pragma mark -

- (IBAction)defalutButtonAction:(UIButton *)sender {
    if (![self isShowBackButton]) {
        return;
    }
    [self.defalutButton setSelected:![self.defalutButton isSelected]];
}

- (NSMutableString *)bankCardNumberString{
    if (!_bankCardNumberString) {
        _bankCardNumberString = [NSMutableString string];
    }
    return _bankCardNumberString;
}
@end
