//
//  BuyCollocationViewController.h
//  Wefafa
//
//  Created by mac on 14-11-8.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUrlImageView.h"
#import "EACellListView.h"
#import "UIStepperNumberField.h"
#import "AttendCustomButton.h"
#import "EAImageListView.h"

@interface BuyCollocationViewController : UIViewController<UIUrlImageViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *goodsInfoList;
    NSMutableArray *goodsSelectedList;//商品款选择信息列表
//    NSMutableArray *goodsStockArray;
    
//    NSMutableArray *productInfoList;
    BOOL isInit;
    
    id parentView;
    SEL returnParentViewAction;
    SEL nextParentViewAction;
    NSInteger SCROLLHEIGHT;
    float product_price;
}
@property (weak, nonatomic) IBOutlet UIView *viewHead;
@property (weak, nonatomic) IBOutlet UIView *viewCenter;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (assign, nonatomic) ATTEND_CLICK_SHOW_VIEW_TYPE showViewType;
@property (nonatomic,strong) NSDictionary *data;
@property (nonatomic,strong) NSMutableArray *goodsArray;
@property (nonatomic,strong) NSString *titleStr;
@property (weak, nonatomic) IBOutlet EAImageListView *viewImageList;
@property (weak, nonatomic) IBOutlet UIImageView *imageLine1;
@property (weak, nonatomic) IBOutlet UILabel *lbGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *lbGoodsCode;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbSumT;
@property (weak, nonatomic) IBOutlet EACellListView *sizeListView;
@property (weak, nonatomic) IBOutlet EACellListView *colorListView;
@property (weak, nonatomic) IBOutlet UILabel *lbStoreNum;
@property (weak, nonatomic) IBOutlet UIStepperNumberField *numberStepper;
@property (weak, nonatomic) IBOutlet UILabel *lbTip;
@property (weak, nonatomic) IBOutlet UILabel *lbSum;
@property (weak, nonatomic) IBOutlet UILabel *lbOriginSum;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;


@property (nonatomic,strong) NSString *shareUserId;
@property (weak, nonatomic) IBOutlet UIScrollView *showScrollView;

- (IBAction)btnCloseClick:(id)sender;
- (IBAction)btnBuyClick:(id)sender;
- (IBAction)textValueChanged:(id)sender;
- (IBAction)textEditingDidEnd:(id)sender;

//-(void)updateGoodsSelected:(id)cell;
- (void)setParentView:(id)pview returnAction:(SEL)returnAction nextAction:(SEL)nextAction;
-(void)goodsArrayLoadData:(NSMutableArray *)goodsArr;

@end
