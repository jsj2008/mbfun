//
//  SubClassBaseViewController.h
//  Designer
//
//  Created by Jiang on 1/20/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubClassBaseViewController :SBaseViewController /*UIViewController*/

- (void)setTitle:(NSString *)title;
- (void)setLeftButton:(NSString*)title target:(id)target selector:(SEL)selector;
- (void)setLeftButtonImage:(NSString*)imageName target:(id)target selector:(SEL)selector;
- (void)setRightButton:(NSString*)title target:(id)target selector:(SEL)selector;
- (void)setRightButtonImage:(NSString*)imageName target:(id)target selector:(SEL)selector;

@end
