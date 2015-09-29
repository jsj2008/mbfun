//
//  MyCollectionCell.m
//  newdesigner
//
//  Created by Miaoz on 14-9-28.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "MyCollectionCell.h"

@implementation MyCollectionCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MyCollectionCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        [_deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat borderWidth = 0.5f;
        self.layer.borderColor = [UIColor colorWithHexString:@"#e2e2e2"].CGColor;
        self.layer.borderWidth = borderWidth;
    }
    return self;
}


-(void)deleteClick:(id)sender{

    if (_delegate && [_delegate respondsToSelector:@selector(callBackMyCollectionCellWithCollocationInfo:)]) {
        [_delegate callBackMyCollectionCellWithCollocationInfo:_collocationInfo];
    }

}

- (void)awakeFromNib {
    // Initialization code
}

@end
