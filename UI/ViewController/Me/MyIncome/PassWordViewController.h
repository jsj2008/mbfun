//
//  PassWordViewController.h
//  Wefafa
//
//  Created by fafatime on 14-8-26.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassWordViewController : UIViewController<UITextFieldDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *upDoneBtn;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (retain, nonatomic) NSDictionary *transDic;
@property (retain, nonatomic) NSArray *cardDicArray;
@property (retain, nonatomic) NSString *canUpMoney;
- (IBAction)btnBackClick:(id)sender;
-(IBAction)updateBtnClick:(id)sender;
@end
