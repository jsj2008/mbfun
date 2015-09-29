//
//  MBToastHud.m
//  Wefafa
//
//  Created by Miaoz on 15/7/1.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "MBToastHud.h"

@implementation MBToastHud

@synthesize interaction, window, background, hud, spinner, image, label,sandwichView;


+ (MBToastHud *)shared

{
	static dispatch_once_t once = 0;
	static MBToastHud *toastHud;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dispatch_once(&once, ^{ toastHud = [[MBToastHud alloc] init]; });
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return toastHud;
}


+ (void)dismiss

{
	[[self shared] hudHide];
}

+ (void)show:(NSString *)status image:(UIImage *)img spin:(BOOL)spin hide:(BOOL)hide Interaction:(BOOL)Interaction{

    [self shared].interaction = Interaction;
    [[self shared] hudMake:status image:img spin:spin hide:hide];
}


- (id)init

{
	self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
	
	id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
	
	if ([delegate respondsToSelector:@selector(window)])
		window = [delegate performSelector:@selector(window)];
	else window = [[UIApplication sharedApplication] keyWindow];
	
    background = nil; hud = nil; spinner = nil; image = nil; label = nil; sandwichView = nil;
	
	self.alpha = 0;
	

	return self;
}


- (void)hudMake:(NSString *)status image:(UIImage *)img spin:(BOOL)spin hide:(BOOL)hide

{
	[self hudCreate];
	
	label.text = status;
	label.hidden = (status == nil) ? YES : NO;
	
	image.image = img;
	image.hidden = (img == nil) ? YES : NO;
	
	if (spin) [spinner startAnimating]; else [spinner stopAnimating];
	
	[self hudSize];
	[self hudPosition:nil];
	[self hudShow];
	
	if (hide) [NSThread detachNewThreadSelector:@selector(timedHide) toTarget:self withObject:nil];
}


- (void)hudCreate

{
	if (hud == nil)
	{
        
		hud = [[UIView alloc] initWithFrame:CGRectZero];
//		hud.translucent = NO;
        hud.alpha = 0.8;
		hud.backgroundColor = HUD_BACKGROUND_COLOR;
		hud.layer.cornerRadius = 10;
		hud.layer.masksToBounds = YES;
        
		[self registerNotifications];
	}
    
    if (sandwichView == nil) {
        sandwichView = [[UIView alloc] initWithFrame:CGRectZero];
//        		hud.translucent = NO;
        sandwichView.alpha = 1.0;
        sandwichView.backgroundColor = [UIColor clearColor];
        sandwichView.layer.cornerRadius = 10;
        sandwichView.layer.masksToBounds = YES;
    }
	
	if (hud.superview == nil)
	{
		if (interaction == NO)
		{
			background = [[UIView alloc] initWithFrame:window.frame];
			background.backgroundColor = HUD_WINDOW_COLOR;
			[window addSubview:background];
			[background addSubview:hud];
            [background addSubview:sandwichView];
		}
        else{
            [window addSubview:hud];
            [window addSubview:sandwichView];
        }
	}
	
	if (spinner == nil)
	{
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinner.color = HUD_SPINNER_COLOR;
		spinner.hidesWhenStopped = YES;
	}
	if (spinner.superview == nil) [sandwichView addSubview:spinner];
	
	if (image == nil)
	{
		image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
	}
	if (image.superview == nil) [sandwichView addSubview:image];
	
	if (label == nil)
	{
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = HUD_STATUS_FONT;
		label.textColor = HUD_STATUS_COLOR;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		label.numberOfLines = 0;
	}
	if (label.superview == nil) [sandwichView addSubview:label];
}


- (void)registerNotifications

{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:)
												 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardDidShowNotification object:nil];
}


- (void)hudDestroy

{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[label removeFromSuperview];		label = nil;
	[image removeFromSuperview];		image = nil;
	[spinner removeFromSuperview];		spinner = nil;
	[hud removeFromSuperview];			hud = nil;
	[background removeFromSuperview];	background = nil;
    [sandwichView removeFromSuperview]; sandwichView = nil;
}


- (void)hudSize

{
	CGRect labelRect = CGRectZero;
	CGFloat hudWidth = HUDWIDTH, hudHeight = HUDHEIGHT;
	
	if (label.text != nil)
	{
		NSDictionary *attributes = @{NSFontAttributeName:label.font};
		NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
		labelRect = [label.text boundingRectWithSize:CGSizeMake(200, 300) options:options attributes:attributes context:NULL];

		labelRect.origin.x = 12;
		labelRect.origin.y = 55;//66

        
        hudWidth = labelRect.size.width + 24;
        hudHeight = labelRect.size.height + 80;

		if (hudWidth <= 180)
		{
			hudWidth = HUDWIDTH;
            hudHeight = HUDHEIGHT;
			labelRect.origin.x = 0;
			labelRect.size.width = HUDWIDTH -10;
        }
	}
	
	hud.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
    sandwichView.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
	
	CGFloat imagex = hudWidth/2;
	CGFloat imagey = (label.text == nil) ? hudHeight/2 : 30;//36
	image.center = spinner.center = CGPointMake(imagex, imagey);
	
	label.frame = labelRect;
}


