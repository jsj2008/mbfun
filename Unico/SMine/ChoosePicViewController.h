//
//  ChoosePicViewController.h
//  Wefafa
//
//  Created by metesbonweios on 15/7/27.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^clickChoose) (NSString  *picUrl,UIImage *chooseImg);
@interface ChoosePicViewController : SBaseViewController
//回调单击方法
@property(nonatomic,strong)clickChoose clickPic;
@end
