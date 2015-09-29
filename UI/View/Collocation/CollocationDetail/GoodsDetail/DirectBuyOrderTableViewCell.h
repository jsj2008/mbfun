//
//  DirectBuyOrderTableViewCell.h
//  Wefafa
//
//  Created by fafatime on 14-10-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EACellListView.h"
#import "UIStepperNumberField.h"
#import "UIUrlImageView.h"
#import "MBDirectBuyViewController.h"

@interface DirectBuyOrderTableViewCell : UITableViewCell
{
    
    NSMutableArray *_productInfoList;

}

@property (nonatomic,strong) NSMutableArray *productInfoList;
@property (weak, nonatomic) IBOutlet UIUrlImageView *colloctionPic;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsLableLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsColorLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsSizeLb;
@property (weak, nonatomic) IBOutlet EACellListView *goodsColorView;
@property (weak, nonatomic) IBOutlet EACellListView *goodsSizeView;
@property (weak, nonatomic) IBOutlet UIStepperNumberField *goodsNumFiled;

@property (nonatomic,copy)NSDictionary *collocaInfo;
@property (strong, nonatomic) IBOutlet UILabel *lbTip;

@property (strong, nonatomic) NSDictionary *functionXML;//上下级过渡
@property (strong, nonatomic) NSDictionary *rootXML;

@property (strong,nonatomic) NSString *colorid; //selected
@property (strong,nonatomic) NSString *sizeid;
@property (strong,nonatomic) NSString *productid;
@property (strong,nonatomic) NSString *goodsNum;
@property (assign,nonatomic) int row;
@property (assign,nonatomic) MBDirectBuyViewController *mainview;

-(void)selectColor:(NSString *)color;
-(void)selectSize:(NSString *)size;
-(void)setGoodsNumber:(NSString *)numstr;
- (IBAction)textValueChanged:(id)sender;


@end