- (void)hudPosition:(NSNotification *)notification

{
	CGFloat heightKeyboard = 0;
	NSTimeInterval duration = 0;
	
	if (notification != nil)
	{
		NSDictionary *info = [notification userInfo];
		CGRect keyboard = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
		duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
		if ((notification.name == UIKeyboardWillShowNotification) || (notification.name == UIKeyboardDidShowNotification))
		{
			heightKeyboard = keyboard.size.height;
		}
	}
	else heightKeyboard = [self keyboardHeight];
	
	CGRect screen = [UIScreen mainScreen].bounds;
	CGPoint center = CGPointMake(screen.size.width/2, (screen.size.height-heightKeyboard)/2);
	
	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		hud.center = CGPointMake(center.x, center.y);
        sandwichView.center =  CGPointMake(center.x, center.y);
	} completion:nil];
	
	if (background != nil) background.frame = window.frame;
}


- (CGFloat)keyboardHeight

{
	for (UIWindow *testWindow in [[UIApplication sharedApplication] windows])
	{
		if ([[testWindow class] isEqual:[UIWindow class]] == NO)
		{
			for (UIView *possibleKeyboard in [testWindow subviews])
			{
				if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"])
				{
					return possibleKeyboard.bounds.size.height;
				}
				else if ([[possibleKeyboard description] hasPrefix:@"<UIInputSetContainerView"])
				{
					for (UIView *hostKeyboard in [possibleKeyboard subviews])
					{
						if ([[hostKeyboard description] hasPrefix:@"<UIInputSetHost"])
						{
							return hostKeyboard.frame.size.height;
						}
					}
				}
			}
		}
	}
	return 0;
}


- (void)hudShow

{
	if (self.alpha == 0)
	{
		self.alpha = 1.0f;

		hud.alpha = 0;
        sandwichView.alpha = 0;
		hud.transform = CGAffineTransformScale(hud.transform, 1.4, 1.4);
        sandwichView.transform = CGAffineTransformScale(sandwichView.transform, 1.4, 1.4);
		NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut;
		[UIView animateWithDuration:0.15 delay:0 options:options animations:^{
			hud.transform = CGAffineTransformScale(hud.transform, 1/1.4, 1/1.4);
			hud.alpha = 0.8;
            sandwichView.transform = CGAffineTransformScale(sandwichView.transform, 1/1.4, 1/1.4);
            sandwichView.alpha = 1.0;
		} completion:nil];
	}
}


- (void)hudHide

{
	if (self.alpha == 1.0f)
	{
		NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;
		[UIView animateWithDuration:0.15 delay:0 options:options animations:^{
			hud.transform = CGAffineTransformScale(hud.transform, 0.7, 0.7);
			hud.alpha = 0;
            
            sandwichView.transform = CGAffineTransformScale(sandwichView.transform, 0.7, 0.7);;

		}
		completion:^(BOOL finished) {
			[self hudDestroy];
			self.alpha = 0;
		}];
	}
}


- (void)timedHide

{
	@autoreleasepool
	{
		double length = label.text.length;
		NSTimeInterval sleep = length * 0.04 + 1.0;
		[NSThread sleepForTimeInterval:sleep];

		dispatch_async(dispatch_get_main_queue(), ^{
			[self hudHide];
		});
	}
}

/******
 
 
 
 + (void)show:(NSString *)status;
 + (void)show:(NSString *)status Interaction:(BOOL)Interaction;
 + (void)showSuccess:(NSString *)status;
 + (void)showSuccess:(NSString *)status Interaction:(BOOL)Interaction;
 + (void)showError:(NSString *)status;
 + (void)showError:(NSString *)status Interaction:(BOOL)Interaction;
 
 + (void)show:(NSString *)status
 
 {
	[self shared].interaction = YES;
	[[self shared] hudMake:status image:nil spin:YES hide:NO];
 }
 
 
 + (void)show:(NSString *)status Interaction:(BOOL)Interaction
 
 {
	[self shared].interaction = Interaction;
	[[self shared] hudMake:status image:nil spin:YES hide:NO];
 }
 
 
 + (void)showSuccess:(NSString *)status
 
 {
	[self shared].interaction = YES;
	[[self shared] hudMake:status image:HUD_IMAGE_SUCCESS spin:NO hide:YES];
 }
 
 
 + (void)showSuccess:(NSString *)status Interaction:(BOOL)Interaction
 
 {
	[self shared].interaction = Interaction;
	[[self shared] hudMake:status image:HUD_IMAGE_SUCCESS spin:NO hide:YES];
 }
 
 
 + (void)showError:(NSString *)status
 
 {
	[self shared].interaction = YES;
	[[self shared] hudMake:status image:HUD_IMAGE_ERROR spin:NO hide:YES];
 }
 
 
 + (void)showError:(NSString *)status Interaction:(BOOL)Interaction
 
 {
	[self shared].interaction = Interaction;
	[[self shared] hudMake:status image:HUD_IMAGE_ERROR spin:NO hide:YES];
 }
 
*****/

@end
