//
//  SItemFilterCell.m
//  Wefafa
//
//  Created by unico on 15/5/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SItemFilterCell.h"
#import "SUtilityTool.h"

@interface SItemFilterCell()

@property (nonatomic, strong) NSMutableArray *contentTagBtnArray;

@end

@implementation SItemFilterCell
#define BUTTON_BASE_TAG 10000
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.dataList = @[@"≦¥100",@"¥101≦300",@"¥301≦500",@"¥501≦1000",@"¥1000≦"];
    float offset = 30/2;
    UIButton *tempBtn;
    UILabel *tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"价格" fontStyle:FONT_SIZE(17) color:nil rect:CGRectMake(34/2, offset, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [self addSubview:tempLabel];
    offset += tempLabel.height;
    offset += 30/2;
    float tempfloat = (UI_SCREEN_WIDTH - 44 - 90)/3;
    int tempInt =0;
    for (int i = 0; i<[self.dataList count]; i++) {
        if (i>0 && i%3 == 0) {
            offset += 72/2+20/2;
            tempInt = 3;
        }
        tempBtn = [SUTILITY_TOOL_INSTANCE createTitleButtonAction:self.dataList[i] bgColor:nil fontColor:COLOR_BLACK fontStyle:FONT_SIZE(10) rect:CGRectMake(44/2+(i-tempInt)*(tempfloat+90/2), offset, tempfloat, 72/2) target:self action:@selector(selectFilter:)];
        tempBtn.tag = 10000+i;
        [tempBtn.layer setBorderWidth:1];
        if (i == 0) {
             tempBtn.backgroundColor = UIColorFromRGB(0xFEDC32);
        }
        [tempBtn.layer setBorderColor:UIColorFromRGB(0xc4c4c4).CGColor];
        [self addSubview:tempBtn];
    }
    offset += tempBtn.height +20/2;
    self.cellHeight = offset;
    
    self.backgroundColor = COLOR_WHITE;
    //选择无模式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

-(void)selectFilter:(id)selector{
    UIButton *tempButton = (UIButton*)selector;
    long tag = tempButton.tag;
    
    UIColor *tempColor;
    int type = (int)(tag - BUTTON_BASE_TAG);
    if (type > self.dataList.count || type < 0) {
        return;
    }
    for (int i = 0; i<self.dataList.count; i++) {
        tempButton = (UIButton*)[self viewWithTag:(BUTTON_BASE_TAG+i)];
        if (i == type) {
            tempColor = UIColorFromRGB(0xFEDC32);
        }else{
            tempColor = COLOR_WHITE;
        }
        [tempButton setBackgroundColor:tempColor];
    }

    NSLog(@"%ld",tag);
}
@end

