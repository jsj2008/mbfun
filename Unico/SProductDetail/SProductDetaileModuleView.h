//
//  SProductDetaileModuleView.h
//  Wefafa
//
//  Created by unico_0 on 7/21/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBGoodsDetailsModel;

@protocol SProductDetaileModuleViewDelegate <NSObject>

- (void)SProductDetaileModuleViewDidScroll:(UIScrollView *)scrollView;
- (void)SProductDetaileModuleViewaddHeaderJump;

@end



@interface SProductDetaileModuleView : UIView

@property (weak, nonatomic) id<SProductDetaileModuleViewDelegate> detailModuleDelegate;

@property (weak, nonatomic) IBOutlet UILabel *editerLb;
@property (weak, nonatomic) IBOutlet UIView *lineLb;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel; // 编辑推荐
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;   // 品牌
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel; // 款名
@property (weak, nonatomic) IBOutlet UILabel *productCodeLabel; // 款号
@property (weak, nonatomic) IBOutlet UIView *productDetailContentView;  // 商品信息

@property (nonatomic, strong) MBGoodsDetailsModel *contentModel;
- (CGFloat)getAllImageHeightWith:(NSArray*)modelArray;

@end
