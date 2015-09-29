//
//  MBDirectBuyViewController.h
//  Wefafa
//
//  Created by fafatime on 14-10-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBDirectBuyViewController : UIViewController

{
    NSMutableArray *goodsInfoList;
    NSMutableArray *goodsSelectedList;//商品款选择信息列表
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *naviView;

@property (nonatomic,strong)NSDictionary *data;

@property (nonatomic,copy)NSString *titleStr;
- (IBAction)cancelBtnClick:(id)sender;
- (IBAction)trueBtnClick:(id)sender;

@property (nonatomic,copy)NSMutableArray *collocaInfo;

@property (strong, nonatomic) NSDictionary *functionXML;//上下级过渡
@property (strong, nonatomic) NSDictionary *rootXML;

-(void)updateGoodsSelected:(id)cell;


@end
