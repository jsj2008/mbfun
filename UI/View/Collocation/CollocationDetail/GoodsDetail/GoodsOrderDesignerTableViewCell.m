//
//  GoodsOrderDesignerTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-12-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "GoodsOrderDesignerTableViewCell.h"
#import "Utils.h"

@implementation GoodsOrderDesignerTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

-(void)setData:(NSDictionary *)data1
{
    //@{@"haulage":@(haulage),@"disamount":@(disamount),@"summery":@(summery)}
    _lbDesigner.text=[Utils getSNSString:data1[@"designername"]];
}

+(int)getCellHeight:(id)data1;
{
    return 55;
}

@end
