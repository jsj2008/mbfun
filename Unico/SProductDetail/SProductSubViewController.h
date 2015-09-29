//
//  SProductSubViewController.h
//  Wefafa
//
//  Created by Jiang on 15/9/9.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"
#import "SProductDetailModel.h"
#import "SProductSelectedModuleView.h"
#import "ProductCollocationView.h"
@protocol SProductSubViewControllerDelegate <NSObject>

- (void)sproductSubVcDismissWithTimer:(NSTimeInterval)timer isReturnTop:(BOOL)returnTop;

@end

@interface SProductSubViewController : SBaseViewController
@property (nonatomic, weak) id<SProductSubViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *productCode;
@property (nonatomic, strong) SProductDetailModel *contentModel;
@property (nonatomic, strong) SProductSelectedModuleView *selectedModuleView;
@property (nonatomic, strong) ProductCollocationView *collocationView;
@property (nonatomic, strong) UIViewController *target;
@property(strong, readwrite, nonatomic) void(^back)(void);
@property (nonatomic, assign) BOOL isHide; // 隐藏导航条

@end
