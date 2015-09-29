//
//  FontTextEditViewController.h
//  Wefafa
//
//  Created by Miaoz on 15/1/16.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FontTextEditVCBlock) (id sender);

@interface FontTextEditViewController : UIViewController
@property(nonatomic,copy)FontTextEditVCBlock myblock;
@property(nonatomic,strong)UIImage *backGroundImage;
- (IBAction)leftBarButtonItemClickevent:(UIBarButtonItem *)sender;
- (IBAction)rightBarButtonItemClickevent:(UIBarButtonItem *)sender;

-(void)fontTextEditVCBlockWithGesturesImgView:(FontTextEditVCBlock) block;
@end
