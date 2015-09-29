//
//  Toast.m
//  Toast
//
//  Created by fafa  on 13-6-17.
//
//

#import "Toast.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "KVNProgress.h"

/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat CSToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat CSToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat CSToastHorizontalPadding   = 10.0;
static const CGFloat CSToastVerticalPadding     = 10.0;
static const CGFloat CSToastCornerRadius        = 10.0;
static const CGFloat CSToastOpacity             = 0.8;
static const CGFloat CSToastFontSize            = 16.0;
static const CGFloat CSToastMaxTitleLines       = 0;
static const CGFloat CSToastMaxMessageLines     = 0;
static const CGFloat CSToastFadeDuration        = 0.2;

// shadow appearance
static const CGFloat CSToastShadowOpacity       = 0.8;
static const CGFloat CSToastShadowRadius        = 6.0;
static const CGSize  CSToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    CSToastDisplayShadow       = YES;

// display duration and position
static const CGFloat CSToastDefaultDuration     = 1.0;
static const NSString * CSToastDefaultPosition  = @"center";

// image view size
static const CGFloat CSToastImageViewWidth      = 80.0;
static const CGFloat CSToastImageViewHeight     = 80.0;

// activity
static const NSString * CSToastActivityDefaultPosition = @"center";
static const NSString * CSToastActivityViewKey  = @"CSToastActivityViewKey";

@interface Toast (ToastPrivate)

+ (CGPoint)centerPointForPosition:(id)position withToast:(UIView *)toast;
+ (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image;
+ (UIView *)viewForMessage:(NSString *)message title:(NSString *)title imageOrActivity:(id)imageOrActivity;

@end


@implementation Toast

#pragma mark - Toast Methods

+ (void)makeToast:(NSString *)message {
//    [self makeToast:message duration:CSToastDefaultDuration position:CSToastDefaultPosition];
    [KVNProgress showErrorWithStatus:message];
}

+ (void)makeToast:(NSString *)message mask:(BOOL)isMask{
    [KVNProgress showErrorWithParameters:@{KVNProgressViewParameterStatus: message,
                                           KVNProgressViewParameterFullScreen: @(isMask)}];
}

+ (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position {
//    UIView *toast = [self viewForMessage:message title:nil image:nil];
    [KVNProgress showErrorWithStatus:message];
}

+ (void)makeToastSuccess:(NSString *)message{
    [KVNProgress showSuccessWithParameters:@{KVNProgressViewParameterStatus: message,
                                             KVNProgressViewParameterFullScreen: @(NO)}];
}

+ (void)makeToastSuccess:(NSString *)message mask:(BOOL)isMask{
    [KVNProgress showSuccessWithParameters:@{KVNProgressViewParameterStatus: message,
                                             KVNProgressViewParameterFullScreen: @(isMask)}];
}

+ (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title {
    UIView *toast = [self viewForMessage:message title:title image:nil];
    [self showToast:toast duration:interval position:position];
}

+ (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:nil image:image];
    [self showToast:toast duration:interval position:position];
}

+ (void)makeToast:(NSString *)message duration:(CGFloat)interval  position:(id)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:title image:image];
    [self showToast:toast duration:interval position:position];
}

+ (void)showToast:(UIView *)toast {
    [self showToast:toast duration:CSToastDefaultDuration position:CSToastDefaultPosition];
}

+ (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point {
    __block UIWindow *win = [[UIWindow alloc] init];
    win.frame = toast.frame;
    win.center = [self centerPointForPosition:point withToast:toast];
    win.windowLevel = UIWindowLevelNormal + 1.0f;
    win.hidden = NO;

    toast.alpha = 1.0;
    [win addSubview:toast];

    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:CSToastFadeDuration
                                               delay:interval
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              toast.alpha = 0.0;
                                            
                                              
                                          } completion:^(BOOL finished) {
                                              [toast removeFromSuperview];
#if ! __has_feature(objc_arc)
                                              [win release];
#else
                                              win = nil;
#endif
                                          }];
                     }];
}

#pragma mark - Toast Activity Methods

+ (void)makeToastActivity {
//    [self makeToastActivity:nil];
    [KVNProgress showWithStatus:@"正在帮您加载..."];
}

