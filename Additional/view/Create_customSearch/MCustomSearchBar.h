//
//  MCustomSearchBar.h
//  Wefafa
//
//  Created by Miaoz on 15/4/18.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCustomSearchBar : UISearchBar

#define kBgTextFieldImageName @"bg_cearte_search.png"

- (void)changeBarTextfieldWithColor:(UIColor *)color bgImageName:(NSString *)bgImageName;
- (void)changeBarCancelButtonWithColor:(UIColor *)textColor bgImageName:(NSString *)bgImageName;

@end
