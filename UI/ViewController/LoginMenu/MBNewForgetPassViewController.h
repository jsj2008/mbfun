//
//  MBNewForgetPassViewController.h
//  Wefafa
//
//  Created by fafatime on 14/12/18.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNewForgetPassViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>{
    NSMutableString *retrievid;
    NSString *mobile;
}
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIView *viewHead;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtValidCode;

//获取验证码
@property (strong, nonatomic) IBOutlet UIButton *btnGetValidCode;
- (IBAction)btnGetValidCodeClick:(id)sender;
- (IBAction)nextBtnClick:(id)sender;

@property (nonatomic,strong)NSString* defaultPhone;
@end
