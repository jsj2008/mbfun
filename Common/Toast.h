//
//  Toast.h
//  Toast
//
//  Created by fafa  on 13-6-17.
//
//

#import <Foundation/Foundation.h>

@interface Toast : NSObject

// each makeToast method creates a view and displays it as toast
+ (void)makeToast:(NSString *)message;
+ (void)makeToast:(NSString *)message mask:(BOOL)isMask;
+ (void)makeToastSuccess:(NSString *)message;
+ (void)makeToastSuccess:(NSString *)message mask:(BOOL)isMask;
+ (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position;
+ (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title;
+ (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title image:(UIImage *)image;
+ (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image;

// displays toast with an activity spinner
+ (void)makeToastActivity;
+ (void)makeToastActivity:(NSString *)message;
+ (void)makeToastActivity:(NSString *)message hasMusk:(BOOL)hasMusk;
+ (void)makeToastActivity:(id)position message:(NSString *)message;
+ (void)makeToastActivity:(id)position message:(NSString *)message hasMusk:(BOOL)hasMusk;
+ (void)hideToastActivity;

// the showToast methods display any view as toast
+ (void)showToast:(UIView *)toast;
+ (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point;

@end
