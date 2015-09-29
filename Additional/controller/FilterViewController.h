//
//  FilterViewController.h
//  newdesigner
//
//  Created by Miaoz on 14/10/22.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>


#define showPrice @"showPrice"
#define showClass @"showClass"
#define showColor @"showColor"
#define showBrand @"showBrand"
#define showFilterStr @"showFilterStr"

//对象vo
#define focusMemoryPrice @"focusMemoryPrice"
#define focusMemoryClass @"focusMemoryClass"
#define focusMemoryColor @"focusMemoryColor"
#define focusMemoryBrand @"focusMemoryBrand"


@class GoodCategoryObj;


typedef void (^FilterVCBlock) (id sender);

@interface FilterViewController : UIViewController
@property(nonatomic,strong)GoodCategoryObj *goodCategoryObj;
@property(nonatomic,copy)FilterVCBlock myblock;
@property(nonatomic,strong)NSString *descContent;


-(void)filterVCBlockWithpostDic:(FilterVCBlock) block;


- (IBAction)filterPrice1ButtonClickEvent:(id)sender;
- (IBAction)filterPrice2ButtonClickEvent:(id)sender;
- (IBAction)filterPrice3ButtonClickEvent:(id)sender;
- (IBAction)filterPrice4ButtonClickEvent:(id)sender;
- (IBAction)filterPrice5ButtonClickEvent:(id)sender;

- (IBAction)filterClassifyButtonClickEvent:(id)sender;
- (IBAction)filterBrandButtonClickEvent:(id)sender;
- (IBAction)filterColorButtonClickEvent:(id)sender;
- (IBAction)filterCleanButtonClickEvent:(id)sender;
- (IBAction)filterOKButtonClickEvent:(id)sender;
- (IBAction)leftBarButtonItemClickevent:(id)sender;
- (IBAction)rightBarButtonItemClickevent:(id)sender;

@end
