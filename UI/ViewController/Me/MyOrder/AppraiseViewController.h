//
//  AppraiseViewController.h
//  Wefafa
//
//  Created by fafatime on 14-12-17.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

@interface AppraiseViewController : SBaseViewController/*UIViewController*/<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITextView *appraiseTV;
@property (weak, nonatomic) IBOutlet UIView *showStarView;
@property (retain,nonatomic)NSString *prodectid;
@property (retain,nonatomic)NSArray *orderArray;
@property (retain,nonatomic)NSDictionary *message;
@property (strong,nonatomic)OrderModel *messageOrderModel;

-(IBAction)tapStarBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *AppriseBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
- (IBAction)appriseBtnClick:(id)sender;
@end
