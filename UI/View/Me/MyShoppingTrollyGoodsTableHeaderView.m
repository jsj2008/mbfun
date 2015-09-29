//
//  MyShoppingTrollyGoodsTableHeaderView.m
//  Wefafa
//
//  Created by mac on 14-12-5.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MyShoppingTrollyGoodsTableHeaderView.h"
#import "SUtilityTool.h"
#import "utils.h"

@implementation MyShoppingTrollyGoodsTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
//        self.lbName.font = FONT_T3;
//        self.lbName.textColor = COLOR_C2;
        
//        self.lbSum.font = FONT_t6;
//        self.lbSum.textColor = COLOR_C1;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setPlatFormBasicInfo:(PlatFormBasicInfo *)platFormBasicInfo{
    _platFormBasicInfo = platFormBasicInfo;
    
    _lbSum.text = _platFormBasicInfo.price;

}
-(void)setPlatFormInfo:(PlatFormInfo *)platFormInfo{
    _platFormInfo = platFormInfo;
    _lbSum.text = platFormInfo.promName;
}
- (void)awakeFromNib
{
//    _lbName.textColor=[Utils HexColor:0x353535 Alpha:1.0];
//    _lbSum.textColor=[Utils HexColor:0x353535 Alpha:1.0];
    [super awakeFromNib];
    
//    self.lbName.font = FONT_T3;
//    self.lbName.textColor = COLOR_C2;
//    
//    self.lbSum.font = FONT_t6;
//    self.lbSum.textColor = COLOR_C12;
}

- (IBAction)btnSelectedClick:(id)sender {

      [_delegate headerSelectAllButtonClick:self button:sender sectionIndex:_sectionIndex];
   
}

- (IBAction)backGroundbtnSelectedClick:(id)sender {
    if (self.arrowRightImgView.hidden==YES) {
        
    }
    else
    {
       [_delegate headerBackgroundSelectAllButtonClick:self button:sender sectionIndex:_sectionIndex];
        
    }
}
@end
