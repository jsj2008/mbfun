//
//  ImageDisplayViewController.h
//  FaFa
//
//  Created by mac on 12-11-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNSAttach;
@interface ImageDisplayViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate>
{
    NSString *imageFilePath;
    float orgScrollHeight;
    UIImage *imgSource;
    float minimumScale;
    
    float imgOrigWidth;
    float imgOrigHeight;
}

- (IBAction)delBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;


@property (retain, nonatomic) IBOutlet UIScrollView *scrollPage;
@property (retain, nonatomic) IBOutlet UIImageView *imgView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *tipLoading;
@property (strong, nonatomic) IBOutlet UIView *actView;
@property (strong, nonatomic) IBOutlet UIView *viewHead;

@property (strong,nonatomic)UIColor *backgroundColor;
@property (assign,nonatomic)NSInteger indexRow;

- (void)setImageFilePath:(NSString *)path;
- (void)setImageData:(UIImage *)img;
- (void)setImageData:(UIImage *)img attach:(SNSAttach*)attach;

@property (assign,nonatomic)BOOL isDelBtnShow;
@property (assign,nonatomic)NSString *isDelbtnHidden;


@end
