//
//  FileReaderViewController.h
//  Wefafa
//
//  Created by mac on 14-7-30.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileReaderViewController :SBaseViewController /*UIViewController*/

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (strong, nonatomic) IBOutlet UIView *viewHead;
@property (strong, nonatomic) IBOutlet UITextView *textViewContent;
@property (strong, nonatomic) NSString *fileName;
@end
