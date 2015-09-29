//
//  SubClassBaseViewController.h
//  Designer
//
//  Created by Jiang on 1/20/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubClassBaseViewController : UIViewController

- (void)setTitle:(NSString *)title;
- (void)setLeftButton:(NSString*)title target:(id)target selector:(SEL)selector;
- (void)setRightButton:(NSString*)title target:(id)target selector:(SEL)selector;

@end
