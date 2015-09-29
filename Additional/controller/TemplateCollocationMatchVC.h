//
//  TemplateCollocationMatchVC.h
//  Wefafa
//
//  Created by Miaoz on 15/3/17.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TemplateElement.h"
@interface TemplateCollocationMatchVC : BaseViewController
@property(nonatomic,strong)TemplateElement *templateElement;

//外部调用的时候需要
-(void)callBackMyViewControllerWithServicemubantemplateElement:(id)sender;
-(void)callBackMyViewControllerWithServiceCollocationInfo:(id)sender;
@end
