//
//  MyShoppingTrollyGoodsTableHeaderView
//  Wefafa
//
//  Created by mac on 14-12-5.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyShoppingTrollyGoodsTableViewCell.h"
#import "PlatFormBasicInfo.h"


@protocol MyShoppingTrollyGoodsTableHeaderViewDelegate <NSObject>

@optional
-(void)headerSelectAllButtonClick:(id)sender button:(UIButton *)button sectionIndex:(int)sectionIndex;

-(void)headerBackgroundSelectAllButtonClick:(id)sender button:(UIButton *)button sectionIndex:(int)sectionIndex;

@end

@interface MyShoppingTrollyGoodsTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbSum;
@property (weak, nonatomic) IBOutlet UIButton *btnSelected;
@property (assign, nonatomic) int sectionIndex;
@property (weak, nonatomic) IBOutlet UIImageView *arrowRightImgView;

@property (weak, nonatomic) IBOutlet UIButton *bgButton;
@property (assign, nonatomic) id<MyShoppingTrollyGoodsTableHeaderViewDelegate> delegate;

@property(nonatomic,strong)PlatFormBasicInfo *platFormBasicInfo;
@property(nonatomic,strong)PlatFormInfo *platFormInfo;


- (IBAction)btnSelectedClick:(id)sender;
- (IBAction)backGroundbtnSelectedClick:(id)sender;

@end
