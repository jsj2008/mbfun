//
//  OrderViewTableViewCell.h
//  Wefafa
//
//  Created by fafatime on 14-8-22.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUrlImageView.h"

//#import "CommonEventHandler.h"
@interface OrderViewTableViewCell : UITableViewCell
{
    
}
//@property(nonatomic,readonly,retain) CommonEventHandler *onDidCancleRow; //行删除

//@property(nonatomic,retain) NSDictionary *param;

@property(nonatomic,retain)UILabel *orderLabel;
@property(nonatomic,retain)UILabel *orderNoLabel;
@property(nonatomic,retain)UILabel *goodNameLabel;
@property(nonatomic,retain)UIUrlImageView *goodImgView;
@property(nonatomic,retain)UILabel *colcorLabel;
@property(nonatomic,retain)UILabel *sizeLabel;
@property(nonatomic,retain)UILabel *brandLabel;
@property(nonatomic,retain)UILabel *priceLabel;
@property(nonatomic,retain)UILabel *numberLabel;
@property(nonatomic,retain)UILabel *transPriceLabel;
@property(nonatomic,retain)UILabel *allPriceLabel;
@property(nonatomic,assign)UIButton *cancleBtn;
@property(nonatomic,assign)UIButton *goOrder;
@property(nonatomic,assign)UIButton *transBtn;
@property(nonatomic,retain)UILabel *statesLabel;
@property(nonatomic,retain)UILabel *showNumberLabel;
@property(nonatomic,retain)UILabel *khLabel;
@property (nonatomic,retain)UILabel *showSalePriceLabel;

- (void)updateCellContentWithDict:(NSDictionary *)dict;

@end
