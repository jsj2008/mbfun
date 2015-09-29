//
//  LoadWebViewController.h
//  Wefafa
//
//  Created by mac on 13-9-22.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationTitleView.h"

@interface LoadWebViewController : UIViewController<UIWebViewDelegate>
{
    NSString *_titleString;
}
@property (strong, nonatomic) IBOutlet UIView *viewHead;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NavigationTitleView *titleView;

- (void)loadWebPageWithString:(NSString*)urlString;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *act;
@property (strong, nonatomic) IBOutlet UIView *actView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title;


@end
