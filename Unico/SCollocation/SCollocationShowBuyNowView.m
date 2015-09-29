//
//  SCollocationShowBuyNowView.m
//  Wefafa
//
//  Created by unico_0 on 7/24/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SCollocationShowBuyNowView.h"
#import "SUtilityTool.h"
#import "Utils.h"
#import "MBAddShoppingViewController.h"
#import "SActivityPromPlatModel.h"
#import "SActivutyOptimalTool.h"

@interface SCollocationShowBuyNowView ()

@property (nonatomic, weak) UILabel *salePriceLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) CALayer *deleteLineLayer;
@property (nonatomic, weak) UIImageView *showSaleImageView;
@property (nonatomic, weak) UILabel *activityNameLabel;
@property (nonatomic, strong) UILabel *showNoneDataLabel;

@end

@implementation SCollocationShowBuyNowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    CGRect frame = CGRectInset(self.frame, 15, 15);
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.layer.cornerRadius = 2.0;
    view.layer.borderColor = COLOR_C1.CGColor;
    view.layer.borderWidth = 1;
    [self addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchBuyNowAction:)];
    [view addGestureRecognizer:tap];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(view.width - 125, 10, 115, view.height - 20)];
    button.userInteractionEnabled = NO;
    [button setImage:[UIImage imageNamed:@"Unico/u_dpg_b"] forState:UIControlStateNormal];
    [view addSubview:button];
    
    UIImageView *showSaleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(button.frame.origin.x - 15, 0, button.height + 8, button.height + 8)];
    showSaleImageView.contentMode = UIViewContentModeScaleAspectFit;
    showSaleImageView.centerY = CGRectGetMidY(button.frame);
    [view addSubview:showSaleImageView];
    _showSaleImageView = showSaleImageView;
    
    UILabel *activityLabel = [[UILabel alloc]initWithFrame:CGRectMake(showSaleImageView.left - 97, showSaleImageView.centerY + 7, 100, 15)];
    activityLabel.textColor = UIColorFromRGB(0x3b3b3b);
    activityLabel.font = [UIFont systemFontOfSize:10];
    activityLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:activityLabel];
    _activityNameLabel = activityLabel;
    
    UILabel *salePirceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 25)];
    salePirceLabel.textColor = COLOR_C10;
    salePirceLabel.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:salePirceLabel];
    _salePriceLabel = salePirceLabel;
    
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(salePirceLabel.frame) - 2, 200, 20)];
    price.textColor = COLOR_C6;
    price.font = FONT_t6;
    [view addSubview:price];
    _priceLabel = price;
    
    CALayer *deleteLineLayer = [CALayer layer];
    deleteLineLayer.backgroundColor = COLOR_C6.CGColor;
    deleteLineLayer.frame = CGRectMake(0, 10, 0, 1);
    deleteLineLayer.zPosition = 5;
    [price.layer addSublayer:deleteLineLayer];
    _deleteLineLayer = deleteLineLayer;
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 5, UI_SCREEN_WIDTH, 0.5);
    lineLayer.zPosition = 5;
    lineLayer.backgroundColor = COLOR_C7.CGColor;
    [self.layer addSublayer:lineLayer];
    
    _showNoneDataLabel = [[UILabel alloc]initWithFrame:frame];
    _showNoneDataLabel.backgroundColor = UIColorFromRGB(0xbbbbbb);
    _showNoneDataLabel.textColor = [UIColor whiteColor];
    _showNoneDataLabel.textAlignment = NSTextAlignmentCenter;
    _showNoneDataLabel.font = [UIFont boldSystemFontOfSize:17];
    _showNoneDataLabel.text = @"已售罄";
    _showNoneDataLabel.userInteractionEnabled = YES;
    _showNoneDataLabel.hidden = YES;
    [self addSubview:_showNoneDataLabel];
    UITapGestureRecognizer *lableTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchNoneDataLabel:)];
    [_showNoneDataLabel addGestureRecognizer:lableTap];
}

- (void)setContentModel:(SCollocationDetailModel *)contentModel{
    _contentModel = contentModel;
    self.salePriceLabel.text = [Utils getSNSRMBMoney:contentModel.sale_price.stringValue];
    NSString *priceString = [Utils getSNSRMBMoney:contentModel.price.stringValue];
    self.priceLabel.text = priceString;
    CGSize size = [priceString sizeWithAttributes:@{NSFontAttributeName : FONT_t6}];
    CGRect rect = _deleteLineLayer.frame;
    rect.size.width = size.width;
    _deleteLineLayer.frame = rect;
    
    [self settingActivityProPlat];
    
    int stockCount = 0;
    int stateCount = 0;
    for (MBGoodsDetailsModel *model in contentModel.productArray) {
        stockCount += model.clsInfo.stockCount.intValue <= 0? 1: 0;
        stateCount += model.clsInfo.status.intValue != 2? 1: 0;
    }
    if (stockCount == contentModel.productArray.count || stateCount == contentModel.productArray.count) {
        _showNoneDataLabel.hidden = NO;
    }else{
        _showNoneDataLabel.hidden = YES;
    }
}

- (void)touchNoneDataLabel:(UITapGestureRecognizer*)tap{
    
}

- (void)touchBuyNowAction:(UITapGestureRecognizer*)tap{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    MBAddShoppingViewController *controller = [[MBAddShoppingViewController alloc]initWithNibName:@"MBAddShoppingViewController" bundle:nil];
    controller.fromControllerName = _contentModel.fromControllerName;
    controller.promotion_ID = _contentModel.promotion_ID;
    controller.itemAry = _contentModel.itemIdArray;
    controller.collocationID = [NSString stringWithFormat:@"%@",_contentModel.aID];
    controller.mbCollocationID = _contentModel.mb_collocationId;
    [_target.navigationController pushViewController:controller animated:YES];
}

- (void)settingActivityProPlat{
    if (_contentModel.promPlatModelArray.count > 0) {
        _showSaleImageView.hidden = NO;
        SActivityPromPlatModel *promPlatModel = [_contentModel.promPlatModelArray firstObject];
        NSString *activityImageName = @"";
        if ([promPlatModel.commissioN_TYPE isEqualToString:@"RATE"]) {
            activityImageName = @"Unico/activity_type_discount.png";
        }else{
            activityImageName = @"Unico/activity_type_minus.png";
        }
        _showSaleImageView.image = [UIImage imageNamed:activityImageName];
        [self setTheMostEconomical];
    }else{
        _showSaleImageView.hidden = YES;
    }
}

- (void)setTheMostEconomical{
#pragma mark 优惠价格最优选择
    if (_contentModel.promPlatModelArray.count > 0) {
        SActivityPromPlatModel *promPlatModel = [_contentModel.promPlatModelArray firstObject];
        CGFloat param = 0;
        if ([promPlatModel.condition isEqualToString:@"FULLMONEY"]) {//满额优惠
            param = _contentModel.sale_price.floatValue;
        }else if ([promPlatModel.condition isEqualToString:@"FULLPRODCLS"]) {//满款优惠
            param = _contentModel.productArray.count;
        }
        NSDictionary *dict = [SActivutyOptimalTool activityOptimalForPromPlatModelArray:_contentModel.promPlatModelArray price:_contentModel.sale_price.floatValue paramer:param];
        self.salePriceLabel.text = dict[@"price"];
        _activityNameLabel.text = dict[@"activityName"];
    }
}


@end
