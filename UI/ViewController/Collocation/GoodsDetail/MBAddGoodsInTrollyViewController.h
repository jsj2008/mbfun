//
//  MBAddGoodsInTrollyViewController.h
//  Wefafa
//
//  Created by mac on 14-8-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendCustomButton.h"
#import "UIUrlImageView.h"
#import "EACellListView.h"
#import "UIStepperNumberField.h"
#import "MyShoppingTrollyGoodsTableViewCell.h"
@interface MBAddGoodsInTrollyViewController : UIViewController<UIUrlImageViewDelegate>
{
    id parentView;
    SEL returnParentViewAction;
    SEL nextParentViewAction;
    int SCROLLHEIGHT;
    NSMutableArray *productInfoList;
//    NSMutableArray *goodsStockList;
    float product_price;
    
    NSMutableArray *sizeEnableArray;
    NSMutableArray *colorEnableArray;

}

@property (strong, nonatomic) IBOutlet UIView *viewCenter;
@property (strong, nonatomic) IBOutlet UIView *viewHead;
@property (assign, nonatomic) ATTEND_CLICK_SHOW_VIEW_TYPE showViewType;
@property (weak, nonatomic) IBOutlet UILabel *lbSumT;
@property (strong, nonatomic) IBOutlet UIUrlImageView *imageGoods;
@property (strong, nonatomic) IBOutlet UILabel *lbGoodsName;
@property (strong, nonatomic) IBOutlet UILabel *lbGoodsPrice;
@property (strong, nonatomic) IBOutlet EACellListView *sizeListView;
@property (strong, nonatomic) IBOutlet EACellListView *colorListView;
@property (strong, nonatomic) IBOutlet UIStepperNumberField *numberStepper;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UILabel *lbGoodsNo;
@property (strong, nonatomic) IBOutlet UILabel *lbStoreNum;
@property (strong, nonatomic) IBOutlet UILabel *lbSum;
@property (strong, nonatomic) IBOutlet UILabel *lbOriginSum;

- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnCloseClick:(id)sender;
- (IBAction)btnNextClick:(id)sender;

@property(nonatomic,strong)MyShoppingTrollyGoodsData *getShoppingTrollyGoodsData;//上个VC传过来的

@property (strong,nonatomic) NSDictionary *goodsInfo; //fill data
//<load_product>
//<loadpara>lm_prod_cls_id</loadpara>
//<url>http://10.100.20.180:8015/ProductFilter?format=json</url>
//</load_product>
@property (strong, nonatomic) IBOutlet UILabel *lbTip;

@property (strong,nonatomic) NSString *colorid; //selected
@property (strong,nonatomic) NSString *sizeid;
@property (strong,nonatomic) NSString *productid;
@property (strong,nonatomic) NSString *titleStr;

- (IBAction)textValueChanged:(id)sender;
- (IBAction)textEditingDidEnd:(id)sender;
- (IBAction)textValueBeginChange:(id)sender;

- (void)setParentView:(id)pview returnAction:(SEL)action nextAction:(SEL)nextAction;
-(NSDictionary *)getProductWithColorId:(NSString *)colorId specId:(NSString *)specId;

@end