+ (void)makeToastActivity:(NSString *)message {
    [self makeToastActivity:message hasMusk:false];
    [KVNProgress showWithStatus:message];
}
+ (void)makeToastActivity:(NSString *)message hasMusk:(BOOL)hasMusk
{
//    [self makeToastActivity:CSToastActivityDefaultPosition message:message hasMusk:hasMusk];
    [KVNProgress showWithParameters:@{KVNProgressViewParameterStatus: message,
                                      KVNProgressViewParameterFullScreen: @(hasMusk)}];
}
+ (void)makeToastActivity:(id)position message:(NSString *)message
{
//    [self makeToastActivity:position message:message hasMusk:false];
    [KVNProgress showWithStatus:message];
}
+ (void)makeToastActivity:(id)position message:(NSString *)message hasMusk:(BOOL)hasMusk{
    // sanity
    if (message) {
        message = nil;
    }
    UIView *existingActivityWin = (UIWindow *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityWin != nil) return;
    
#if ! __has_feature(objc_arc)
    UIActivityIndicatorView *activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
#else
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
#endif
    [activityIndicatorView startAnimating];
    UIView *activityView = [self viewForMessage:message title:nil imageOrActivity:activityIndicatorView];
    
#if ! __has_feature(objc_arc)
    UIWindow *win = [[[UIWindow alloc] init] autorelease];
#else
    UIWindow *win = [[UIWindow alloc] init];
#endif
    if (hasMusk)
    {
        win.frame = [[UIScreen mainScreen] bounds];
        activityView.center = [self centerPointForPosition:position withToast:activityView];
        win.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
//        win.alpha = 0.8;
    }
    else
    {
        win.frame = activityView.frame;
        win.center = [self centerPointForPosition:position withToast:activityView];
    }
    win.windowLevel = UIWindowLevelNormal + 1.0f;
    win.hidden = NO;    
    [win addSubview:activityView];
    
    // associate ourselves with the activity view
    objc_setAssociatedObject (self, &CSToastActivityViewKey, win, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

+ (void)hideToastActivity {
    [KVNProgress dismiss];
//    UIWindow *existingActivityWin = (UIWindow *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
//    if (existingActivityWin != nil) {
//        [UIView animateWithDuration:CSToastFadeDuration
//                              delay:0.0
//                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
//                         animations:^{
//                             existingActivityWin.alpha = 0.0;
//                         } completion:^(BOOL finished) { 
//                             objc_setAssociatedObject (self, &CSToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//                         }];
//    }
}

#pragma mark - Private Methods

+ (CGPoint)centerPointForPosition:(id)point withToast:(UIView *)toast {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    if([point isKindOfClass:[NSString class]]) {
        // convert string literals @"top", @"bottom", @"center", or any point wrapped in an NSValue object into a CGPoint
        if([point caseInsensitiveCompare:@"top"] == NSOrderedSame) {
            return CGPointMake(bounds.size.width/2, (toast.frame.size.height / 2) + CSToastVerticalPadding);
        } else if([point caseInsensitiveCompare:@"bottom"] == NSOrderedSame) {
            return CGPointMake(bounds.size.width/2, (bounds.size.height - (toast.frame.size.height / 2)) - CSToastVerticalPadding);
        } else if([point caseInsensitiveCompare:@"center"] == NSOrderedSame) {
            return CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    NSLog(@"Warning: Invalid position for toast.");
    return [self centerPointForPosition:CSToastDefaultPosition withToast:toast];
}

+ (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    return [self viewForMessage:message title:title imageOrActivity:image];
}


+ (UIView *)viewForMessage:(NSString *)message title:(NSString *)title imageOrActivity:(id)imageOrActivity {
    // sanity
    if((message == nil) && (title == nil) && (imageOrActivity == nil)) return nil;
    
    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    UIActivityIndicatorView *activityIndicatorView = nil;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    // create the parent view
#if ! __has_feature(objc_arc)
    UIView *wrapperView = [[[UIView alloc] init] autorelease];
#else
    UIView *wrapperView = [[UIView alloc] init];
#endif
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = CSToastCornerRadius;
    
    if (CSToastDisplayShadow) {
        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = CSToastShadowOpacity;
        wrapperView.layer.shadowRadius = CSToastShadowRadius;
        wrapperView.layer.shadowOffset = CSToastShadowOffset;
    }
    
    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:CSToastOpacity];
    
    if(imageOrActivity != nil) {
        if ([imageOrActivity isKindOfClass:[UIImage class]])
        {
#if ! __has_feature(objc_arc)
            imageView = [[[UIImageView alloc] initWithImage:imageOrActivity] autorelease];
#else
            imageView = [[UIImageView alloc] initWithImage:imageOrActivity];
#endif
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = CGRectMake(CSToastHorizontalPadding, CSToastVerticalPadding, CSToastImageViewWidth, CSToastImageViewHeight);
        }
        else if ([imageOrActivity isKindOfClass:[UIActivityIndicatorView class]])
        {
            activityIndicatorView = imageOrActivity;
            activityIndicatorView.frame = CGRectMake(CSToastHorizontalPadding, CSToastVerticalPadding, activityIndicatorView.frame.size.width, activityIndicatorView.frame.size.height);
        }
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = CSToastHorizontalPadding;
    } else if(activityIndicatorView != nil) {
        imageWidth = activityIndicatorView.bounds.size.width;
        imageHeight = activityIndicatorView.bounds.size.height;
        imageLeft = CSToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil) {
#if ! __has_feature(objc_arc)
        titleLabel = [[[UILabel alloc] init] autorelease];
#else
        titleLabel = [[UILabel alloc] init];
#endif
        titleLabel.numberOfLines = CSToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:CSToastFontSize];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((bounds.size.width * CSToastMaxWidth) - imageWidth, bounds.size.height * CSToastMaxHeight);
        CGSize expectedSizeTitle = [title sizeWithFont:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode];
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
#if ! __has_feature(objc_arc)
        messageLabel = [[[UILabel alloc] init] autorelease];
#else
        messageLabel = [[UILabel alloc] init];
#endif
        messageLabel.numberOfLines = CSToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:CSToastFontSize];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((bounds.size.width * CSToastMaxWidth) - imageWidth, bounds.size.height * CSToastMaxHeight);
        CGSize expectedSizeMessage = [message sizeWithFont:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = CSToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    
    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
        messageTop = titleTop + titleHeight + CSToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    
    
    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (CSToastHorizontalPadding * 2)), (longerLeft + longerWidth + CSToastHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + CSToastVerticalPadding), (imageHeight + (CSToastVerticalPadding * 2)));
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        if (wrapperHeight > imageView.frame.size.height)
            imageView.center = CGPointMake(imageView.center.x, wrapperHeight/2);
        [wrapperView addSubview:imageView];
    } else if(activityIndicatorView != nil) {
        if (wrapperHeight > activityIndicatorView.frame.size.height)
            activityIndicatorView.center = CGPointMake(activityIndicatorView.center.x, wrapperHeight/2);
        [wrapperView addSubview:activityIndicatorView];
    }
    
    return wrapperView;
}
@end
