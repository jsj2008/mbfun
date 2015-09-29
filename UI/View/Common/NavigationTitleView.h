//
//  NavigationTitleView.h
//  Wefafa
//
//  Created by mac on 14-9-23.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationTitleView : UIView
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnOk;
@property (strong, nonatomic) IBOutlet UIImageView *imageLogo;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imageLine;

- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnOkClick:(id)sender;
- (IBAction)btnMenuClick:(id)sender;

-(void)createTitleView:(CGRect)frame delegate:(id)delegate selectorBack:(SEL)selectorBack selectorOk:(SEL)selectorOk selectorMenu:(SEL)selectorMenu;

@end
