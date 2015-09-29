//
//  CommonZBarViewController.h
//  BanggoPhone
//
//  Created by yintengxiang on 14/12/4.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "ZBarReaderController.h"
#import "ZBarReaderView.h"
#import "ZBarReaderViewController.h"

/*  jonnywang 
typedef NS_ENUM(NSInteger, CodeType) {
    NoCode = 0,
    StoreCode = 1,
    GoodsCode = 2,
    DesignerCode = 3,
    DirectionsCode = 4
};
 */
typedef enum {

    comeFromeCloudStroe = 0,// 默认从云门店铺进入
    ComeFromOrderConfirm   // 确认订单页面
   
} WhereComeFrom;

@protocol CommonZBarViewControllerDelegate <NSObject>
@optional
- (void)showHomeFromZBar;
- (void)goToViewControllerWithGoodsSN:(NSString *)GoodsSN;
- (void)dissmissZbar:(NSDictionary*)responseJSON;

@end

@interface CommonZBarViewController : ZBarReaderViewController<ZBarReaderDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,assign) BOOL isZbar;
@property (nonatomic, assign) id<CommonZBarViewControllerDelegate> delegate;
//@property (nonatomic, assign) CodeType codeType;
@property (nonatomic,assign) WhereComeFrom whereComeFrom ;
- (void)buidViewforZbar;
- (void)showVi;
@end
