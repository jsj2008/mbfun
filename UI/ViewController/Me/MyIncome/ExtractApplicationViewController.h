//
//  ExtractApplicationViewController.h
//  Wefafa
//
//  Created by fafatime on 14-8-22.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtractApplicationViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    
}

@property (strong, nonatomic) IBOutlet UIView *headView;
- (IBAction)btnBackClick:(id)sender;
-(IBAction)doneBtnClick:(id)sender;
@property (strong,nonatomic)IBOutlet UILabel *upLabel;
@property (assign,nonatomic)IBOutlet UIButton *doneBtn;
@property (strong,nonatomic)IBOutlet UILabel *showCanLabel;
@property (strong,nonatomic)IBOutlet UITextField *moneyTextField;
@property (strong,nonatomic)IBOutlet UILabel *bankLabel;
@property (strong,nonatomic)IBOutlet UILabel *cardLabel;
@property (strong,nonatomic)IBOutlet UILabel *cardNameLabel;
@property (strong,nonatomic)IBOutlet UIView *showView;
@property (strong,nonatomic)IBOutlet UIScrollView *backScrollView;
@property (retain,nonatomic) NSDictionary *transDic;
@property (retain,nonatomic) NSArray *cardDicArray;
@property (retain,nonatomic) NSString *canUpMoney;
@end
