//
//  MyOrderViewTableViewCell.h
//  Wefafa
//
//  Created by fafatime on 14-8-16.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUrlImageView.h"
#import "OrderBtn.h"

@protocol MyOrderViewTableViewCellDelegate <NSObject>

- (void)MyOrderViewTableViewCellReturnButtonAction:(OrderBtn*)sender;

@end


@interface MyOrderViewTableViewCell : UITableViewCell
{
    
}
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
@property(nonatomic,retain)OrderBtn *returnBtn;
@property(nonatomic,retain)OrderBtn *cancleReply;
@property(nonatomic,retain)UIView *appriseView;
@property(nonatomic,retain) UITextField *writeTextfield;
//@property(nonatomic,readonly,retain) CommonEventHandler *onDidSelectedbBtn; //行选中

@property(nonatomic,retain) OrderBtn *oneStarBtn;
@property(nonatomic,retain) OrderBtn *twoStarBtn;
@property(nonatomic,retain) OrderBtn *threeStarBtn;
@property(nonatomic,retain) OrderBtn *fourStarBtn;
@property(nonatomic,retain) OrderBtn *fiveStarBtn;

@property (nonatomic, assign) id<MyOrderViewTableViewCellDelegate> delegate;
@end
