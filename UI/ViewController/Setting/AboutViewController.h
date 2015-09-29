//
//  AboutViewController.h
//  FaFa
//
//  Created by mac on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const UPDATE_URL;

@interface AboutViewController :SBaseViewController/* UIViewController*/
@property (retain, nonatomic) IBOutlet UIButton *btnCheckVersion;
@property (retain, nonatomic) IBOutlet UILabel *lbVersion;

@property (retain, nonatomic) IBOutlet UILabel *severTelephone;
@property (retain, nonatomic) IBOutlet UILabel *rightInformation;
@property (strong, nonatomic) IBOutlet UIView *viewHead;


- (IBAction)btnCheckVersionClick:(id)sender;
- (IBAction)btnService_OnTouchUpInside:(id)sender;
+ (void)checkAppUpdate:(NSString*)appInfo delegate:(id)del;

@end
