//
//  EditAddressViewController.h
//  Wefafa
//
//  Created by fafatime on 14-9-26.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditAddressViewControllerDelegate <NSObject>

-(void)userInfoValueChanged:(NSString*)sender;

@end
@interface EditAddressViewController :SBaseViewController/* UIViewController*/<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
//    int _current;
//    int click;
//    int k;
    
}
@property (assign, nonatomic) id <EditAddressViewControllerDelegate> delegate;
@property (retain, nonatomic) NSString *nameStr;
@property (retain, nonatomic) NSString *countryStr;
@property (retain, nonatomic) NSString *cityStr;
@property (retain, nonatomic) NSString *provinceStr;
@property (assign, nonatomic) UIKeyboardType keyboardType;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (retain,nonatomic ) NSString *detailStr;
@property (strong, nonatomic) IBOutlet UITextField *editTextField;
@property (strong, nonatomic) IBOutlet UITableView *editTableView;
@property (strong, nonatomic) IBOutlet UITableView *detailCityTableView;
@property (strong, nonatomic) IBOutlet UITableView *lastCityTableView;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
-(IBAction)doneBtn:(id)sender;

@end
