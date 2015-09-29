//
//  BingBankViewController.h
//  Wefafa
//
//  Created by fafatime on 14-8-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCheckBox.h"

#define tvcLabelFontSize 16
#define tvcTopHeight 15
#define tvcTopMinHeight 10
#define tvcCellHeight 40
#define tvcLabelWidth 100
#define tvcTextViewHeight 145

@interface BingBankViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    CCheckBox *ckBoxSelfM;
    CCheckBox *ckBoxSelfW;
}
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSString *titleName;
@property (retain, nonatomic) NSDictionary *transDic;

//@property (strong, nonatomic) IBOutlet UITextField *bankNameTextField;
//@property (strong, nonatomic) IBOutlet UITextField *bankNumTextField;
//@property (strong,nonatomic) IBOutlet UITextField *nameTextField;
//@property (weak,nonatomic) IBOutlet UIButton *upDoneBtn;
//@property (strong ,nonatomic) IBOutlet UIScrollView *backScrollView;

- (IBAction)btnBackClick:(id)sender;
//-(IBAction)doneBtnClick:(id)sender;
@end
