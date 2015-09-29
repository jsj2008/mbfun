//
//  ScanViewController.h
//  Wefafa
//
//  Created by fafatime on 14/12/3.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

#define SCANVIEW_EdgeTop 40.0
#define SCANVIEW_EdgeLeft 50.0
#define TINTCOLOR_ALPHA 0.2  //浅色透明度
#define DARKCOLOR_ALPHA 0.5  //深色透明度

@interface ScanViewController :SBaseViewController/* UIViewController*/<ZBarReaderViewDelegate,ZBarReaderDelegate>
{
    UIView *_QrCodeline;
    NSTimer *_timer;
    
    //设置扫描画面
    UIView *_scanView;
    ZBarReaderView *_readerView;
}
@property (weak, nonatomic) IBOutlet UIView *naviView;
- (IBAction)backBtnClick:(id)sender;
@property (nonatomic,strong)NSString *scanTypeChat;



@end
