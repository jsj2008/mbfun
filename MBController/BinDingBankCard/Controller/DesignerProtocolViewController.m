//
//  DesignerProtocol ViewController.m
//  Wefafa
//
//  Created by Jiang on 3/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "DesignerProtocolViewController.h"

@interface DesignerProtocolViewController ()
@property (weak, nonatomic) IBOutlet UITextView *showTextView;

@end

@implementation DesignerProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNavigationBar];
}

- (void)initNavigationBar{
    self.navigationController.navigationBarHidden = NO;
    [self setTitle:@"造型师合作协议"];
    [self setLeftButton:@"关闭" target:self selector:@selector(navigationBarLeft)];
    
    
    NSError *error;
    NSString *resourceName =[[NSBundle mainBundle] pathForResource:@"合作协议" ofType:@"txt"];
    NSString *txt=[NSString stringWithContentsOfFile:resourceName encoding:NSUTF8StringEncoding error:nil];
    if (error) {
        NSLog(@"读取文件出错：%@", error);
        return;
    }
    _showTextView.text=txt;
    
    
//    _textViewContent.text=txt;
}

- (void)navigationBarLeft{
    [super dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
