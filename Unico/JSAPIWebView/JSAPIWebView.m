//
//  JSAPIWebView.m
//  Wefafa
//
//  Created by chencheng on 15/9/6.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "JSAPIWebView.h"


@interface JSFunNativeAPI : NSObject

@property(copy, readwrite, nonatomic)NSString *jsFunName;
@property(strong, readwrite, nonatomic)id target;
@property(assign, readwrite, nonatomic)SEL action;

@end

@implementation JSFunNativeAPI

@end


#pragma mark - 保护成员

@interface JSAPIWebView()<UIWebViewDelegate>
{
    id <UIWebViewDelegate> _backupDelegate;
    
    JSContext *_jsContext;
    
    NSMutableArray *_jsFunNativeAPIMutableArray;
}

@end


@implementation JSAPIWebView


#pragma mark - 属性

-(void)setDelegate:(id<UIWebViewDelegate>)delegate
{
    if (delegate != self)
    {
        _backupDelegate = delegate;
    }
    else
    {
        [super setDelegate:delegate];
    }
}

- (id<UIWebViewDelegate>)delegate
{
    return _backupDelegate;
}

#pragma mark - 公共接口

- (void)setTarget:(id)target action:(SEL)action forJSFunName:(NSString *)jsFunName
{
    JSFunNativeAPI *jsFunNativeAPI = nil;
    
    for (int i=0; i<[_jsFunNativeAPIMutableArray count]; i++)
    {
        JSFunNativeAPI *temJSFunNativeAPI = [_jsFunNativeAPIMutableArray objectAtIndex:i];
        
        if ([jsFunNativeAPI.jsFunName isEqualToString:jsFunName])
        {
            jsFunNativeAPI = temJSFunNativeAPI;
            break;
        }
    }
    
    if (jsFunNativeAPI == nil)
    {
        jsFunNativeAPI = [[JSFunNativeAPI alloc] init];
        
        jsFunNativeAPI.target = target;
        jsFunNativeAPI.action = action;
        jsFunNativeAPI.jsFunName = jsFunName;
        
        [_jsFunNativeAPIMutableArray addObject:jsFunNativeAPI];
    }
    else
    {
        jsFunNativeAPI.target = target;
        jsFunNativeAPI.action = action;
    }
}

- (JSValue *)evaluateJSFun:(NSString *)jsFun
{
    return [_jsContext evaluateScript:jsFun];
}


#pragma mark - 初始化

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.delegate = self;
        
        _jsFunNativeAPIMutableArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.delegate = self;
        
        _jsFunNativeAPIMutableArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)initJSContext
{
    _jsContext = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    _jsContext.exceptionHandler = ^(JSContext *jsContext, JSValue *exception) {
        NSLog(@"jsContext : %@  exception : %@", jsContext, exception);
        jsContext.exception = exception;
    };
    
    for (JSFunNativeAPI *jsFunNativeAPI in _jsFunNativeAPIMutableArray)
    {
        [_jsContext setObject:(NSString *)^(){
            
            NSMethodSignature *methodSignature = [jsFunNativeAPI.target methodSignatureForSelector:jsFunNativeAPI.action];
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            
            invocation.target = jsFunNativeAPI.target;
            invocation.selector = jsFunNativeAPI.action;
            
            NSArray *argArray = [JSContext currentArguments];
            
            for (int i=0; i<[argArray count]; i++)
            {
                id arg = [argArray objectAtIndex:i];
                
                [invocation setArgument:&arg atIndex:i+2];
            }
            
            [invocation invoke];
            
            NSString *ret = nil;
            
            const char *returnType = methodSignature.methodReturnType;
            
            if(!strcmp(returnType, @encode(NSString*)))//返回值为NSString*
            {
                [invocation getReturnValue:&ret];
            }
            
            
            if (ret == nil)
            {
                return @"";
            }
            else if ([ret isKindOfClass:[NSString class]])
            {
                return ret;
            }
            else
            {
                return @"";
            }
            
            
        } forKeyedSubscript:jsFunNativeAPI.jsFunName];
    }
    
    //id userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
}


#pragma mark - 外抛UIWebViewDelegate接口

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (_backupDelegate != nil
        && [_backupDelegate respondsToSelector:@selector(webView: shouldStartLoadWithRequest: navigationType:)])
    {
        return [_backupDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (_backupDelegate != nil
        && [_backupDelegate respondsToSelector:@selector(webViewDidStartLoad:)])
    {
        [_backupDelegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self initJSContext];
    
    if (_backupDelegate != nil
        && [_backupDelegate respondsToSelector:@selector(webViewDidFinishLoad:)])
    {
        [_backupDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (_backupDelegate != nil
        && [_backupDelegate respondsToSelector:@selector(webView: didFailLoadWithError:)])
    {
        [_backupDelegate webView:webView didFailLoadWithError:error];
    }
}

@end
